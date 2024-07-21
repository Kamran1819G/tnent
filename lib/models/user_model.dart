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
  final bool registered;
  final String? storeId;
  final List<String> likedPosts;
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
    this.registered = false,
    this.storeId,
    List<String>? likedPosts,
    Timestamp? createdAt,
    Timestamp? lastUpdated,
  }) :
        this.likedPosts = likedPosts ?? [],
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
      registered: data['registered'] ?? false,
      storeId: data['storeId'],
      likedPosts: List<String>.from(data['likedPosts'] ?? []),
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
      'registered': registered,
      'storeId': storeId,
      'likedPosts': likedPosts,
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
    bool? registered,
    String? storeId,
    List<String>? likedPosts,
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
      registered: registered ?? this.registered,
      storeId: storeId ?? this.storeId,
      likedPosts: likedPosts ?? this.likedPosts,
      createdAt: this.createdAt,
      lastUpdated: lastUpdated ?? Timestamp.now(),
    );
  }
}