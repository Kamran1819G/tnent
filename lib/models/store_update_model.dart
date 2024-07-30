import 'package:cloud_firestore/cloud_firestore.dart';

class StoreUpdateModel {
  final String updateId;
  final String storeId;
  final String storeName;
  final String logoUrl;
  final String imageUrl;
  final Timestamp createdAt;
  final Timestamp expiresAt;

  StoreUpdateModel({
    required this.updateId,
    required this.storeId,
    required this.storeName,
    required this.logoUrl,
    required this.imageUrl,
    required this.createdAt,
    required this.expiresAt,
  });

  factory StoreUpdateModel.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return StoreUpdateModel(
      updateId: doc.id,
      storeId: data['storeId'] ?? '',
      storeName: data['storeName'] ?? '',
      logoUrl: data['logoUrl'] ?? '',
      imageUrl: data['imageUrl'] ?? '',
      createdAt: data['createdAt'] ?? Timestamp.now(),
      expiresAt: data['expiresAt'] ?? Timestamp.now(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'storeId': storeId,
      'storeName': storeName,
      'logoUrl': logoUrl,
      'imageUrl': imageUrl,
      'createdAt': createdAt,
      'expiresAt': expiresAt,
    };
  }
}