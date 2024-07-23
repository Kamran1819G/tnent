import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tnennt/helpers/color_utils.dart';
import 'package:tnennt/pages/home_pages/catalog.dart';
import 'package:tnennt/pages/home_pages/community.dart';
import 'package:tnennt/pages/home_pages/gallery.dart';
import 'package:tnennt/pages/home_pages/home.dart';
import 'package:tnennt/models/user_model.dart';

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
    _fetchUserDetails();
  }

  Future<void> _fetchUserDetails() async {
    if (user == null) {
      setState(() => _isLoading = false);
      return;
    }

    try {
      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection('Users')
          .doc(user!.uid)
          .get();

      if (mounted) {
        setState(() {
          currentUser = UserModel.fromFirestore(doc);
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('Error fetching user details: ${e.toString()}')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: _isLoading
            ? Center(
                child: RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: 'Tnennt',
                        style: TextStyle(
                          color: hexToColor('#2D332F'),
                          fontFamily: 'Gotham Black',
                          fontSize: 30,
                        ),
                      ),
                      TextSpan(
                        text: ' •',
                        style: TextStyle(
                          fontFamily: 'Gotham Black',
                          fontSize: 30.0,
                          color: hexToColor('#42FF00'),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            : Stack(
                children: [
                  PageView(
                    physics: NeverScrollableScrollPhysics(),
                    controller: _pageController,
                    children: [
                      SingleChildScrollView(
                          child: Home(currentUser: currentUser!)),
                      SingleChildScrollView(child: Community()),
                      SingleChildScrollView(child: Gallery()),
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
    return Container(
      margin: EdgeInsets.only(bottom: 20, left: 40, right: 40),
      padding: EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: hexToColor('#2D332F'),
        borderRadius: BorderRadius.circular(100),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildNavItem(0, 'assets/home.png'),
          _buildNavItem(1, 'assets/community.png'),
          _buildNavItem(2, 'assets/gallery.png'),
          _buildNavItem(3, 'assets/catalog.png'),
        ],
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
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          color: _selectedIndex == index ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(100),
        ),
        child: Image.asset(
          assetName,
          width: 20.0,
          color: _selectedIndex == index ? Colors.black : hexToColor('#747474'),
        ),
      ),
    );
  }
}
