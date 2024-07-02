import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:tnennt/services/firebase/firebase_auth_service.dart';
import 'package:tnennt/services/firebase/storage_service.dart';
import 'package:tnennt/models/user_model.dart';

class UserService{

  final currentUser = Auth().currentUser;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<UserModel> fetchUserDetails() async {
    User? user = currentUser;
    if (user != null) {
      if(user.isAnonymous){
        return UserModel(uid: user.uid);
      }else {
        DocumentSnapshot doc = await FirebaseFirestore.instance.collection(
            'Users').doc(user.uid).get();
        return UserModel.fromFirestore(doc);
      }
    } else {
      throw Exception("No user is signed in");
    }
  }

  Future<void> createUser({required String uid, required Map<String, dynamic> data}) async {
    await _firestore.collection('Users').doc(uid).set(data);
  }

  Future<void> updateUser({required String uid, required Map<String, dynamic> data}) async {
    await _firestore.collection('Users').doc(uid).update(data);
  }

  Future<String> uploadProfilePicture({required String uid, required File file}) async {
    try {
      final ref = _storage.ref().child('profile_pictures/$uid');
      await ref.putFile(file);
      return await ref.getDownloadURL();
    } catch (e) {
      throw Exception(e);
    }
  }
}