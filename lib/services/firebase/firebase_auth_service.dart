import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

class Auth {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  User? get currentUser => _auth.currentUser;

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  Future<void> sendPasswordResetEmail({required String email}) async {
    await _auth.sendPasswordResetEmail(email: email);
  }

  Future<void> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    final userCredential = await _auth.signInWithEmailAndPassword(email: email, password: password);

    // Check if the user document exists in Firestore
    final userDoc = await _firestore
        .collection('Users')
        .doc(userCredential.user!.uid)
        .get();
    if (!userDoc.exists) {
      // If user document does not exist, sign out and throw an error
      await signOut();
      throw FirebaseAuthException(
        code: 'user-not-found',
        message: 'No user found for that email.',
      );
    }
  }

  Future<void> signInWithGoogle() async {
    final googleSignInAccount = await _googleSignIn.signIn();
    if (googleSignInAccount == null) {
      // User cancelled the sign-in process
      return;
    }

    final googleSignInAuthentication =
        await googleSignInAccount.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );

    final userCredential = await _auth.signInWithCredential(credential);

    // Check if the user document exists in Firestore
    final userDoc = await _firestore.collection('Users').doc(userCredential.user!.uid).get();
    if (!userDoc.exists) {
      // If user document does not exist, sign out and throw an error
      await signOut();
      throw FirebaseAuthException(
        code: 'user-not-found',
        message: 'No user found for that email.',
      );
    }
  }

  Future<void> signUpWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    await _auth.createUserWithEmailAndPassword(email: email, password: password);

    if (currentUser != null && !currentUser!.emailVerified) {
      await currentUser!.sendEmailVerification();
    }

    if (currentUser != null) {
      final userDoc = await _firestore.collection('Users').doc(currentUser!.uid).get();
      if (!userDoc.exists) {
        await _firestore.collection('Users').doc(currentUser!.uid).set({
          'email': currentUser!.email,
        });
      }
    }
  }

  Future<void> signUpWithGoogle() async {
    final googleSignInAccount = await _googleSignIn.signIn();
    if (googleSignInAccount == null) {
      // User cancelled the sign-in process
      return;
    }
    final googleSignInAuthentication =
        await googleSignInAccount.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );

    final userCredential = await _auth.signInWithCredential(credential);

    final userDoc = await _firestore
        .collection('Users')
        .doc(userCredential.user!.uid)
        .get();
    if (!userDoc.exists) {
      await _firestore.collection('Users').doc(userCredential.user!.uid).set({
        'email': userCredential.user!.email,
      });
    }
  }

  Future<void> signInWithFacebook() async {
    final LoginResult result = await FacebookAuth.instance.login();
    if (result.status == LoginStatus.success) {
      final AccessToken accessToken = result.accessToken!;
      final OAuthCredential credential = FacebookAuthProvider.credential(accessToken.tokenString);

      final userCredential = await _auth.signInWithCredential(credential);

      // Check if the user document exists in Firestore
      final userDoc = await _firestore.collection('Users').doc(userCredential.user!.uid).get();
      if (!userDoc.exists) {
        // If user document does not exist, sign out and throw an error
        await signOut();
        throw FirebaseAuthException(
          code: 'user-not-found',
          message: 'No user found for that email.',
        );
      }
    } else {
      print('Error during Facebook sign in: ${result.message}');
      // Handle error, show appropriate message to the user
    }
  }

  Future<void> signUpWithFacebook() async {
    final LoginResult result = await FacebookAuth.instance.login();
    if (result.status == LoginStatus.success) {
      final AccessToken accessToken = result.accessToken!;
      final OAuthCredential credential = FacebookAuthProvider.credential(accessToken.tokenString);

      final userCredential = await _auth.signInWithCredential(credential);

      final userDoc = await _firestore.collection('Users').doc(userCredential.user!.uid).get();
      if (!userDoc.exists) {
        await _firestore.collection('Users').doc(userCredential.user!.uid).set({
          'email': userCredential.user!.email,
        });
      }
    } else {
      print('Error during Facebook sign up: ${result.message}');
      // Handle error, show appropriate message to the user
    }
  }

  Future<void> changePassword({required String password}) async {
    await currentUser!.updatePassword(password);
  }

  Future<void> sendEmailVerification() async {
    await currentUser!.sendEmailVerification();
  }

  Future<void> signOut() async {
    // Sign out from Firebase
    await _auth.signOut();

    // Sign out from Google
    await _googleSignIn.signOut();

    // Sign out from Facebook
    await FacebookAuth.instance.logOut();
  }
}
