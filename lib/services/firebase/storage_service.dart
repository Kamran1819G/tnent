import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

class StorageService{

    final FirebaseStorage _storage = FirebaseStorage.instance;

   Future<void> deleteFile({required String path}) async {
       try {
           await _storage.ref(path).delete();
       } catch (e) {
           throw Exception(e);
       }
   }
}