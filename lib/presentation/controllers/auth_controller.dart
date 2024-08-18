import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthController extends GetxController {
  final _auth = FirebaseAuth.instance;
  var isAuthenticated = false.obs;

  User get user => _auth.currentUser!;

  @override
  void onInit() {
    super.onInit();
    _initializeAuthListener();
  }

  void _initializeAuthListener() {
    _auth.authStateChanges().listen((user) {
      isAuthenticated.value = user != null;
    });
  }

  Future<void> signOut() async {
    await GoogleSignIn().signOut();
    await _auth.signOut();
  }
}
