import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String uid;
  String email;
  String displayName;
  String photoURL;
  String firstName;
  String lastName;
  String phoneNumber;
  String location;
  Map<String, bool> interests;

  UserModel({
    required this.uid,
    this.email = '',
    this.displayName = '',
    this.photoURL = '',
    this.firstName = '',
    this.lastName = '',
    this.phoneNumber = '',
    this.location = '',
    this.interests = const {},
  });

  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic>? data = doc.data() as Map<String, dynamic>?;

    if (data == null) {
      return UserModel(uid: doc.id);
    }

    return UserModel(
      uid: doc.id,
      email: data['email'] ?? '',
      displayName: data['displayName'] ?? '',
      photoURL: data['photoURL'] ?? '',
      firstName: data['firstName'] ?? '',
      lastName: data['lastName'] ?? '',
      phoneNumber: data['phoneNumber'] ?? '',
      location: data['location'] ?? '',
      interests: Map<String, bool>.from(data['interests'] ?? {}),
    );
  }
}
