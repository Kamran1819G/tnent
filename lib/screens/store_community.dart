import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tnennt/models/community_post_model.dart';
import 'package:tnennt/models/store_model.dart';
import 'package:tnennt/helpers/color_utils.dart';
import 'package:tnennt/widgets/full_screen_image_view.dart';

class StoreCommunity extends StatefulWidget {
  final StoreModel store;

  const StoreCommunity({Key? key, required this.store}) : super(key: key);

  @override
  State<StoreCommunity> createState() => _StoreCommunityState();
}

class _StoreCommunityState extends State<StoreCommunity> {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<CommunityPostModel> _posts = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchPosts();
  }

  Future<void> _fetchPosts() async {
    setState(() {
      _isLoading = true;
    });
    final posts = await fetchPostsByStore(widget.store);
    setState(() {
      _posts = posts;
      _isLoading = false;
    });
  }

  Future<List<CommunityPostModel>> fetchPostsByStore(StoreModel store) async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('communityPosts')
          .where('storeId', isEqualTo: store.storeId)
          .orderBy('createdAt', descending: true)
          .get();

      return querySnapshot.docs
          .map((doc) => CommunityPostModel.fromFirestore(doc))
          .toList();
    } catch (e) {
      print('Error fetching posts: $e');
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Container(
              height: 100,
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  Container(
                    height: 75,
                    width: 100,
                    padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                    decoration: BoxDecoration(
                      border: Border.all(color: hexToColor('#BEBEBE'), width: 1.0),
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '${widget.store.totalPosts}',
                          style: TextStyle(
                            color: hexToColor('#343434'),
                            fontSize: 20.0,
                          ),
                        ),
                        Text(
                          'Posts',
                          style: TextStyle(
                            color: hexToColor('#7D7D7D'),
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w700,
                            fontSize: 14.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Spacer(),
                  Container(
                    margin: EdgeInsets.all(8.0),
                    child: CircleAvatar(
                      backgroundColor: hexToColor('#F5F5F5'),
                      child: IconButton(
                        icon: Icon(Icons.arrow_back_ios, color: Colors.black),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ),
                  )
                ],
              ),
            ),
            Expanded(
              child: _isLoading
                  ? Center(child: CircularProgressIndicator())
                  : RefreshIndicator(
                onRefresh: _fetchPosts,
                child: ListView.builder(
                  itemCount: _posts.length,
                  itemBuilder: (context, index) {
                    final post = _posts[index];
                    return CommunityPost(
                      post: post,
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatPostTime(Timestamp timestamp) {
    final now = DateTime.now();
    final postTime = timestamp.toDate();
    final difference = now.difference(postTime);

    if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }
}

class CommunityPost extends StatefulWidget {
  final CommunityPostModel post;

  CommunityPost({required this.post});

  @override
  _CommunityPostState createState() => _CommunityPostState();
}

class _CommunityPostState extends State<CommunityPost> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late Future<DocumentSnapshot> _storeFuture;
  bool _isLiked = false;
  int _likeCount = 0;

  @override
  void initState() {
    super.initState();
    _storeFuture = _firestore.collection('Stores').doc(widget.post.storeId).get();
    _likeCount = widget.post.likes;
    _checkIfLiked();
  }

  Future<void> _checkIfLiked() async {
    final user = _auth.currentUser;
    if (user == null) return;

    final likedPostsDoc = await _firestore
        .collection('Users')
        .doc(user.uid)
        .collection('likedPosts')
        .doc(widget.post.postId)
        .get();

    setState(() {
      _isLiked = likedPostsDoc.exists;
    });
  }

  Future<void> _toggleLike() async {
    final user = _auth.currentUser;
    if (user == null) return;

    setState(() {
      _isLiked = !_isLiked;
      _likeCount += _isLiked ? 1 : -1;
    });

    final userLikedPostRef = _firestore
        .collection('Users')
        .doc(user.uid)
        .collection('likedPosts')
        .doc(widget.post.postId);

    final postRef = _firestore.collection('communityPosts').doc(widget.post.postId);

    if (_isLiked) {
      await userLikedPostRef.set({});
      await postRef.update({'likes': FieldValue.increment(1)});
    } else {
      await userLikedPostRef.delete();
      await postRef.update({'likes': FieldValue.increment(-1)});
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot>(
      future: _storeFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _buildLoadingPlaceholder();
        }

        if (!snapshot.hasData || !snapshot.data!.exists) {
          return SizedBox.shrink();
        }

        final storeData = snapshot.data!.data() as Map<String, dynamic>;
        final userName = storeData['name'] ?? 'Unknown User';
        final userProfileImage = storeData['profileImage'] ?? 'https://via.placeholder.com/150';

        return _buildPostContent(userName, userProfileImage);
      },
    );
  }

  Widget _buildPostContent(String userName, String userProfileImage) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildUserInfo(userName, userProfileImage),
          SizedBox(height: 16.0),
          Text(
            widget.post.content,
            style: TextStyle(
              color: Colors.black,
              fontFamily: 'Gotham',
              fontSize: 12.0,
            ),
          ),
          SizedBox(height: 10),
          if (widget.post.images.isNotEmpty) _buildImageGallery(),
          SizedBox(height: 10),
          _buildInteractionBar(),
        ],
      ),
    );
  }

  Widget _buildUserInfo(String userName, String userProfileImage) {
    return Row(
      children: [
        CircleAvatar(
          backgroundImage: CachedNetworkImageProvider(userProfileImage),
          radius: 20.0,
        ),
        const SizedBox(width: 16.0),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                userName,
                style: const TextStyle(fontSize: 18.0),
              ),
              Text(
                _formatTimestamp(widget.post.createdAt),
                style: TextStyle(
                  color: hexToColor('#9C9C9C'),
                  fontSize: 10.0,
                ),
              ),
            ],
          ),
        ),
        GestureDetector(
          onTap: () => _showMoreOptions(),
          child: CircleAvatar(
            backgroundColor: hexToColor('#F5F5F5'),
            child: Icon(
              Icons.more_horiz,
              color: hexToColor('#BEBEBE'),
              size: 20,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildImageGallery() {
    return Container(
      height: 200.0,
      child: PageView.builder(
        itemCount: widget.post.images.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () => _showFullScreenImage(widget.post.images[index]),
            child: Hero(
              tag: 'postImage${widget.post.postId}$index',
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: CachedNetworkImage(
                  imageUrl: widget.post.images[index],
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Center(child: CircularProgressIndicator()),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildInteractionBar() {
    return Row(
      children: [
        GestureDetector(
          onTap: _toggleLike,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 6.0),
            decoration: BoxDecoration(
              border: Border.all(color: hexToColor('#BEBEBE')),
              borderRadius: BorderRadius.circular(50.0),
            ),
            child: Row(
              children: [
                AnimatedSwitcher(
                  duration: Duration(milliseconds: 300),
                  transitionBuilder: (Widget child, Animation<double> animation) {
                    return ScaleTransition(scale: animation, child: child);
                  },
                  child: Icon(
                    _isLiked ? Icons.favorite : Icons.favorite_border,
                    key: ValueKey<bool>(_isLiked),
                    color: _isLiked ? Colors.red : hexToColor('#BEBEBE'),
                  ),
                ),
                const SizedBox(width: 8.0),
                Text(
                  '$_likeCount',
                  style: TextStyle(color: hexToColor('#989797'), fontSize: 12.0),
                ),
              ],
            ),
          ),
        ),
        Spacer(),
        if (widget.post.productLink?.isNotEmpty ?? false)
          Chip(
            backgroundColor: hexToColor('#EDEDED'),
            side: BorderSide.none,
            label: Text(
              '${widget.post.productLink!}',
              style: TextStyle(
                color: hexToColor('#B4B4B4'),
                fontFamily: 'Gotham',
                fontWeight: FontWeight.w500,
                fontSize: 12.0,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            avatar: Icon(
              Icons.link_outlined,
              color: hexToColor('#B4B4B4'),
            ),
          ),
        Spacer(),
        IconButton(
          icon: Icon(Icons.ios_share_outlined),
          onPressed: () => _sharePost(),
        ),
      ],
    );
  }

  void _showFullScreenImage(String imageUrl) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FullScreenImageView(imageUrl: imageUrl),
      ),
    );
  }

  void _showMoreOptions() {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => _buildMoreBottomSheet(),
    );
  }

  Widget _buildMoreBottomSheet() {
    return Container(
      height: 250,
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditCommunityPost(post: widget.post),
                ),
              );
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 42.w,
                  backgroundColor: hexToColor('#2B2B2B'),
                  child: Icon(
                    Icons.edit_outlined,
                    color: hexToColor('#BEBEBE'),
                    size: 20,
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  'Edit',
                  style: TextStyle(
                    color: hexToColor('#9B9B9B'),
                    fontSize: 16.0,
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () async {
              await CommunityPostModel.deletePost(widget.post.postId, widget.post.storeId);
              Navigator.pop(context);
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 42.w,
                  backgroundColor: hexToColor('#2B2B2B'),
                  child: Icon(
                    CupertinoIcons.delete,
                    color: hexToColor('#BEBEBE'),
                    size: 20,
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  'Delete',
                  style: TextStyle(
                    color: hexToColor('#9B9B9B'),
                    fontSize: 16.0,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _sharePost() {
    // Implement share functionality
  }

  Widget _buildLoadingPlaceholder() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // User information row
          Row(
            children: [
              CircleAvatar(
                backgroundColor: Colors.grey,
                radius: 20.0,
              ),
              const SizedBox(width: 16.0),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 100.0,
                    height: 10.0,
                    color: Colors.grey,
                  ),
                  const SizedBox(height: 5.0),
                  Container(
                    width: 50.0,
                    height: 10.0,
                    color: Colors.grey,
                  ),
                ],
              ),
              const Spacer(),
              Container(
                width: 20.0,
                height: 20.0,
                color: Colors.grey,
              ),
            ],
          ),
          const SizedBox(height: 10.0),
          Container(
            width: double.infinity,
            height: 200.0,
            color: Colors.grey,
          ),
          const SizedBox(height: 10.0),
          Row(
            children: [
              Container(
                width: 50.0,
                height: 20.0,
                color: Colors.grey,
              ),
              const Spacer(),
              Container(
                width: 20.0,
                height: 20.0,
                color: Colors.grey,
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatTimestamp(Timestamp timestamp) {
    final now = DateTime.now();
    final postTime = timestamp.toDate();
    final difference = now.difference(postTime);

    if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }
}

class EditCommunityPost extends StatefulWidget {
  final CommunityPostModel post;

  EditCommunityPost({required this.post});

  @override
  State<EditCommunityPost> createState() => _EditCommunityPostState();
}

class _EditCommunityPostState extends State<EditCommunityPost> {
  List<dynamic> _images = [];
  final TextEditingController _captionController = TextEditingController();
  final TextEditingController _productLinkController = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _captionController.text = widget.post.content;
    _productLinkController.text = widget.post.productLink ?? '';
    _images = List.from(widget.post.images);
  }

  Future<void> pickImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      final File file = File(image.path);
      final int fileSize = await file.length();

      const int maxSizeInBytes = 500 * 1024; // 500 KB

      if (fileSize <= maxSizeInBytes) {
        setState(() {
          _images.add(file);
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                'The selected image is too large. Please select an image smaller than 500 KB.'),
          ),
        );
      }
    }
  }

  Future<List<String>> _uploadNewImages() async {
    List<String> imageUrls = [];
    final storage = FirebaseStorage.instance;
    final user = FirebaseAuth.instance.currentUser;

    for (var image in _images) {
      if (image is File) {
        final fileName =
            '${DateTime.now().millisecondsSinceEpoch}_${user!.uid}.jpg';
        final Reference storageRef =
        storage.ref().child('community_posts/$fileName');

        try {
          await storageRef.putFile(image);
          final String downloadUrl = await storageRef.getDownloadURL();
          imageUrls.add(downloadUrl);
        } catch (e) {
          print('Error uploading image: $e');
        }
      } else if (image is String) {
        // This is an existing image URL, keep it as is
        imageUrls.add(image);
      }
    }

    return imageUrls;
  }

  Future<void> _updatePost() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) throw Exception('User not logged in');

      List<String> imageUrls = await _uploadNewImages();

      final updatedPost = CommunityPostModel(
        postId: widget.post.postId,
        storeId: widget.post.storeId,
        content: _captionController.text,
        images: imageUrls,
        likes: widget.post.likes,
        createdAt: widget.post.createdAt,
        productLink: _productLinkController.text.isNotEmpty
            ? _productLinkController.text
            : null,
      );

      await CommunityPostModel.updatePost(updatedPost);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Post updated successfully!')),
      );
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error updating post: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                height: 100,
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  children: [
                    Row(
                      children: [
                        Text(
                          'Edit Post'.toUpperCase(),
                          style: TextStyle(
                            color: hexToColor('#1E1E1E'),
                            fontSize: 24.0,
                            letterSpacing: 1.5,
                          ),
                        ),
                        Text(
                          ' •',
                          style: TextStyle(
                            fontSize: 28.0,
                            color: hexToColor('#FF0000'),
                          ),
                        ),
                      ],
                    ),
                    Spacer(),
                    Container(
                      margin: EdgeInsets.all(8.0),
                      child: CircleAvatar(
                        backgroundColor: hexToColor('#F5F5F5'),
                        child: IconButton(
                          icon: Icon(Icons.arrow_back_ios_rounded,
                              color: Colors.black),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(height: 20),
              // Add Image
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Add Image',
                      style:
                      TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
                    ),
                    SizedBox(height: 10),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () {
                            if (_images.length < 3) {
                              pickImage();
                            }
                          },
                          child: Container(
                            height: 75,
                            width: 75,
                            decoration: BoxDecoration(
                              border: Border.all(color: hexToColor('#848484')),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Center(
                              child: Icon(
                                Icons.image_outlined,
                                size: 40,
                                color: hexToColor('#545454'),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 10),
                        if (_images.isNotEmpty)
                          Expanded(
                            child: SizedBox(
                              height: 75,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount:
                                _images.length > 3 ? 3 : _images.length,
                                itemBuilder: (context, index) {
                                  return Stack(
                                    children: [
                                      Container(
                                        width: 75,
                                        margin:
                                        const EdgeInsets.only(right: 10),
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                              color: hexToColor('#848484')),
                                          borderRadius:
                                          BorderRadius.circular(12),
                                          image: DecorationImage(
                                            image: _images[index] is File
                                                ? FileImage(_images[index])
                                                : NetworkImage(_images[index]) as ImageProvider,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        top: 0,
                                        right: 0,
                                        child: GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              _images.removeAt(index);
                                            });
                                          },
                                          child: Container(
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: Colors.red,
                                            ),
                                            child: Icon(
                                              Icons.close,
                                              color: Colors.white,
                                              size: 16,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              ),
                            ),
                          ),
                        if (_images.isEmpty)
                          Container(
                            width: MediaQuery.of(context).size.width * 0.5,
                            child: Text(
                              'Note: You can add up to 3 images, and the file size should not exceed 500 KB.',
                              style: TextStyle(
                                fontSize: 10,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w500,
                                color: hexToColor('#636363'),
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 50),
              // Caption
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Caption',
                      style:
                      TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
                    ),
                    SizedBox(height: 20),
                    TextField(
                      controller: _captionController,
                      textAlign: TextAlign.start,
                      maxLines: 5,
                      maxLength: 700,
                      decoration: InputDecoration(
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        labelText: 'Description',
                        labelStyle: TextStyle(
                          color: hexToColor('#545454'),
                          fontSize: 16.0,
                        ),
                        hintText: 'Write a caption...',
                        hintStyle: TextStyle(
                          color: hexToColor('#989898'),
                          fontFamily: 'Gotham',
                          fontWeight: FontWeight.w500,
                          fontSize: 16.0,
                        ),
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: hexToColor('#848484'),
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              // Product Link
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Product Link',
                      style:
                      TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
                    ),
                    SizedBox(height: 10),
                    TextField(
                      controller: _productLinkController,
                      textAlign: TextAlign.start,
                      decoration: InputDecoration(
                        prefixIcon: Icon(
                          Icons.add_link,
                          color: hexToColor('#848484'),
                        ),
                        hintText: 'Paste the product link...',
                        hintStyle: TextStyle(
                          color: hexToColor('#989898'),
                          fontFamily: 'Gotham',
                          fontWeight: FontWeight.w500,
                          fontSize: 16.0,
                        ),
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: hexToColor('#848484'),
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 100),
              Center(
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _updatePost,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: hexToColor('#2D332F'),
                    foregroundColor: Colors.white,
                    padding:
                    EdgeInsets.symmetric(horizontal: 100, vertical: 18),
                    textStyle: TextStyle(
                      fontSize: 16,
                      fontFamily: 'Gotham',
                      fontWeight: FontWeight.w500,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: _isLoading
                      ? CircularProgressIndicator(color: Colors.white)
                      : Text('Update Post', style: TextStyle(fontSize: 16)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
