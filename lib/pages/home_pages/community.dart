import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:tnennt/models/community_post_model.dart';
import 'package:tnennt/widgets/full_screen_image_view.dart';
import '../../helpers/color_utils.dart';

class Community extends StatefulWidget {
  const Community({Key? key}) : super(key: key);

  @override
  _CommunityState createState() => _CommunityState();
}

class _CommunityState extends State<Community> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late String storeId;
  bool _hasStoreId = false;

  @override
  void initState() {
    super.initState();
    _checkUserStoreId();
  }

  Future<void> _checkUserStoreId() async {
    final user = _auth.currentUser;
    if (user != null) {
      final userDoc = await _firestore.collection('Users').doc(user.uid).get();
      setState(() {
        storeId = userDoc.data()?['storeId'] ?? '';
        _hasStoreId = storeId.isNotEmpty;
      });
    }
  }

  Stream<List<DocumentSnapshot>> getCommunityPosts() {
    return _firestore
        .collection('communityPosts')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      child: Column(
        children: <Widget>[
          Container(
            height: 100,
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                Row(
                  children: [
                    Text(
                      'Community'.toUpperCase(),
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
                if (_hasStoreId)
                  Container(
                    margin: EdgeInsets.all(8.0),
                    child: CircleAvatar(
                      backgroundColor: hexToColor('#F5F5F5'),
                      child: IconButton(
                        icon: Icon(Icons.create_outlined, color: Colors.black),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => CreateCommunityPost(
                                      storeId: storeId,
                                    )),
                          );
                        },
                      ),
                    ),
                  )
              ],
            ),
          ),
          Expanded(
            child: StreamBuilder<List<DocumentSnapshot>>(
              stream: getCommunityPosts(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('No posts available'));
                }
                return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    final postData =
                        snapshot.data![index].data() as Map<String, dynamic>;
                    final postId = snapshot.data![index].id;
                    return CommunityPost(
                      postId: postId,
                      storeId: postData['storeId'] ?? '',
                      postContent: postData['postContent'] ?? '',
                      postImages:
                          List<String>.from(postData['postImages'] ?? []),
                      postLikes: postData['postLikes'] ?? 0,
                      productLink: postData['productLink'],
                      createdAt: postData['createdAt'] as Timestamp,
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class CommunityPost extends StatefulWidget {
  final String postId;
  final String storeId;
  final String postContent;
  final List<String> postImages;
  final int postLikes;
  final String? productLink;
  final Timestamp createdAt;

  const CommunityPost({
    Key? key,
    required this.postId,
    required this.storeId,
    required this.postContent,
    required this.postImages,
    required this.postLikes,
    this.productLink,
    required this.createdAt,
  }) : super(key: key);

  @override
  _CommunityPostState createState() => _CommunityPostState();
}

class _CommunityPostState extends State<CommunityPost> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late Future<DocumentSnapshot> _storeFuture;

  @override
  void initState() {
    super.initState();
    _storeFuture = _firestore.collection('Stores').doc(widget.storeId).get();
  }

  Future<void> _likePost() async {
    final user = _auth.currentUser;
    if (user == null) return;

    final postRef = _firestore.collection('communityPosts').doc(widget.postId);

    return _firestore.runTransaction((transaction) async {
      final postDoc = await transaction.get(postRef);
      if (!postDoc.exists) {
        throw Exception('Post does not exist');
      }

      final currentLikes = postDoc.data()?['postLikes'] as int? ?? 0;
      final likedBy = List<String>.from(postDoc.data()?['likedBy'] ?? []);

      if (likedBy.contains(user.uid)) {
        transaction.update(postRef, {
          'postLikes': currentLikes - 1,
          'likedBy': FieldValue.arrayRemove([user.uid]),
        });
      } else {
        transaction.update(postRef, {
          'postLikes': currentLikes + 1,
          'likedBy': FieldValue.arrayUnion([user.uid]),
        });
      }
    });
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

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot>(
      future: _storeFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        if (!snapshot.hasData) {
          return Center(child: Text('User not found'));
        }

        final storeData = snapshot.data!.data() as Map<String, dynamic>;
        final userName = storeData['name'] ?? 'Unknown User';
        final userProfileImage =
            storeData['profileImage'] ?? 'https://via.placeholder.com/150';

        return Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // User information row
              Row(
                children: [
                  CircleAvatar(
                    backgroundImage: NetworkImage(userProfileImage),
                    radius: 20.0,
                  ),
                  const SizedBox(width: 16.0),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        userName,
                        style: const TextStyle(
                          fontSize: 18.0,
                        ),
                      ),
                      Text(
                        _formatTimestamp(widget.createdAt),
                        style: TextStyle(
                          color: hexToColor('#9C9C9C'),
                          fontSize: 10.0,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: () {
                      showModalBottomSheet(
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(12),
                            topRight: Radius.circular(12),
                          ),
                        ),
                        context: context,
                        builder: (context) => _buildMoreBottomSheet(),
                      );
                    },
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
              ),
              SizedBox(height: 16.0),
              // Caption
              Text(
                widget.postContent,
                style: TextStyle(
                  color: Colors.black,
                  fontFamily: 'Gotham',
                  fontSize: 12.0,
                ),
              ),
              SizedBox(height: 10),
              // Post images
              if (widget.postImages.isNotEmpty)
                Container(
                  height: 200.0, // Adjust the height as needed
                  child: PageView.builder(
                    itemCount: widget.postImages.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  FullScreenImageView(imageUrl: widget.postImages[index]),
                            ),
                          );
                        },
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8.0),
                          child: Image.network(
                            widget.postImages[index],
                            fit: BoxFit.cover,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              SizedBox(height: 10),
              // Likes
              Row(
                children: [
                  GestureDetector(
                    onTap: _likePost,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 6.0),
                      decoration: BoxDecoration(
                        border: Border.all(color: hexToColor('#BEBEBE')),
                        borderRadius: BorderRadius.circular(50.0),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.favorite,
                            color: Colors.red,
                          ),
                          const SizedBox(width: 8.0),
                          Text(
                            '${widget.postLikes}',
                            style: TextStyle(
                                color: hexToColor('#989797'), fontSize: 12.0),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Spacer(),
                  if (widget.productLink?.isNotEmpty ?? false) ...[
                    Chip(
                      backgroundColor: hexToColor('#EDEDED'),
                      side: BorderSide.none,
                      label: Text(
                        '${widget.productLink!}',
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
                  ],
                  Icon(Icons.ios_share_outlined)
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMoreBottomSheet() {
    return Container(
      height: 250,
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 100,
              height: 4,
              margin: const EdgeInsets.symmetric(vertical: 15),
              decoration: BoxDecoration(
                color: hexToColor('#CACACA'),
                borderRadius: BorderRadius.circular(5),
              ),
            ),
          ),
          SizedBox(height: 50),
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
}

class CreateCommunityPost extends StatefulWidget {
  String storeId;

  CreateCommunityPost({required this.storeId});

  @override
  State<CreateCommunityPost> createState() => _CreateCommunityPostState();
}

class _CreateCommunityPostState extends State<CreateCommunityPost> {
  List<File> _images = [];
  final TextEditingController _captionController = TextEditingController();
  final TextEditingController _productLinkController = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
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

  Future<List<String>> _uploadImages() async {
    List<String> imageUrls = [];
    final storage = FirebaseStorage.instance;
    final user = FirebaseAuth.instance.currentUser;

    for (var image in _images) {
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
        // You might want to handle this error more gracefully
      }
    }

    return imageUrls;
  }

  Future<void> _createPost() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) throw Exception('User not logged in');

      List<String> imageUrls = await _uploadImages();

      final post = CommunityPostModel(
        postId: '',
        storeId: widget.storeId,
        postContent: _captionController.text,
        postImages: imageUrls,
        postLikes: 0,
        likedBy: [],
        createdAt: Timestamp.now(),
        productLink: _productLinkController.text.isNotEmpty
            ? _productLinkController.text
            : null,
      );

      await CommunityPostModel.createPost(post);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Post created successfully!')),
      );
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error creating post: $e')),
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
                          'Create Post'.toUpperCase(),
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
                                            image: FileImage(_images[index]),
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
                  onPressed: _isLoading ? null : _createPost,
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
                      : Text('Post', style: TextStyle(fontSize: 16)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
