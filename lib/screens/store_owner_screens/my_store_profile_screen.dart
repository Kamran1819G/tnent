import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:tnennt/models/store_model.dart';
import 'package:tnennt/screens/product_detail_screen.dart';
import 'package:tnennt/helpers/color_utils.dart';
import 'package:tnennt/screens/store_owner_screens/all_products_screen.dart';
import 'package:tnennt/screens/store_owner_screens/analytics_screen.dart';
import 'package:tnennt/screens/store_owner_screens/order_pays_screen.dart';
import 'package:tnennt/screens/store_owner_screens/product_categories_screen.dart';
import 'package:tnennt/screens/store_owner_screens/store_settings_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MyStoreProfileScreen extends StatefulWidget {
  StoreModel store;

  MyStoreProfileScreen({required this.store});

  @override
  State<MyStoreProfileScreen> createState() => _MyStoreProfileScreenState();
}

class _MyStoreProfileScreenState extends State<MyStoreProfileScreen>
    with SingleTickerProviderStateMixin {
  late StoreModel store;

  late String storeImage = 'assets/jain_brothers.png';
  late String storeName = store.name;
  late String storeCategory = store.category;
  late String storeLocation = store.location;
  late  String storeWebsite = store.website;
  late bool isActive = store.isActive;
  late int totalProducts = store.totalProducts;
  late int totalPosts = store.totalPosts;
  late int storeEngagement = store.storeEngagement;
  late int goodReviews = store.goodReviews;
  late int badReviews = store.badReviews;
  late int totalReviews = store.goodReviews + store.badReviews;
  bool isGoodReview = true;
  bool isExpanded = false;

  List<dynamic> categories = [];


  Future<void> fetchCategories() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('categories').get();
      setState(() {
        categories = querySnapshot.docs.map((doc) => doc.data()).toList();
      });
    } catch (e) {
      print('Error fetching categories: $e');
    }
  }

  late AnimationController _controller;
  late Animation<double> _animation;

  List<dynamic> updates = List.generate(10, (index) {
    return {
      "name": "Sahachari",
      "coverImage": "assets/sahachari_image.png",
    };
  });

  List<dynamic> featuredProducts = List.generate(10, (index) {
    return {
      'name': 'Cannon XYZ',
      'image': 'assets/product_image.png',
      'price': 200.00,
    };
  });

  @override
  void initState()
  {
    super.initState();
    store = widget.store;
    _controller = AnimationController
      (
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _animation = CurvedAnimation
      (
      parent: _controller,
      curve: Curves.easeInOut,
    );
    super.initState();
    fetchCategories();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggleExpansion() {
    setState(() {
      isExpanded = !isExpanded;
      if (isExpanded) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
  }

  void _selectFlag(bool isGood) {
    setState(() {
      isGoodReview = isGood;
      isExpanded = false;
      _controller.reverse();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20.0),
            // Profile Card
            Container(
              height: 200,
              width: double.infinity,
              margin: EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                color: hexToColor('#2D332F'),
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: Stack(
                children: [
                  Positioned(
                    right: 16.0,
                    top: 16.0,
                    child: CircleAvatar(
                      backgroundColor: hexToColor('#F5F5F5'),
                      radius: 20,
                      child: IconButton(
                        icon: Icon(
                          Icons.arrow_back_ios_new,
                          color: Colors.black,
                          size: 18,
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment(-0.9, -0.5),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          margin: EdgeInsets.only(top: 8),
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12.0),
                            child: Image.asset(
                              '$storeImage',
                              height: 90,
                              width: 90,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 12.0, vertical: 6.0),
                              decoration: BoxDecoration(
                                color: Colors.transparent,
                                border:
                                    Border.all(color: hexToColor('#DEFF98')),
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                              child: Text(
                                '$storeCategory',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w500,
                                  fontSize: 8.0,
                                ),
                              ),
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  '$storeName',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 24.0,
                                  ),
                                ),
                                SizedBox(width: 10.0),
                                Container(
                                  width: 10,
                                  height: 10,
                                  margin: EdgeInsets.symmetric(vertical: 15),
                                  decoration: BoxDecoration(
                                    color: Colors.green,
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Image.asset(
                                  'assets/icons/blue_globe.png',
                                  height: 12.0,
                                  width: 12.0,
                                ),
                                SizedBox(width: 5.0),
                                Text(
                                  '$storeWebsite',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: 'Poppins',
                                      fontSize: 12.0),
                                ),
                              ],
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    alignment: Alignment(0.9, 0.9),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(Icons.ios_share, color: Colors.white, size: 22),
                        SizedBox(width: 10.0),
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 12.0, vertical: 8.0),
                          decoration: BoxDecoration(
                            color: hexToColorWithOpacity('#C0C0C0', 0.2),
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          child: Text(
                            '$storeLocation',
                            style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'Poppins',
                                fontSize: 12.0),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ),
                        Spacer(),
                        Text(
                          "Accepting Orders: ",
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Gotham',
                            fontWeight: FontWeight.w700,
                            fontSize: 11.0,
                          ),
                        ),
                        Switch(
                            value: isActive,
                            activeColor: hexToColor('#41FA00'),
                            trackOutlineColor: WidgetStateColor.resolveWith(
                                (states) => Colors.grey),
                            trackOutlineWidth: WidgetStateProperty.resolveWith(
                                (states) => 1.0),
                            activeTrackColor: Colors.transparent,
                            inactiveTrackColor: Colors.transparent,
                            onChanged: (value) {
                              setState(() {
                                isActive = value;
                              });
                            })
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 30.0),

            Expanded(
              flex: 0,
              child: GridView.count(
                padding: EdgeInsets.symmetric(horizontal: 12.0),
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                crossAxisCount: 3,
                mainAxisSpacing: 10.0,
                crossAxisSpacing: 10.0,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProductCategoriesScreen(),
                        ),
                      );
                    },
                    child: Container(
                      padding: EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        color: hexToColor('#DDF1EF'),
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              RichText(
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text: 'List'.toUpperCase(),
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontFamily: 'Gotham Black',
                                        fontSize: 14.0,
                                      ),
                                    ),
                                    TextSpan(
                                      text: ' •',
                                      style: TextStyle(
                                        fontFamily: 'Gotham Black',
                                        fontSize: 14.0,
                                        color: Colors.red,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Text(
                                'Product'.toUpperCase(),
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 14.0,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '$totalProducts',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 16.0,
                                    ),
                                  ),
                                  Text(
                                    'Products'.toUpperCase(),
                                    style: TextStyle(
                                      color: Colors.grey[700],
                                      fontSize: 10.0,
                                    ),
                                  ),
                                ],
                              ),
                              Container(
                                padding: EdgeInsets.all(4.0),
                                decoration: BoxDecoration(
                                  color: hexToColor('#0D6A6D'),
                                  borderRadius: BorderRadius.circular(50.0),
                                ),
                                child: Icon(
                                  Icons.add,
                                  color: Colors.white,
                                  size: 20.0,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AnalyticsScreen(),
                        ),
                      );
                    },
                    child: Container(
                      padding: EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        color: hexToColor('#EAE6F6'),
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: 'Analytics'.toUpperCase(),
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontFamily: 'Gotham Black',
                                    fontSize: 14.0,
                                  ),
                                ),
                                TextSpan(
                                  text: ' •',
                                  style: TextStyle(
                                    fontFamily: 'Gotham Black',
                                    fontSize: 14.0,
                                    color: Colors.green,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Image.asset(
                                'assets/icons/analytics.png',
                                height: 40.0,
                                width: 50.0,
                                fit: BoxFit.fill,
                              ),
                              Container(
                                padding: EdgeInsets.all(8.0),
                                decoration: BoxDecoration(
                                  color: Colors.grey[800],
                                  borderRadius: BorderRadius.circular(50.0),
                                ),
                                child: Icon(
                                  Icons.arrow_forward_ios,
                                  color: Colors.white,
                                  size: 16.0,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => StoreCommunity(),
                        ),
                      );
                    },
                    child: Container(
                      padding: EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        color: hexToColor('#EFEFEF'),
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              RichText(
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text: 'Store'.toUpperCase(),
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontFamily: 'Gotham Black',
                                        fontSize: 14.0,
                                      ),
                                    ),
                                    TextSpan(
                                      text: ' •',
                                      style: TextStyle(
                                        fontFamily: 'Gotham Black',
                                        fontSize: 14.0,
                                        color: Colors.red,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Text(
                                'Community'.toUpperCase(),
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 14.0,
                                ),
                              ),
                              Text(
                                'Post'.toUpperCase(),
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 14.0,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '$totalPosts',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 16.0,
                                    ),
                                  ),
                                  Text(
                                    'Posts'.toUpperCase(),
                                    style: TextStyle(
                                      color: Colors.grey[700],
                                      fontSize: 10.0,
                                    ),
                                  ),
                                ],
                              ),
                              // right arrow box
                              Container(
                                padding: EdgeInsets.all(8.0),
                                decoration: BoxDecoration(
                                  color: Colors.grey[700],
                                  borderRadius: BorderRadius.circular(50.0),
                                ),
                                child: Icon(
                                  Icons.arrow_forward_ios,
                                  color: Colors.white,
                                  size: 16.0,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20.0),

            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 16),
                              margin: EdgeInsets.only(right: 8.0),
                              decoration: BoxDecoration(
                                color: hexToColor('#F3F3F3'),
                                borderRadius: BorderRadius.circular(30.0),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    padding: EdgeInsets.only(
                                      left: 20.0,
                                      right: 25.0,
                                      top: 12.0,
                                      bottom: 6.0,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(50.0),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Store Engagement',
                                          style: TextStyle(
                                            fontFamily: 'Poppins',
                                            fontWeight: FontWeight.w700,
                                            fontSize: 12.0,
                                          ),
                                        ),
                                        Text(
                                          '$storeEngagement',
                                          style: TextStyle(
                                            color:
                                                Theme.of(context).primaryColor,
                                            fontSize: 22.0,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 15.0),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      AnimatedBuilder(
                                        animation: _animation,
                                        builder: (context, child) {
                                          return GestureDetector(
                                            onTap: _toggleExpansion,
                                            child: isExpanded
                                                ? Container(
                                                    width: isExpanded
                                                        ? (_animation.value *
                                                                60 +
                                                            40)
                                                        : 40,
                                                    height: 45.0,
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 16.0),
                                                    decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              50.0),
                                                    ),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        GestureDetector(
                                                          onTap: () =>
                                                              _selectFlag(true),
                                                          child: Image.asset(
                                                              'assets/green-flag.png',
                                                              height: 20.0,
                                                              width: 20.0),
                                                        ),
                                                        if (isExpanded)
                                                          SizedBox(
                                                              width: _animation
                                                                      .value *
                                                                  25),
                                                        if (isExpanded)
                                                          GestureDetector(
                                                            onTap: () =>
                                                                _selectFlag(
                                                                    false),
                                                            child: Image.asset(
                                                                'assets/red-flag.png',
                                                                height: 20.0,
                                                                width: 20.0),
                                                          ),
                                                      ],
                                                    ),
                                                  )
                                                : Container(
                                                    width: 40,
                                                    height: 35.0,
                                                    padding:
                                                        EdgeInsets.all(8.0),
                                                    decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              50.0),
                                                    ),
                                                    child: Image.asset(
                                                        isGoodReview
                                                            ? 'assets/green-flag.png'
                                                            : 'assets/red-flag.png',
                                                        height: 20.0,
                                                        width: 20.0),
                                                  ),
                                          );
                                        },
                                      ),
                                      if (!isExpanded)
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              isGoodReview
                                                  ? 'Good Reviews'
                                                  : 'Bad Reviews',
                                              style: TextStyle(
                                                color: hexToColor('#272822'),
                                                fontFamily: 'Poppins',
                                                fontWeight: FontWeight.w600,
                                                fontSize: 14.0,
                                              ),
                                            ),
                                            Text(
                                              isGoodReview
                                                  ? '$goodReviews/$totalReviews'
                                                  : '$badReviews/$totalReviews',
                                              style: TextStyle(
                                                color: hexToColor('#838383'),
                                                fontSize: 12.0,
                                              ),
                                            ),
                                          ],
                                        ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              OrderAndPaysScreen(),
                                        ),
                                      );
                                    },
                                    child: Container(
                                      padding: EdgeInsets.all(16.0),
                                      decoration: BoxDecoration(
                                        color: hexToColor('#F3F3F3'),
                                        borderRadius:
                                            BorderRadius.circular(50.0),
                                      ),
                                      child: Row(
                                        children: [
                                          CircleAvatar(
                                              backgroundColor: Colors.white,
                                              child: Icon(Icons.person_outline,
                                                  color: Colors.black)),
                                          SizedBox(width: 10.0),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Orders & Pays',
                                                style: TextStyle(
                                                  fontFamily: 'Poppins',
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 14.0,
                                                ),
                                              ),
                                              SizedBox(
                                                width: 100,
                                                child: Text(
                                                  'Orders, Payments & Coupons',
                                                  style: TextStyle(
                                                    color:
                                                        hexToColor('#838383'),
                                                    fontFamily: 'Gotham',
                                                    fontSize: 10.0,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                  maxLines: 2,
                                                ),
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 10.0),
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              StoreSettingsScreen(),
                                        ),
                                      );
                                    },
                                    child: Container(
                                      padding: EdgeInsets.all(16.0),
                                      decoration: BoxDecoration(
                                        color: hexToColor('#F3F3F3'),
                                        borderRadius:
                                            BorderRadius.circular(50.0),
                                      ),
                                      child: Row(
                                        children: [
                                          CircleAvatar(
                                              backgroundColor: Colors.white,
                                              child: Icon(
                                                  Icons.settings_outlined,
                                                  color: Colors.black)),
                                          SizedBox(width: 10.0),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'My Settings',
                                                style: TextStyle(
                                                  fontFamily: 'Poppins',
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 14.0,
                                                ),
                                              ),
                                              Text(
                                                'Store Settings',
                                                style: TextStyle(
                                                  color: hexToColor('#838383'),
                                                  fontFamily: 'Gotham',
                                                  fontSize: 10.0,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                  )
                                ]),
                          )
                        ],
                      ),
                    ),

                    SizedBox(height: 20.0),

                    // Updates
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Text(
                            'Updates',
                            style: TextStyle(
                              color: hexToColor('#343434'),
                              fontSize: 18.0,
                            ),
                          ),
                        ),
                        SizedBox(height: 10.0),
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 4.0),
                          height: 150.0,
                          child: ListView(
                            scrollDirection: Axis.horizontal,
                            children: [
                              Container(
                                padding: EdgeInsets.all(8.0),
                                child: Column(
                                  children: [
                                    Container(
                                      height: 100,
                                      width: 100,
                                      decoration: BoxDecoration(
                                        color: hexToColor('#F3F3F3'),
                                        borderRadius:
                                        BorderRadius.circular(12.0),
                                      ),
                                      child: Container(
                                          margin: EdgeInsets.all(16.0),
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Colors.white,
                                          ),
                                          child: Icon(Icons.add,
                                              size: 34.0,
                                              color:
                                              hexToColor('#B5B5B5'))),
                                    ),
                                  ],
                                ),
                              ),
                              ...updates.map((update) {
                                return UpdateTile(
                                  name: update['name'],
                                  image: update['coverImage'],
                                );
                              }).toList(),
                            ],
                          ),
                        ),
                      ],
                    ),

                    // Featured Products
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Featured Products Section
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Row(
                            children: [
                              Text(
                                'Featured',
                                style: TextStyle(
                                  color: hexToColor('#343434'),
                                  fontSize: 18.0,
                                ),
                              ),
                              Spacer(),
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => AllProductsScreen(),
                                    ),
                                  );
                                },
                                child: Container(
                                  padding: EdgeInsets.all(6.0),
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).primaryColor,
                                    borderRadius: BorderRadius.circular(6.0),
                                  ),
                                  child: Icon(
                                    Icons.add,
                                    color: Colors.white,
                                    size: 16.0,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 20.0),
                        Container(
                          height: 200.0,
                          padding: EdgeInsets.only(left: 8.0),
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: featuredProducts.length,
                            itemBuilder: (context, index) {
                              return ProductTile(
                                name: featuredProducts[index]['name'],
                                image: featuredProducts[index]['image'],
                                price: featuredProducts[index]['price'],
                              );
                            },
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 20.0),
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

