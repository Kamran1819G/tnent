import 'package:cloud_firestore/cloud_firestore.dart';

class CommunityPostModel {
  final String postId;
  final String storeId;
  final String postContent;
  final List<String> postImages;
  final int postLikes;
  final List<String> likedBy;
  final Timestamp createdAt;
  final String? productLink;

  CommunityPostModel({
    required this.postId,
    required this.storeId,
    required this.postContent,
    required this.postImages,
    required this.postLikes,
    required this.likedBy,
    required this.createdAt,
    this.productLink,
  });

  factory CommunityPostModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    return CommunityPostModel(
      postId: doc.id,
      storeId: data['storeId'] ?? '',
      postContent: data['postContent'] ?? '',
      postImages: List<String>.from(data['postImages'] ?? []),
      postLikes: data['postLikes'] ?? 0,
      likedBy: List<String>.from(data['likedBy'] ?? []),
      createdAt: data['createdAt'] ?? Timestamp.now(),
      productLink: data['productLink'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'storeId': storeId,
      'postContent': postContent,
      'postImages': postImages,
      'postLikes': postLikes,
      'likedBy': likedBy,
      'createdAt': createdAt,
      'productLink': productLink,
    };
  }

  static Future<String> createPost(CommunityPostModel post) async {
    DocumentReference docRef = await FirebaseFirestore.instance
        .collection('communityPosts')
        .add(post.toFirestore());
    return docRef.id;
  }
}