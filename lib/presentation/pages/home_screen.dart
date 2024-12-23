import 'dart:async';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tnent/core/helpers/color_utils.dart';
import 'package:tnent/core/helpers/frosted_glass.dart';
import 'package:tnent/presentation/pages/home_pages/catalog.dart';
import 'package:tnent/presentation/pages/home_pages/community.dart';
import 'package:tnent/presentation/pages/home_pages/gallery.dart';
import 'package:tnent/presentation/pages/home_pages/home.dart';
import 'package:tnent/models/user_model.dart';
import 'package:tnent/presentation/pages/users_screens/user_registration.dart';
import 'package:tnent/presentation/pages/splash_screen.dart';

import '../../core/helpers/snackbar_utils.dart';
import '../../models/store_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final PageController _pageController = PageController();
  UserModel? currentUser;
  int _selectedIndex = 0;
  bool _isLoading = true;

  User? user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    initialize();
  }

  void initialize() async {
    await _fetchUserDetails();
  }

  Future<void> _fetchUserDetails() async {
    setState(() {
      _isLoading = true;
    });

    if (user == null) return;

    try {
      // Fetch user details
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('Users')
          .doc(user!.uid)
          .get();

      if (userDoc.exists) {
        currentUser = UserModel.fromFirestore(userDoc);

        // Check if user registration is complete
        if (currentUser!.phoneNumber == null ||
            currentUser!.phoneNumber!.isEmpty ||
            currentUser!.firstName.isEmpty ||
            currentUser!.lastName.isEmpty) {
          // Redirect to Registration Page
          if (mounted) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const UserRegistration()),
            );
          }
        } else {
          setState(() {
            _isLoading = false;
          });
        }
      } else {
        // Handle the case where the user document does not exist
        if (mounted) {
          showSnackBar(context, 'User document does not exist');
        }
      }
    } catch (e) {
      if (mounted) {
        showSnackBar(context, 'Error fetching data: ${e.toString()}');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? const SplashScreen()
        : Scaffold(
            body: SafeArea(
              child: Stack(
                children: [
                  PageView(
                    physics: const NeverScrollableScrollPhysics(),
                    controller: _pageController,
                    children: [
                      SingleChildScrollView(
                          child: Home(currentUser: currentUser!)),
                      const SingleChildScrollView(child: Community()),
                      const SingleChildScrollView(child: Gallery()),
                      SingleChildScrollView(
                          child: Catalog(currentUser: currentUser!)),
                    ],
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: _buildBottomNavigationBar(),
                  ),
                ],
              ),
            ),
          );
  }

  Widget _buildBottomNavigationBar() {
    // return Container(
    //   margin: const EdgeInsets.only(bottom: 20, left: 40, right: 40),
    //   decoration: BoxDecoration(
    //     color: Colors.white.withOpacity(0.85), // Semi-transparent white
    //     borderRadius: BorderRadius.circular(100),
    //     // border: Border.all(color: Colors.white.withOpacity(0.7), width: 1.0),
    //   ),
    //   child: Material(
    //     surfaceTintColor: Colors.white,
    //     shadowColor: Colors.white,
    //     elevation: 25,
    //     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
    //     child: ClipRRect(
    //       borderRadius: BorderRadius.circular(100),
    //       child: BackdropFilter(
    //         filter: ImageFilter.blur(sigmaX: 25, sigmaY: 25),
    //         child: Padding(
    //           padding: const EdgeInsets.symmetric(vertical: 12),
    //           child: Row(
    //             mainAxisSize: MainAxisSize.max,
    //             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    //             children: [
    //               _buildNavItem(0, 'assets/home.png'),
    //               _buildNavItem(1, 'assets/community.png'),
    //               _buildNavItem(2, 'assets/gallery.png'),
    //               _buildNavItem(3, 'assets/catalog.png'),
    //             ],
    //           ),
    //         ),
    //       ),
    //     ),
    //   ),
    // );
    // final width = MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40).copyWith(bottom: 20),
      child: FrostedGlass(
        width: double.infinity,
        maxOpacity: 0.4,
        minOpacity: 0.4,
        sigmaX: 22,
        sigmaY: 22,
        borderRadius: 40,
        height: 70,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildNavItem(0, 'assets/home.png'),
            _buildNavItem(1, 'assets/community.png'),
            _buildNavItem(2, 'assets/gallery.png'),
            _buildNavItem(3, 'assets/catalog.png'),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, String assetName) {
    return InkWell(
      onTap: () {
        setState(() {
          _selectedIndex = index;
          _pageController.jumpToPage(index);
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          color: _selectedIndex == index
              ? hexToColor('#B7BAFF')
              : Colors.transparent,
          borderRadius: BorderRadius.circular(100),
        ),
        child: Image.asset(
          assetName,
          width: 20.0,
          color: _selectedIndex == index ? Colors.white : hexToColor('#747474'),
        ),
      ),
    );
  }
}