class StoreCommunity extends StatefulWidget {
  const StoreCommunity({super.key});

  @override
  State<StoreCommunity> createState() => _StoreCommunityState();
}

class _StoreCommunityState extends State<StoreCommunity> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Container(
              height: 100,
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  Container(
                    height: 75,
                    width: 100,
                    padding:
                        EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                    decoration: BoxDecoration(
                      border:
                          Border.all(color: hexToColor('#BEBEBE'), width: 1.0),
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '17',
                          style: TextStyle(
                            color: hexToColor('#343434'),
                            fontSize: 20.0,
                          ),
                        ),
                        Text(
                          'Posts',
                          style: TextStyle(
                            color: hexToColor('#7D7D7D'),
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w700,
                            fontSize: 14.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Spacer(),
                  Container(
                    margin: EdgeInsets.all(8.0),
                    child: CircleAvatar(
                      backgroundColor: hexToColor('#F5F5F5'),
                      child: IconButton(
                        icon: Icon(Icons.arrow_back_ios, color: Colors.black),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ),
                  )
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    CommunityPost(
                      name: 'Kamran Khan',
                      profileImage: 'assets/profile_image.png',
                      postTime: '8 h ago',
                      caption:
                          'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',
                      image: 'assets/post_image.png',
                      likes: 991,
                      productLink: 'https://example.com/product',
                    ),
                    CommunityPost(
                      name: 'Kamran Khan',
                      profileImage: 'assets/profile_image.png',
                      postTime: '8 h ago',
                      caption:
                          'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',
                      likes: 991,
                    ),
                    CommunityPost(
                      name: 'Kamran Khan',
                      profileImage: 'assets/profile_image.png',
                      postTime: '8 h ago',
                      caption:
                          'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',
                      likes: 991,
                    ),
                    SizedBox(height: 100.0),
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

class CommunityPost extends StatelessWidget {
  final String name;
  final String profileImage;
  final String postTime;
  final String? image;
  final String? caption;
  final String? productLink;
  final int? likes;

  const CommunityPost({
    super.key,
    required this.name,
    required this.profileImage,
    required this.postTime,
    this.image,
    this.caption,
    this.productLink,
    this.likes,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // User information row
          Row(
            children: [
              Row(
                children: [
                  CircleAvatar(
                    backgroundImage: AssetImage(profileImage),
                    radius: 20.0,
                  ),
                  const SizedBox(width: 16.0),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: const TextStyle(
                          fontSize: 18.0,
                        ),
                      ),
                      Text(
                        postTime,
                        style: TextStyle(
                          color: hexToColor('#9C9C9C'),
                          fontSize: 10.0,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const Spacer(),
              GestureDetector(
                onTap: () {
                  showModalBottomSheet(
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(12),
                        topRight: Radius.circular(12),
                      ),
                    ),
                    context: context,
                    builder: (context) => _buildMoreBottomSheet(),
                  );
                },
                child: CircleAvatar(
                  backgroundColor: hexToColor('#F5F5F5'),
                  child: Icon(
                    Icons.more_horiz,
                    color: hexToColor('#BEBEBE'),
                    size: 20,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 16.0),
          // Caption
          if (caption != null)
            Text(
              caption!,
              style: TextStyle(
                color: hexToColor('#737373'),
                fontSize: 12.0,
              ),
            ),
          SizedBox(height: 10),
          // Post image
          if (image != null)
            ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Image.asset(
                image!,
                fit: BoxFit.cover,
              ),
            ),
          SizedBox(height: 10),
          // Likes
          Row(
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 6.0),
                decoration: BoxDecoration(
                  border: Border.all(color: hexToColor('#BEBEBE')),
                  borderRadius: BorderRadius.circular(50.0),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.favorite,
                      color: Colors.red,
                    ),
                    const SizedBox(width: 8.0),
                    Text(
                      '$likes',
                      style: TextStyle(
                          color: hexToColor('#989797'), fontSize: 12.0),
                    ),
                  ],
                ),
              ),
              Spacer(),
              if (productLink != null)
                Chip(
                  backgroundColor: hexToColor('#EDEDED'),
                  side: BorderSide.none,
                  label: Text(
                    '${productLink!}',
                    style: TextStyle(
                      color: hexToColor('#B4B4B4'),
                      fontFamily: 'Gotham',
                      fontWeight: FontWeight.w500,
                      fontSize: 12.0,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  avatar: Icon(
                    Icons.link_outlined,
                    color: hexToColor('#B4B4B4'),
                  ),
                ),
              Spacer(),
              Icon(Icons.ios_share_outlined)
            ],
          ),
        ],
      ),
    );
  }

  _buildMoreBottomSheet() {
    return Container(
      height: 250,
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 100,
              height: 4,
              margin: const EdgeInsets.symmetric(vertical: 15),
              decoration: BoxDecoration(
                color: hexToColor('#CACACA'),
                borderRadius: BorderRadius.circular(5),
              ),
            ),
          ),
          SizedBox(height: 50),
          CircleAvatar(
            backgroundColor: hexToColor('#2B2B2B'),
            child: Icon(
              Icons.report_gmailerrorred,
              color: hexToColor('#BEBEBE'),
              size: 20,
            ),
          ),
          SizedBox(height: 20),
          Text(
            'Report',
            style: TextStyle(
              color: hexToColor('#9B9B9B'),
              fontSize: 16.0,
            ),
          ),
        ],
      ),
    );
  }
}

