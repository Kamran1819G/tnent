import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String uid;
  final String email;
  final String? photoURL;
  final String firstName;
  final String lastName;
  final String? phoneNumber;
  final String? location;
  final String? pincode;
  final String? storeId;
  Map<String, dynamic>? address;
  final List<String> likedPosts;
  final List<String> followedStores;
  final Timestamp createdAt;
  final Timestamp lastUpdated;

  UserModel({
    required this.uid,
    required this.email,
    this.photoURL,
    required this.firstName,
    required this.lastName,
    this.phoneNumber,
    this.location,
    this.pincode,
    this.storeId,
    this.address,
    List<String>? likedPosts,
    List<String>? followedStores,
    Timestamp? createdAt,
    Timestamp? lastUpdated,
  }) :
        this.likedPosts = likedPosts ?? [],
        this.followedStores = followedStores ?? [],
        this.createdAt = createdAt ?? Timestamp.now(),
        this.lastUpdated = lastUpdated ?? Timestamp.now();

  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    return UserModel(
      uid: doc.id,
      email: data['email'] ?? '',
      photoURL: data['photoURL'],
      firstName: data['firstName'] ?? '',
      lastName: data['lastName'] ?? '',
      phoneNumber: data['phoneNumber'],
      location: data['location'],
      pincode: data['pincode'],
      storeId: data['storeId'],
      address: data['address'] as Map<String, dynamic>?,
      likedPosts: List<String>.from(data['likedPosts'] ?? []),
      followedStores: List<String>.from(data['followedStores'] ?? []),
      createdAt: data['createdAt'],
      lastUpdated: data['lastUpdated'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'email': email,
      'photoURL': photoURL,
      'firstName': firstName,
      'lastName': lastName,
      'phoneNumber': phoneNumber,
      'location': location,
      'pincode': pincode,
      'storeId': storeId,
      'address': address,
      'likedPosts': likedPosts,
      'followedStores': followedStores,
      'createdAt': createdAt,
      'lastUpdated': lastUpdated,
    };
  }

  UserModel copyWith({
    String? email,
    String? photoURL,
    String? firstName,
    String? lastName,
    String? phoneNumber,
    String? location,
    String? pincode,
    String? storeId,
    Map<String, dynamic>? address,
    List<String>? likedPosts,
    List<String>? followedStores,
    Timestamp? lastUpdated,
  }) {
    return UserModel(
      uid: this.uid,
      email: email ?? this.email,
      photoURL: photoURL ?? this.photoURL,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      location: location ?? this.location,
      pincode: pincode ?? this.pincode,
      storeId: storeId ?? this.storeId,
      likedPosts: likedPosts ?? this.likedPosts,
      followedStores: followedStores ?? this.followedStores,
      address: address ?? this.address,
      createdAt: this.createdAt,
      lastUpdated: lastUpdated ?? Timestamp.now(),
    );
  }

  bool isFollowingStore(String storeId) {
    return followedStores.contains(storeId);
  }

  int get followedStoresCount => followedStores.length;
}