import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
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

  CommunityPost({
    required this.post,
  });

  @override
  _CommunityPostState createState() => _CommunityPostState();
}

class _CommunityPostState extends State<CommunityPost> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late Future<DocumentSnapshot> _storeFuture;
  bool _isLiked = false;

  @override
  void initState() {
    super.initState();
    _storeFuture = _firestore.collection('Stores').doc(widget.post.storeId).get();
    _checkIfLiked();
  }

  Future<void> _checkIfLiked() async {
    final user = _auth.currentUser;
    if (user == null) return;

    final userDoc = await _firestore.collection('Users').doc(user.uid).get();
    final likedPosts = List<String>.from(userDoc.data()?['likedPosts'] ?? []);
    setState(() {
      _isLiked = likedPosts.contains(widget.post.postId);
    });
  }

  Future<void> _toggleLike() async {
    final user = _auth.currentUser;
    if (user == null) return;

    final userRef = _firestore.collection('Users').doc(user.uid);
    final postRef = _firestore.collection('communityPosts').doc(widget.post.postId);

    return _firestore.runTransaction((transaction) async {
      final userDoc = await transaction.get(userRef);
      final postDoc = await transaction.get(postRef);

      if (!postDoc.exists) {
        throw Exception('Post does not exist');
      }

      final likedPosts = List<String>.from(userDoc.data()?['likedPosts'] ?? []);
      final currentLikes = postDoc.data()?['likes'] as int? ?? 0;

      if (likedPosts.contains(widget.post.postId)) {
        // Unlike
        transaction.update(userRef, {
          'likedPosts': FieldValue.arrayRemove([widget.post.postId])
        });
        transaction.update(postRef, {
          'likes': FieldValue.increment(-1)
        });
        setState(() {
          _isLiked = false;
          widget.post.likes--;
        });
      } else {
        // Like
        transaction.update(userRef, {
          'likedPosts': FieldValue.arrayUnion([widget.post.postId])
        });
        transaction.update(postRef, {
          'likes': FieldValue.increment(1)
        });
        setState(() {
          _isLiked = true;
          widget.post.likes++;
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
    return FutureBuilder<void>(
        future: _checkIfLiked(),
        builder: (context, snapshot) {
          return FutureBuilder<DocumentSnapshot>(
            future: _storeFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return _buildLoadingPlaceholder();
              }

              if (!snapshot.hasData || !snapshot.data!.exists) {
                return Center(child: Text('Store not found'));
              }

              final storeData = snapshot.data!.data() as Map<String, dynamic>;
              final userName = storeData['name'] ?? 'Unknown User';
              final userProfileImage =
                  storeData['profileImage'] ?? 'https://via.placeholder.com/150';

              return _buildPostContent(userName, userProfileImage);
            },
          );
        }
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

  Widget _buildPostContent(String userName, String userProfileImage) {
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
                    _formatTimestamp(widget.post.createdAt),
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
            widget.post.content,
            style: TextStyle(
              color: Colors.black,
              fontFamily: 'Gotham',
              fontSize: 12.0,
            ),
          ),
          SizedBox(height: 10),
          // Post images
          if (widget.post.images.isNotEmpty)
            Container(
              height: 200.0, // Adjust the height as needed
              child: PageView.builder(
                itemCount: widget.post.images.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              FullScreenImageView(imageUrl: widget.post.images[index]),
                        ),
                      );
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: Image.network(
                        widget.post.images[index],
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
                onTap: _toggleLike,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 6.0),
                  decoration: BoxDecoration(
                    border: Border.all(color: hexToColor('#BEBEBE')),
                    borderRadius: BorderRadius.circular(50.0),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        _isLiked ? Icons.favorite : Icons.favorite_border,
                        color: _isLiked ? Colors.red : hexToColor('#BEBEBE'),
                      ),
                      const SizedBox(width: 8.0),
                      Text(
                        '${widget.post.likes}',
                        style: TextStyle(
                            color: hexToColor('#989797'), fontSize: 12.0),
                      ),
                    ],
                  ),
                ),
              ),
              Spacer(),
              if (widget.post.productLink?.isNotEmpty ?? false) ...[
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
              ],
              Icon(Icons.ios_share_outlined)
            ],
          ),
        ],
      ),
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