class UpdateTile extends StatelessWidget {
  final String name;
  final String image;

  UpdateTile({
    required this.name,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8.0),
      child: Column(
        children: [
          Container(
              height: 100,
              width: 100,
              decoration: BoxDecoration(
                border: Border.all(color: hexToColor('#B5B5B5'), width: 1.0),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Image.asset(image, height: 48.0)),
        ],
      ),
    );
  }
}

class ProductTile extends StatefulWidget {
  final String name;
  final String image;
  final double price;

  ProductTile({
    required this.name,
    required this.image,
    required this.price,
  });

  @override
  _ProductTileState createState() => _ProductTileState();
}

class _ProductTileState extends State<ProductTile> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetailScreen(
              images: [
                Image.asset(widget.image),
                Image.asset(widget.image),
                Image.asset(widget.image),
              ],
              productName: widget.name,
              productDescription:
                  'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. eiusmod tempor incididunt ut labore et do.',
              productPrice: widget.price,
              storeName: 'Jain Brothers',
              storeLogo: 'assets/jain_brothers.png',
              Discount: 10,
            ),
          ),
        );
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 8.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6.0),
          color: hexToColor('#F5F5F5'),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Container(
                  height: 150,
                  width: 150,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                    image: DecorationImage(
                      image: AssetImage(widget.image),
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
                Positioned(
                  right: 8.0,
                  top: 8.0,
                  child: GestureDetector(
                    onTap: () {
                      showModalBottomSheet(
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(12),
                            topRight: Radius.circular(12),
                          ),
                        ),
                        context: context,
                        builder: (context) {
                          return Container(
                            height: 200,
                            width: double.infinity,
                            padding: EdgeInsets.symmetric(horizontal: 16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Center(
                                  child: Container(
                                    width: 100,
                                    height: 4,
                                    margin: const EdgeInsets.symmetric(
                                        vertical: 15),
                                    decoration: BoxDecoration(
                                      color: hexToColor('#CACACA'),
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 40),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Column(
                                      children: [
                                        Container(
                                          padding: EdgeInsets.all(12.0),
                                          decoration: BoxDecoration(
                                            color: hexToColor('#2B2B2B'),
                                            borderRadius:
                                                BorderRadius.circular(100.0),
                                          ),
                                          child: Icon(
                                            Icons.edit_note,
                                            color: Colors.white,
                                            size: 25,
                                          ),
                                        ),
                                        SizedBox(height: 10),
                                        Text(
                                          'Edit',
                                          style: TextStyle(
                                              color: hexToColor('#9C9C9C'),
                                              fontSize: 16.0),
                                        ),
                                      ],
                                    ),
                                    Column(
                                      children: [
                                        Container(
                                          padding: EdgeInsets.all(12.0),
                                          decoration: BoxDecoration(
                                            color: hexToColor('#2B2B2B'),
                                            borderRadius:
                                                BorderRadius.circular(100.0),
                                          ),
                                          child: Icon(
                                            Icons.delete,
                                            color: Colors.white,
                                            size: 25,
                                          ),
                                        ),
                                        SizedBox(height: 10),
                                        Text(
                                          'Delete',
                                          style: TextStyle(
                                              color: hexToColor('#9C9C9C'),
                                              fontSize: 16.0),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                    child: Container(
                      padding: EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(100.0),
                      ),
                      child: Icon(
                        Icons.remove,
                        color: Colors.red,
                        size: 14.0,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 8.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    widget.name,
                    style:
                        TextStyle(color: hexToColor('#343434'), fontSize: 10.0),
                  ),
                  SizedBox(height: 8.0),
                  Text(
                    '\$${widget.price.toString()}',
                    style:
                        TextStyle(color: hexToColor('#343434'), fontSize: 10.0),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
