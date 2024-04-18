import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:tnennt/screens/home/catalog.dart';
import 'package:tnennt/screens/home/community.dart';
import 'package:tnennt/screens/home/gallery.dart';
import 'package:tnennt/screens/home/rental.dart';
import 'package:tnennt/screens/home/store_profile.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  static final List<Widget> _widgetOptions = <Widget>[
    StoreProfile(),
    Catalog(),
    Rental(),
    Gallery(),
    Community(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(children: [
          Positioned.fill(
            child: IndexedStack(
              index: _selectedIndex,
              children: _widgetOptions,
            ),
          ),

          // Bottom Navigation Bar
          Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
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
              ))
        ]),
      ),
    );
  }
}
