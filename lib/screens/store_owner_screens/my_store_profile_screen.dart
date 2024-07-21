import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:tnennt/models/category_model.dart';
import 'package:tnennt/models/community_post_model.dart';
import 'package:tnennt/models/product_model.dart';
import 'package:tnennt/models/store_model.dart';
import 'package:tnennt/screens/product_detail_screen.dart';
import 'package:tnennt/helpers/color_utils.dart';
import 'package:tnennt/screens/store_owner_screens/store_community.dart';
import 'package:tnennt/widgets/product_tile.dart';
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
  late String logoUrl = store.logoUrl;
  late String storeName = store.name;
  late String storeCategory = store.category;
  late String storeLocation = store.location;
  late  String storeWebsite = store.website;
  late bool isActive = store.isActive;
  late int totalProducts = store.totalProducts;
  late int totalPosts = store.totalPosts;
  late int storeEngagement = store.storeEngagement;
  late int greenFlags = store.greenFlags;
  late int totalFlags = store.greenFlags + store.redFlags;
  late int redFlags = store.redFlags;
  bool isGoodReview = true;
  bool isExpanded = false;

  List<CategoryModel> categories = [];


  late AnimationController _controller;
  late Animation<double> _animation;

  List<dynamic> updates = List.generate(10, (index) {
    return {
      "name": "Sahachari",
      "coverImage": "assets/sahachari_image.png",
    };
  });

  List<ProductModel> featuredProducts = List.generate(5, (index) {
    return ProductModel(
      productId: 'product123',
      storeId: 'EBJgGaWsnrluCKcaOUOT',
      name: 'Premium Cotton T-Shirt',
      description: 'A high-quality, comfortable cotton t-shirt',
      productCategory: 'T-Shirts',
      storeCategory: 'Apparel',
      imageUrls: ['https://example.com/tshirt1.jpg', 'https://example.com/tshirt2.jpg'],
      isAvailable: true,
      createdAt: Timestamp.now(),
      greenFlags: 0,
      redFlags: 0,
      variations: {
          'S': ProductVariant(
            price: 24.99,
            mrp: 29.99,
            discount: 16.67,
            stockQuantity: 50,
            sku: 'TS-S',
          ),
          'M': ProductVariant(
            price: 24.99,
            mrp: 29.99,
            discount: 16.67,
            stockQuantity: 100,
            sku: 'TS-M',
          ),
          'L': ProductVariant(
            price: 26.99,
            mrp: 31.99,
            discount: 15.63,
            stockQuantity: 75,
            sku: 'TS-L',
          ),
      },
      reviewsIds: [],
    );
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

  Future<List<CategoryModel>> fetchCategories() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('Stores')
        .doc(store.storeId)
        .collection('categories')
        .get();

    return querySnapshot.docs
        .map((doc) => CategoryModel.fromFirestore(doc))
        .toList();
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
        child: SingleChildScrollView(
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
                              child: Image.network(
                                logoUrl,
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
                            builder: (context) => ProductCategoriesScreen(
                              storeId: store.storeId,
                            ),
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
                            builder: (context) => StoreCommunity(
                              store: store,
                            ),
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
              Column(
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
                                                ? '$greenFlags/$totalFlags'
                                                : '$redFlags/$totalFlags',
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
                              product: featuredProducts[index],
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20.0),

                  FutureBuilder<List<CategoryModel>>(
                    future: fetchCategories(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      } else {
                        List<CategoryModel> categories = snapshot.data!;
                        return Column(
                          children: categories
                              .map((category) =>
                              CategoryProductsListView(category: category))
                              .toList(),
                        );
                      }
                    },
                  ),

                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CategoryProductsListView extends StatefulWidget {
  final CategoryModel category;

  const CategoryProductsListView({Key? key, required this.category}) : super(key: key);

  @override
  State<CategoryProductsListView> createState() => _CategoryProductsListViewState();
}

class _CategoryProductsListViewState extends State<CategoryProductsListView> {

  Future<List<ProductModel>> fetchProducts() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('products')
        .where(FieldPath.documentId, whereIn: widget.category.productIds)
        .get();

    print('Fetched ${querySnapshot.docs.length} products');
    return querySnapshot.docs
        .map((doc) => ProductModel.fromFirestore(doc))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            widget.category.name,
            style: TextStyle(
              color: hexToColor('#343434'),
              fontSize: 18.0,
            ),
          ),
        ),
        SizedBox(height: 10.0),
        Container(
          height: 200.0,
          child: FutureBuilder<List<ProductModel>>(
            future: fetchProducts(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else {
                List<ProductModel> products = snapshot.data!;
                return ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    return ProductTile(
                      product: products[index],
                    );
                  },
                );
              }
            },
          ),
        ),
      ],
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
