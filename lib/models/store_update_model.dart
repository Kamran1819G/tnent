import 'package:cloud_firestore/cloud_firestore.dart';

class StoreUpdateModel {
  final String updateId;
  final String storeId;
  final List<String> imageUrls;
  final Timestamp createdAt;
  final Timestamp expiresAt;

  StoreUpdateModel({
    required this.updateId,
    required this.storeId,
    required this.imageUrls,
    required this.createdAt,
    required this.expiresAt,
  });

  factory StoreUpdateModel.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return StoreUpdateModel(
      updateId: doc.id,
      storeId: data['storeId'] ?? '',
      imageUrls: List<String>.from(data['imageUrls'] ?? []),
      createdAt: data['createdAt'] ?? Timestamp.now(),
      expiresAt: data['expiresAt'] ?? Timestamp.now(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'storeId': storeId,
      'imageUrls': imageUrls,
      'createdAt': createdAt,
      'expiresAt': expiresAt,
    };
  }
}