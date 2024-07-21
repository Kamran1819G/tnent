import 'package:cloud_firestore/cloud_firestore.dart';

class CommunityPostModel {
  final String postId;
  final String storeId;
  final String content;
  final List<String> images;
  int likes;
  final Timestamp createdAt;
  final String? productLink;

  CommunityPostModel({
    required this.postId,
    required this.storeId,
    required this.content,
    required this.images,
    required this.likes,
    required this.createdAt,
    this.productLink,
  });

  factory CommunityPostModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    return CommunityPostModel(
      postId: doc.id,
      storeId: data['storeId'] ?? '',
      content: data['content'] ?? '',
      images: List<String>.from(data['images'] ?? []),
      likes: data['likes'] ?? 0,
      createdAt: data['createdAt'] ?? Timestamp.now(),
      productLink: data['productLink'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'storeId': storeId,
      'content': content,
      'images': images,
      'likes': likes,
      'createdAt': createdAt,
      'productLink': productLink,
    };
  }

  static Future<void> createPost(CommunityPostModel post, String storeId) async {
    try {
      // Add the post to the 'communityPosts' collection
      await FirebaseFirestore.instance.collection('communityPosts').add(post.toFirestore());

      // Increment the totalPosts field in the 'Stores' collection
      await FirebaseFirestore.instance
          .collection('Stores')
          .doc(storeId)
          .update({'totalPosts': FieldValue.increment(1)});
    } catch (e) {
      print('Error creating post: $e');
    }
  }
}