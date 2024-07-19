import 'package:cloud_firestore/cloud_firestore.dart';

class StoreModel {
  final String id;
  final String ownerId;
  final String analyticsId;
  final String name;
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
  final int goodReviews;
  final int badReviews;
  final List<String> reviewIds;
  final List<String> productIds;
  final List<String> postIds;
  final List<String> followerIds;

  StoreModel({
    required this.id,
    required this.ownerId,
    required this.analyticsId,
    required this.name,
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
    required this.goodReviews,
    required this.badReviews,
    required this.reviewIds,
    required this.productIds,
    required this.postIds,
    required this.followerIds,
  });

  factory StoreModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return StoreModel(
      id: doc.id,
      ownerId: data['ownerId'],
      analyticsId: data['analyticsId'],
      name: data['name'],
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
      goodReviews: data['goodReviews'] ?? 0,
      badReviews: data['badReviews'] ?? 0,
      reviewIds: List<String>.from(data['reviewIds'] ?? []),
      productIds: List<String>.from(data['productIds'] ?? []),
      postIds: List<String>.from(data['postIds'] ?? []),
      followerIds: List<String>.from(data['followerIds'] ?? []),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'id': id,
      'ownerId': ownerId,
      'analyticsId': analyticsId,
      'name': name,
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
      'goodReviews': goodReviews,
      'badReviews': badReviews,
      'reviewIds': reviewIds,
      'productIds': productIds,
      'postIds': postIds,
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
