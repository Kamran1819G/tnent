import 'package:flutter/material.dart';
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
  int _selectedIndex = 0;

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
          SingleChildScrollView(child: Community()),
          SingleChildScrollView(child: Gallery()),
          SingleChildScrollView(child: Catalog()),
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
            // Custom Bottom Navigation Bar
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
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildNavItem(0, 'assets/home.png'),
                    _buildNavItem(1, 'assets/community.png'),
                    _buildNavItem(2, 'assets/gallery.png'),
                    _buildNavItem(3, 'assets/catalog.png'),
                  ],
                ),
              ),
            ),
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