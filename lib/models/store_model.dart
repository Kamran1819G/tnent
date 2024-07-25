import 'package:cloud_firestore/cloud_firestore.dart';

class StoreModel {
  final String storeId;
  final String ownerId;
  final String name;
  final String logoUrl;
  final String phone;
  final String email;
  final String website;
  final String upiUsername;
  final String upiId;
  final String location;
  final String category;
  final bool isActive;
  final Timestamp createdAt;
  final int totalProducts;
  final int totalPosts;
  final int storeEngagement;
  final int greenFlags;
  final int redFlags;
  final List<String> featuredProductIds;
  final List<String> followerIds;

  StoreModel({
    required this.storeId,
    required this.ownerId,
    required this.name,
    required this.logoUrl,
    required this.phone,
    required this.email,
    required this.website,
    required this.upiUsername,
    required this.upiId,
    required this.location,
    required this.category,
    required this.isActive,
    required this.createdAt,
    required this.totalProducts,
    required this.totalPosts,
    required this.storeEngagement,
    required this.greenFlags,
    required this.redFlags,
    required this.featuredProductIds,
    required this.followerIds,
  });

  factory StoreModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return StoreModel(
      storeId: doc.id,
      ownerId: data['ownerId'],
      name: data['name'],
      logoUrl: data['logoUrl'] ?? 'https://via.placeholder.com/150',
      phone: data['phone'],
      email: data['email'],
      website: data['website'],
      upiUsername: data['upiUsername'],
      upiId: data['upiId'],
      location: data['location'],
      category: data['category'] ?? '',
      isActive: data['isActive'],
      createdAt: data['createdAt'],
      totalProducts: data['totalProducts'] ?? 0,
      totalPosts: data['totalPosts'] ?? 0,
      storeEngagement: data['storeEngagement'] ?? 0,
      greenFlags: data['greenFlags'] ?? 0,
      redFlags: data['redFlags'] ?? 0,
      featuredProductIds: List<String>.from(data['featuredProductIds'] ?? []),
      followerIds: List<String>.from(data['followerIds'] ?? []),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'storeId': storeId,
      'ownerId': ownerId,
      'name': name,
      'logoUrl': logoUrl,
      'phone': phone,
      'email': email,
      'website': website,
      'upiUsername': upiUsername,
      'upiId': upiId,
      'location': location,
      'category': category,
      'isActive': isActive,
      'createdAt': createdAt,
      'totalProduct': totalProducts,
      'totalPosts': totalPosts,
      'storeEngagement': storeEngagement,
      'greenFlags': greenFlags,
      'redFlags': redFlags,
      'featuredProductIds': featuredProductIds,
      'followerIds': followerIds,
    };
  }
}
