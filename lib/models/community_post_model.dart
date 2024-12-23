import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class CommunityPostModel {
  final String postId;
  final String storeId;
  final String content;
  final List<String> images;
  int likes;
  final Timestamp createdAt;

  CommunityPostModel({
    required this.postId,
    required this.storeId,
    required this.content,
    required this.images,
    required this.likes,
    required this.createdAt,
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
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'storeId': storeId,
      'content': content,
      'images': images,
      'likes': likes,
      'createdAt': createdAt,
    };
  }

  static Future<void> createPost(
      CommunityPostModel post, String storeId) async {
    try {
      await FirebaseFirestore.instance
          .collection('communityPosts')
          .add(post.toFirestore());
    } catch (e) {
      print('Error creating post: $e');
    }
  }

  static Future<void> updatePost(CommunityPostModel post) async {
    try {
      final postRef = FirebaseFirestore.instance
          .collection('communityPosts')
          .doc(post.postId);

      // Update the post document in Firestore
      await postRef.update({
        'content': post.content,
        'images': post.images,
        // Note: We're not updating 'likes' or 'createdAt' here,
        // as these should typically remain unchanged during an edit
      });

      print('Post updated successfully');
    } catch (e) {
      print('Error updating post: $e');
      throw e;
    }
  }

  static Future<void> reportPost(
      String postId, String storeId, String reason, String reportedBy) async {
    try {
      final reportedItemsRef = FirebaseFirestore.instance
          .collection('ReportedItems')
          .doc(); // Create a new reported item document
      final reportedPostRef = reportedItemsRef
          .collection('reportedPosts')
          .doc(); // Create a new reported post documentr

      await reportedPostRef.set({
        'postId': postId,
        'storeId': storeId,
        'reason': reason,
        'reportedBy': reportedBy,
        'reportedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print('Error reporting post: $e');
      throw e;
    }
  }

  static Future<void> deletePost(String postId, String storeId) async {
    try {
      // Get a reference to the Firestore document
      final postRef =
          FirebaseFirestore.instance.collection('communityPosts').doc(postId);
      final storeRef =
          FirebaseFirestore.instance.collection('Stores').doc(storeId);

      // Get the post data
      final postSnapshot = await postRef.get();
      if (!postSnapshot.exists) {
        throw Exception('Post not found');
      }

      final postData = postSnapshot.data() as Map<String, dynamic>;

      // Delete images from Firebase Storage
      if (postData['images'] != null) {
        for (String imageUrl in postData['images']) {
          try {
            // Create a reference to the image file
            final ref = FirebaseStorage.instance.refFromURL(imageUrl);
            // Delete the file
            await ref.delete();
          } catch (e) {
            print('Error deleting image: $e');
            // Continue with the next image even if one fails
          }
        }
      }

      // Delete the post document from Firestore
      await postRef.delete();

      print('Post and associated images deleted successfully');
    } catch (e) {
      print('Error deleting post: $e');
      throw e;
    }
  }
}
