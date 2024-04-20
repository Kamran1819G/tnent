import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:tnennt/screens/home_pages/catalog.dart';
import 'package:tnennt/screens/home_pages/community.dart';
import 'package:tnennt/screens/home_pages/gallery.dart';
import 'package:tnennt/screens/home_pages/rental.dart';
import 'package:tnennt/screens/home_pages/store_profile.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  PageController _pageController = PageController();

  static final List<Widget> _widgetOptions = <Widget>[
    SingleChildScrollView(child: StoreProfile()),
    Catalog(),
    Rental(),
    Gallery(),
    Community(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: PageView(
          physics: NeverScrollableScrollPhysics(),
          controller: _pageController,
          onPageChanged: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
          children: _widgetOptions,
        ),
      ),
      // Bottom Navigation Bar
      bottomNavigationBar: Container(
        margin: EdgeInsets.all(20),
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.grey[900],
          borderRadius: BorderRadius.circular(50),
        ),
        child: GNav(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          color: Colors.grey,
          activeColor: Colors.black,
          tabBackgroundColor: Colors.white,
          hoverColor: Colors.white,
          iconSize: 24,
          onTabChange: (index) {
            setState(() {
              _selectedIndex = index;
              _pageController.animateToPage(
                index,
                duration: Duration(milliseconds: 500),
                curve: Curves.easeInOut,
              );
            });
          },
          tabs: const [
            GButton(
              icon: Icons.home_filled,
            ),
            GButton(
              icon: Icons.collections_bookmark,
            ),
            GButton(
              icon: Icons.add_shopping_cart_rounded,
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
    );
  }
}
