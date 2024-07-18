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
    required this.createdAt,
    required this.lastUpdated,
  });

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
      createdAt: data['createdAt'] ?? Timestamp.now(),
      lastUpdated: data['lastUpdated'] ?? Timestamp.now(),
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
    List<String>? roles,
    Map<String, dynamic>? preferences,
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
      createdAt: this.createdAt,
      lastUpdated: Timestamp.now(),
    );
  }
}

/*

// Creating a new user
final newUser = UserModel(
  uid: FirebaseAuth.instance.currentUser!.uid,
  email: 'user@example.com',
  displayName: 'John Doe',
  firstName: 'John',
  lastName: 'Doe',
  createdAt: Timestamp.now(),
  lastUpdated: Timestamp.now(),
  roles: ['customer'],
);

// Saving to Firestore
await FirebaseFirestore.instance.collection('users').doc(newUser.uid).set(newUser.toFirestore());

// Updating a user
Future<void> updateUser(String uid, {String? newPhoneNumber, String? newLocation}) async {
  final docRef = FirebaseFirestore.instance.collection('users').doc(uid);

  await FirebaseFirestore.instance.runTransaction((transaction) async {
  final snapshot = await transaction.get(docRef);
  final currentUser = UserModel.fromFirestore(snapshot);

  final updatedUser = currentUser.copyWith(
    phoneNumber: newPhoneNumber,
    location: newLocation,
  );

  transaction.set(docRef, updatedUser.toFirestore());
  });
}

// Querying users
Query query = FirebaseFirestore.instance.collection('users')
    .where('roles', arrayContains: 'customer')
    .orderBy('lastUpdated', descending: true);

query.get().then((querySnapshot) {
  for (var doc in querySnapshot.docs) {
    final user = UserModel.fromFirestore(doc);
    print('${user.displayName}: ${user.email}');
  }
});*/
