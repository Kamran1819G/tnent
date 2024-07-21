import 'package:cloud_firestore/cloud_firestore.dart';

class StoreModel {
  final String storeId;
  final String ownerId;
  final String analyticsId;
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
  final List<String> followerIds;

  StoreModel({
    required this.storeId,
    required this.ownerId,
    required this.analyticsId,
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
    required this.followerIds,
  });

  factory StoreModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return StoreModel(
      storeId: doc.id,
      ownerId: data['ownerId'],
      analyticsId: data['analyticsId'],
      name: data['name'],
      logoUrl: data['logoUrl'],
      phone: data['phone'],
      email: data['email'],
      website: data['website'],
      upiUsername: data['upiUsername'],
      upiId: data['upiId'],
      location: data['location'],
      category: data['category'] ?? '',
      isActive: data['isActive'],
      createdAt: data['createdAt'],
      totalProducts: data['productIds'].length ?? 0,
      totalPosts: data['postIds'].length ?? 0,
      storeEngagement: data['followerIds']?.length ?? 0,
      greenFlags: data['greenFlags'] ?? 0,
      redFlags: data['redFlags'] ?? 0,
      followerIds: List<String>.from(data['followerIds'] ?? []),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'storeId': storeId,
      'ownerId': ownerId,
      'analyticsId': analyticsId,
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
      'followerIds': followerIds,
    };
  }
}


/*
final store = StoreModel(
  id: 'store123',
  ownerId: 'owner456',
  name: 'My Store',
  phone: '+1234567890',
  email: 'store@example.com',
  location: 'Navi Mumbai ',
  isActive: true,
  createdAt: Timestamp.now(),
  reviewIds: [],
  averageRating: 0.0,
  productIds: [],
  followerIds: [],
);

- To save to Firestore
await FirebaseFirestore.instance.collection('stores').doc(store.id).set(store.toFirestore());

- To read from Firestore
final docSnapshot = await FirebaseFirestore.instance.collection('stores').doc('store123').get();
final loadedStore = StoreModel.fromFirestore(docSnapshot);*/
