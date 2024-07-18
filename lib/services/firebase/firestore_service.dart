import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService{

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;


  // Get Collection
  Future<QuerySnapshot> getCollection({required String collection}) async {
    return await _firestore.collection(collection).get();
  }

  Future<void> createUser({required String uid, required Map<String, dynamic> data}) async {
    await _firestore.collection('Users').doc(uid).set(data);
  }

  Future<void> updateUser({required String uid, required Map<String, dynamic> data}) async {
    await _firestore.collection('Users').doc(uid).update(data);
  }

}