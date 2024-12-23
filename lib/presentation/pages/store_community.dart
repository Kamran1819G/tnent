import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:share_plus/share_plus.dart';
import 'package:tnent/models/community_post_model.dart';
import 'package:tnent/models/store_model.dart';
import 'package:tnent/core/helpers/color_utils.dart';
import 'package:tnent/presentation/pages/home_pages/community.dart';
import 'package:tnent/presentation/widgets/full_screen_image_view.dart';

import '../../core/helpers/snackbar_utils.dart';

class StoreCommunity extends StatefulWidget {
  final StoreModel store;

  const StoreCommunity({Key? key, required this.store}) : super(key: key);

  @override
  State<StoreCommunity> createState() => _StoreCommunityState();
}

class _StoreCommunityState extends State<StoreCommunity> {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  FirebaseAuth _auth = FirebaseAuth.instance;
  List<CommunityPostModel> _posts = [];
  bool _isLoading = true;
  bool _isStoreOwner = false;

  @override
  void initState() {
    super.initState();
    _fetchPosts();
    _checkStoreOwnership();
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

  Future<void> _checkStoreOwnership() async {
    final user = _auth.currentUser;
    if (user == null) return;

    try {
      DocumentSnapshot userDoc =
          await _firestore.collection('Users').doc(user.uid).get();
      if (userDoc.exists) {
        String? userStoreId = userDoc.get('storeId') as String?;
        if (userStoreId == widget.store.storeId) {
          setState(() {
            _isStoreOwner = true;
          });
          return;
        }
      }

      DocumentSnapshot storeDoc =
          await _firestore.collection('Stores').doc(widget.store.storeId).get();
      if (storeDoc.exists) {
        String? ownerId = storeDoc.get('ownerId') as String?;
        setState(() {
          _isStoreOwner = (ownerId == user.uid);
        });
      }
    } catch (e) {
      print('Error checking store ownership: $e');
    }
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
              height: 100.h,
              margin: EdgeInsets.only(top: 20.h, bottom: 20.h),
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Row(
                children: [
                  Container(
                    height: 100.h,
                    width: 160.w,
                    decoration: BoxDecoration(
                      border:
                          Border.all(color: hexToColor('#BEBEBE'), width: 1.0),
                      borderRadius: BorderRadius.circular(25.r),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          _posts.length.toString(),
                          style: TextStyle(
                            color: hexToColor('#343434'),
                            fontSize: 35.sp,
                          ),
                        ),
                        Text(
                          'Posts',
                          style: TextStyle(
                            color: hexToColor('#7D7D7D'),
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w700,
                            fontSize: 19.sp,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Spacer(),
                  IconButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                        Colors.grey[100],
                      ),
                      shape: MaterialStateProperty.all(
                        CircleBorder(),
                      ),
                    ),
                    icon: Icon(Icons.arrow_back_ios_new, color: Colors.black),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            ),
            Expanded(
              child: _isLoading
                  ? Center(child: CircularProgressIndicator())
                  : _posts.isEmpty
                      ? _buildNoPostsFound()
                      : RefreshIndicator(
                          onRefresh: _fetchPosts,
                          child: ListView.builder(
                            itemCount: _posts.length,
                            itemBuilder: (context, index) {
                              final post = _posts[index];
                              return CommunityPost(
                                post: post,
                                isStoreOwner: _isStoreOwner,
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

  Widget _buildNoPostsFound() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (_isStoreOwner)
            IconButton(
              icon: Icon(Icons.add_circle_outline,
                  size: 75.sp, color: Theme.of(context).primaryColor),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        CreateCommunityPost(storeId: widget.store.storeId),
                  ),
                );
              },
            ),
          SizedBox(height: 20.h),
          Text(
            'No posts found',
            style: TextStyle(
              fontSize: 30.sp,
              color: hexToColor('#737373'),
            ),
          ),
          SizedBox(height: 12.h),
          Text(
            'Create a new post to get started',
            style: TextStyle(
              fontSize: 20.sp,
              color: hexToColor('#989898'),
            ),
          ),
        ],
      ),
    );
  }
}

class CommunityPost extends StatefulWidget {
  final CommunityPostModel post;
  final bool isStoreOwner;

  CommunityPost({required this.post, required this.isStoreOwner});

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
    _storeFuture =
        _firestore.collection('Stores').doc(widget.post.storeId).get();
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

    final postRef =
        _firestore.collection('communityPosts').doc(widget.post.postId);

    if (_isLiked) {
      await userLikedPostRef.set({});
      await postRef.update({'likes': FieldValue.increment(1)});
    } else {
      await userLikedPostRef.delete();
      await postRef.update({'likes': FieldValue.increment(-1)});
    }
  }

  Future<void> _sharePost() async {
    final String postUrl = 'https://tnent.com/post/${widget.post.postId}';
    final String shareText = 'Check out this post: $postUrl';

    await Share.share(shareText);
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

        final store = StoreModel.fromFirestore(snapshot.data!);
        final userName = store.name;
        final userProfileImage = store.logoUrl;

        return _buildPostContent(userName, userProfileImage);
      },
    );
  }

  Widget _buildPostContent(String userName, String userProfileImage) {
    return Container(
      padding: EdgeInsets.all(24.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildUserInfo(userName, userProfileImage),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 24.h),
            child: Text(
              widget.post.content,
              style: TextStyle(
                color: hexToColor('#737373'),
                fontFamily: 'Gotham Black',
                fontSize: 20.sp,
              ),
            ),
          ),
          if (widget.post.images.isNotEmpty) _buildImageGallery(),
          SizedBox(height: 10.h),
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
          radius: 33.w,
        ),
        SizedBox(width: 22.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                userName,
                style: TextStyle(fontSize: 30.sp),
              ),
              Text(
                _formatTimestamp(widget.post.createdAt),
                style: TextStyle(
                  color: hexToColor('#C1C1C1'),
                  fontSize: 15.sp,
                ),
              ),
            ],
          ),
        ),
        GestureDetector(
          onTap: () => _showMoreOptions(),
          child: CircleAvatar(
            radius: 25.w,
            backgroundColor: hexToColor('#F5F5F5'),
            child: Icon(
              Icons.more_horiz,
              color: hexToColor('#BEBEBE'),
              size: 26.sp,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildImageGallery() {
    return Container(
      height: 345.h,
      width: 598.w,
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
                  placeholder: (context, url) =>
                      Center(child: CircularProgressIndicator()),
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
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 6.h),
            decoration: BoxDecoration(
              border: Border.all(color: hexToColor('#BEBEBE')),
              borderRadius: BorderRadius.circular(25.r),
            ),
            child: Row(
              children: [
                AnimatedSwitcher(
                  duration: Duration(milliseconds: 300),
                  transitionBuilder:
                      (Widget child, Animation<double> animation) {
                    return ScaleTransition(scale: animation, child: child);
                  },
                  child: Icon(
                    _isLiked ? Icons.favorite : Icons.favorite_border,
                    key: ValueKey<bool>(_isLiked),
                    color: _isLiked ? Colors.red : hexToColor('#BEBEBE'),
                    size: 30.sp,
                  ),
                ),
                SizedBox(width: 12.w),
                Text(
                  '$_likeCount',
                  style:
                      TextStyle(color: hexToColor('#989797'), fontSize: 17.sp),
                ),
              ],
            ),
          ),
        ),
        Spacer(),
        IconButton(
          icon: Icon(
            Icons.ios_share_outlined,
            size: 30.sp,
          ),
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
      builder: (context) => widget.isStoreOwner
          ? _buildMoreBottomSheet()
          : _buildReportBottomSheet(),
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
              await CommunityPostModel.deletePost(
                  widget.post.postId, widget.post.storeId);
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

  Widget _buildReportBottomSheet() {
    return Container(
      height: 250,
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            backgroundColor: hexToColor('#2B2B2B'),
            child: Icon(
              Icons.report_gmailerrorred,
              color: hexToColor('#BEBEBE'),
              size: 20,
            ),
          ),
          SizedBox(height: 20),
          Text(
            'Report',
            style: TextStyle(
              color: hexToColor('#9B9B9B'),
              fontSize: 16.0,
            ),
          ),
        ],
      ),
    );
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
        showSnackBar(context,
            'The selected image is too large. Please select an image smaller than 500 KB.');
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
      );

      await CommunityPostModel.updatePost(updatedPost);

      showSnackBar(context, 'Post updated successfully!');

      Navigator.pop(context);
    } catch (e) {
      showSnackBar(context, 'Error updating post: $e');
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
                                                : NetworkImage(_images[index])
                                                    as ImageProvider,
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
