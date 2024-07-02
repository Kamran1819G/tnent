import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:tnennt/services/firebase/firebase_auth_service.dart';
import 'package:tnennt/helpers/color_utils.dart';
import 'package:tnennt/pages/home_pages/catalog.dart';
import 'package:tnennt/pages/home_pages/community.dart';
import 'package:tnennt/pages/home_pages/gallery.dart';
import 'package:tnennt/pages/home_pages/home.dart';
import 'package:tnennt/services/user_service.dart';

import '../models/user_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  PageController _pageController = PageController();
  UserModel? currentUser;
  List<Widget> _widgetOptions = [];

  @override
  void initState() {
    super.initState();
    _fetchUserDetails();
  }

  Future<void> _fetchUserDetails() async {
    try {
      UserModel user = await UserService().fetchUserDetails();
      setState(() {
        currentUser = user;
        _widgetOptions = <Widget>[
          SingleChildScrollView(child: Home(currentUser: currentUser)),
          SingleChildScrollView(child: Catalog()),
          SingleChildScrollView(child: Gallery()),
          SingleChildScrollView(child: Community()),
        ];
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: currentUser == null
            ? Center(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: 'Tnennt',
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w900,
                              fontSize: 32.0,
                            ),
                          ),
                          TextSpan(
                            text: ' •',
                            style: TextStyle(
                              fontWeight: FontWeight.w900,
                              fontSize: 32.0,
                              color: hexToColor('#42FF00'),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
            )
            : Stack(
                children: [
                  PageView(
                    physics: NeverScrollableScrollPhysics(),
                    controller: _pageController,
                    children: _widgetOptions,
                  ),
                  // Bottom Navigation Bar
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      margin: EdgeInsets.only(
                        bottom: 20,
                        left: 40,
                        right: 40,
                      ),
                      padding: EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: hexToColor('#2D332F'),
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: GNav(
                        padding:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        color: hexToColor('#747474'),
                        activeColor: Colors.black,
                        tabBackgroundColor: Colors.white,
                        hoverColor: Colors.white,
                        iconSize: 24,
                        onTabChange: (index) {
                          setState(() {
                            _pageController.animateToPage(
                              index,
                              duration: Duration(milliseconds: 500),
                              curve: Curves.easeInOut,
                            );
                          });
                        },
                        tabs: const [
                          GButton(
                            icon: Icons.home,
                          ),
                          GButton(
                            icon: Icons.collections_bookmark,
                          ),
                          GButton(
                            icon: Icons.layers_outlined,
                          ),
                          GButton(
                            icon: Icons.coffee_rounded,
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
