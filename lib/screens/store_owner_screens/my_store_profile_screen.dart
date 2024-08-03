import 'dart:io';
import 'dart:async';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:share_plus/share_plus.dart';
import 'package:tnennt/helpers/color_utils.dart';
import 'package:tnennt/models/product_model.dart';
import 'package:tnennt/models/store_category_model.dart';
import 'package:tnennt/models/store_model.dart';
import 'package:tnennt/models/store_update_model.dart';
import 'package:tnennt/screens/coming_soon.dart';
import 'package:tnennt/screens/store_community.dart';
import 'package:tnennt/screens/store_owner_screens/analytics_screen.dart';
import 'package:tnennt/screens/store_owner_screens/order_pays_screen.dart';
import 'package:tnennt/screens/store_owner_screens/product_categories_screen.dart';
import 'package:tnennt/screens/store_owner_screens/store_settings_screen.dart';
import 'package:tnennt/screens/update_screen.dart';
import 'package:tnennt/widgets/featured_product_tile.dart';
import 'package:tnennt/widgets/removable_product_tile.dart';
import 'package:tnennt/widgets/removable_update_tile.dart';

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
  late String storeWebsite = store.website;
  late bool isActive = store.isActive;
  late int totalProducts = store.totalProducts;
  late int totalPosts = store.totalPosts;
  late int storeEngagement = store.storeEngagement;
  late int greenFlags = store.greenFlags;
  late int totalFlags = store.greenFlags + store.redFlags;
  late int redFlags = store.redFlags;

  bool hasUpdates = false;
  bool isGreenFlag = true;
  bool isExpanded = false;

  List<StoreCategoryModel> categories = [];
  List<ProductModel> allProducts = [];
  List<ProductModel> filteredProducts = [];
  List<StoreUpdateModel> storeUpdates = [];
  TextEditingController searchController = TextEditingController();
  final ImagePicker _picker = ImagePicker();

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
      imageUrls: [
        'https://via.placeholder.com/150',
        'https://via.placeholder.com/150',
        'https://via.placeholder.com/150',
      ],
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
    );
  });

  @override
  void initState() {
    super.initState();
    store = widget.store;
    _fetchStore();
    _loadProducts();
    _fetchCategories();
    _fetchStoreUpdates();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _addStoreUpdate() async {
    XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image == null) return;

    String imageUrl = await _uploadImage(image);

    Timestamp now = Timestamp.now();
    Timestamp expiresAt =
        Timestamp.fromDate(now.toDate().add(Duration(hours: 24)));

    StoreUpdateModel newUpdate = StoreUpdateModel(
      updateId: '', // Firestore will generate this
      storeId: store.storeId,
      storeName: store.name,
      logoUrl: store.logoUrl,
      imageUrl: imageUrl,
      createdAt: now,
      expiresAt: expiresAt,
    );

    DocumentReference docRef = await FirebaseFirestore.instance
        .collection('storeUpdates')
        .add(newUpdate.toFirestore());

    setState(() {
      newUpdate = StoreUpdateModel(
        updateId: docRef.id,
        storeId: newUpdate.storeId,
        storeName: newUpdate.storeName,
        logoUrl: newUpdate.logoUrl,
        imageUrl: newUpdate.imageUrl,
        createdAt: newUpdate.createdAt,
        expiresAt: newUpdate.expiresAt,
      );
      storeUpdates.insert(0, newUpdate);
    });
  }

  Future<String> _uploadImage(XFile image) async {
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    Reference firebaseStorageRef =
        FirebaseStorage.instance.ref().child('store_updates/$fileName');
    UploadTask uploadTask = firebaseStorageRef.putFile(File(image.path));
    TaskSnapshot taskSnapshot = await uploadTask;
    String url = await taskSnapshot.ref.getDownloadURL();
    return url;
  }

  Future<void> _fetchStoreUpdates() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('storeUpdates')
          .where('storeId', isEqualTo: store.storeId)
          .orderBy('createdAt', descending: true)
          .get();

      setState(() {
        storeUpdates = querySnapshot.docs
            .map((doc) => StoreUpdateModel.fromFirestore(doc))
            .toList();
      });
    } catch (e) {
      print('Error fetching store updates: $e');
      setState(() {
        storeUpdates = []; // Set to empty list in case of error
      });
    }
  }

  Future<void> _deleteStoreUpdate(String updateId) async {
    await FirebaseFirestore.instance
        .collection('storeUpdates')
        .doc(updateId)
        .delete();

    setState(() {
      storeUpdates.removeWhere((update) => update.updateId == updateId);
    });
  }

  void _previewUpdate(StoreUpdateModel update) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UpdateScreen(
          storeImage: Image.network(store.logoUrl),
          storeName: store.name,
          initialUpdateIndex: storeUpdates.indexOf(update),
          updates: storeUpdates,
        ),
      ),
    );
  }

  Future<void> _loadProducts() async {
    allProducts = await _fetchProducts();
    filteredProducts = List.from(allProducts);
  }

  void _filterProducts(String query) {
    setState(() {
      filteredProducts = allProducts
          .where((product) =>
              product.name.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  Future<List<ProductModel>> _fetchProducts() async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('products')
        .where('storeId', isEqualTo: widget.store.storeId)
        .get();

    return querySnapshot.docs
        .map((doc) => ProductModel.fromFirestore(doc))
        .toList();
  }

  Future<void> _fetchStore() async {
    try {
      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection('Stores')
          .doc(store.storeId)
          .get();
      setState(() {
        store = StoreModel.fromFirestore(doc);
        logoUrl = store.logoUrl;
        storeName = store.name;
        storeCategory = store.category;
        storeLocation = store.location;
        storeWebsite = store.website;
        isActive = store.isActive;
        totalProducts = store.totalProducts;
        totalPosts = store.totalPosts;
        storeEngagement = store.storeEngagement;
        greenFlags = store.greenFlags;
        totalFlags = store.greenFlags + store.redFlags;
        redFlags = store.redFlags;
      });
    } catch (e) {
      print('Error fetching store: $e');
    }
  }

  Future<List<StoreCategoryModel>> _fetchCategories() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('Stores')
        .doc(store.storeId)
        .collection('categories')
        .get();

    return querySnapshot.docs
        .map((doc) => StoreCategoryModel.fromFirestore(doc))
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
      isGreenFlag = isGood;
      isExpanded = false;
      _controller.reverse();
    });
  }

  Future<void> _refresh() async {
    await _fetchStore();
    await _loadProducts();
    await _fetchCategories();
    await _fetchStoreUpdates();
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
                height: 290.h,
                width: 680.w,
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
                        radius: 30.w,
                        child: IconButton(
                          icon: Icon(
                            Icons.arrow_back_ios_new,
                            color: Colors.black,
                            size: 24.sp,
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
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(18.r),
                              child: Image.network(
                                logoUrl,
                                height: 130.h,
                                width: 130.w,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 12.w),
                                height: 30.h,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: Colors.transparent,
                                  border:
                                      Border.all(color: hexToColor('#DEFF98')),
                                  borderRadius: BorderRadius.circular(50.r),
                                ),
                                child: Text(
                                  '$storeCategory',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w500,
                                    fontSize: 13.sp,
                                  ),
                                ),
                              ),
                              SizedBox(height: 12.h),
                              SizedBox(
                                width: 400.w,
                                child: RichText(
                                  text: TextSpan(children: [
                                    TextSpan(
                                      text: storeName,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontFamily: 'Gotham Black',
                                        fontSize: 36.sp,
                                      ),
                                    ),
                                    TextSpan(
                                      text: '•',
                                      style: TextStyle(
                                        fontFamily: 'Gotham Black',
                                        fontSize: 36.sp,
                                        color: hexToColor('#42FF00'),
                                      ),
                                    ),
                                  ]),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              SizedBox(height: 16.h),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    'assets/icons/blue_globe.png',
                                    height: 16.w,
                                    width: 16.w,
                                  ),
                                  SizedBox(width: 8.w),
                                  Text(
                                    storeWebsite,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontFamily: 'Poppins',
                                        fontSize: 16.sp),
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
                          IconButton(
                              onPressed: () async {
                                final String shareMessage =
                                    'Check out ${widget.store.name} on Tnennt! ${widget.store.website}';
                                await Share.share(shareMessage);
                              },
                              icon: Icon(Icons.ios_share,
                                  color: Colors.white, size: 25.sp)),
                          SizedBox(width: 16.w),
                          Container(
                            height: 45.h,
                            width: 205.w,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: hexToColorWithOpacity('#C0C0C0', 0.2),
                              borderRadius: BorderRadius.circular(20.r),
                            ),
                            child: Text(
                              '$storeLocation',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'Poppins',
                                  fontSize: 17.sp),
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
                              fontSize: 14.sp,
                            ),
                          ),
                          Switch(
                              value: isActive,
                              activeColor: hexToColor('#41FA00'),
                              trackOutlineColor: WidgetStateColor.resolveWith(
                                  (states) => Colors.grey),
                              trackOutlineWidth:
                                  WidgetStateProperty.resolveWith(
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
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  crossAxisCount: 3,
                  mainAxisSpacing: 10.0,
                  crossAxisSpacing: 10.0,
                  children: [
                    GestureDetector(
                      onTap: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProductCategoriesScreen(
                              storeId: store.storeId,
                            ),
                          ),
                        );
                        await _refresh();
                      },
                      child: Container(
                        height: 180.h,
                        width: 180.w,
                        padding: EdgeInsets.all(16.w),
                        decoration: BoxDecoration(
                          color: hexToColor('#DDF1EF'),
                          borderRadius: BorderRadius.circular(22.r),
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
                                          fontSize: 21.sp,
                                        ),
                                      ),
                                      TextSpan(
                                        text: ' •',
                                        style: TextStyle(
                                          fontFamily: 'Gotham Black',
                                          fontSize: 21.sp,
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
                                    fontSize: 21.sp,
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
                                        fontSize: 24.sp,
                                      ),
                                    ),
                                    Text(
                                      'Products'.toUpperCase(),
                                      style: TextStyle(
                                        color: hexToColor('#7D7D7D'),
                                        fontSize: 12.sp,
                                      ),
                                    ),
                                  ],
                                ),
                                Container(
                                  padding: EdgeInsets.all(8.0),
                                  decoration: BoxDecoration(
                                    color: hexToColor('#0D6A6D'),
                                    borderRadius: BorderRadius.circular(50.r),
                                  ),
                                  child: Icon(
                                    Icons.add,
                                    color: Colors.white,
                                    size: 22.sp,
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
                            builder: (context) => ComingSoon(),
                          ),
                        );
                      },
                      child: Container(
                        height: 180.h,
                        width: 180.w,
                        padding: EdgeInsets.all(16.w),
                        decoration: BoxDecoration(
                          color: hexToColor('#EAE6F6'),
                          borderRadius: BorderRadius.circular(22.r),
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
                                      fontSize: 21.sp,
                                    ),
                                  ),
                                  TextSpan(
                                    text: ' •',
                                    style: TextStyle(
                                      fontFamily: 'Gotham Black',
                                      fontSize: 21.sp,
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
                                  height: 60.h,
                                  width: 80.w,
                                  fit: BoxFit.fill,
                                ),
                                Container(
                                  padding: EdgeInsets.all(8.0),
                                  decoration: BoxDecoration(
                                    color: Colors.grey[800],
                                    borderRadius: BorderRadius.circular(50.r),
                                  ),
                                  child: Icon(
                                    Icons.arrow_forward_ios,
                                    color: Colors.white,
                                    size: 22.sp,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => StoreCommunity(
                              store: store,
                            ),
                          ),
                        );
                        await _refresh();
                      },
                      child: Container(
                        height: 180.h,
                        width: 180.w,
                        padding: EdgeInsets.all(16.w),
                        decoration: BoxDecoration(
                          color: hexToColor('#EFEFEF'),
                          borderRadius: BorderRadius.circular(22.r),
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
                                          fontSize: 21.sp,
                                        ),
                                      ),
                                      TextSpan(
                                        text: ' •',
                                        style: TextStyle(
                                          fontFamily: 'Gotham Black',
                                          fontSize: 21.sp,
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
                                    fontSize: 21.sp,
                                  ),
                                ),
                                Text(
                                  'Post'.toUpperCase(),
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 21.sp,
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
                                        fontSize: 24.sp,
                                      ),
                                    ),
                                    Text(
                                      'Posts'.toUpperCase(),
                                      style: TextStyle(
                                        color: Colors.grey[700],
                                        fontSize: 12.sp,
                                      ),
                                    ),
                                  ],
                                ),
                                // right arrow box
                                Container(
                                  padding: EdgeInsets.all(8.0),
                                  decoration: BoxDecoration(
                                    color: Colors.grey[700],
                                    borderRadius: BorderRadius.circular(50.r),
                                  ),
                                  child: Icon(
                                    Icons.arrow_forward_ios,
                                    color: Colors.white,
                                    size: 22.sp,
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
              SizedBox(height: 20.h),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: 300.w,
                          height: 240.h,
                          padding: EdgeInsets.symmetric(
                              horizontal: 12.w, vertical: 16.h),
                          decoration: BoxDecoration(
                            color: hexToColor('#F3F3F3'),
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                height: 105.h,
                                width: 260.w,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(50.r),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Store Engagement',
                                      style: TextStyle(
                                        fontFamily: 'Poppins',
                                        fontWeight: FontWeight.w700,
                                        fontSize: 17.sp,
                                      ),
                                    ),
                                    Text(
                                      '$storeEngagement',
                                      style: TextStyle(
                                        color: Theme.of(context).primaryColor,
                                        fontSize: 32.sp,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 15.h),
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
                                                    ? (_animation.value * 80.w +
                                                        90.w)
                                                    : 80.w,
                                                height: 55.h,
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          50.r),
                                                ),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    GestureDetector(
                                                      onTap: () =>
                                                          _selectFlag(true),
                                                      child: Image.asset(
                                                          'assets/green-flag.png',
                                                          height: 36.h,
                                                          width: 36.w),
                                                    ),
                                                    if (isExpanded)
                                                      SizedBox(
                                                          width:
                                                              _animation.value *
                                                                  35.w),
                                                    if (isExpanded)
                                                      GestureDetector(
                                                        onTap: () =>
                                                            _selectFlag(false),
                                                        child: Image.asset(
                                                            'assets/red-flag.png',
                                                            height: 36.h,
                                                            width: 36.w),
                                                      ),
                                                  ],
                                                ),
                                              )
                                            : Container(
                                                width: 40,
                                                height: 35.0,
                                                padding: EdgeInsets.all(8.0),
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          50.0),
                                                ),
                                                child: Image.asset(
                                                    isGreenFlag
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
                                          isGreenFlag
                                              ? 'Good Reviews'
                                              : 'Bad Reviews',
                                          style: TextStyle(
                                            color: hexToColor('#272822'),
                                            fontFamily: 'Poppins',
                                            fontWeight: FontWeight.w600,
                                            fontSize: 20.sp,
                                          ),
                                        ),
                                        Text(
                                          isGreenFlag
                                              ? '$greenFlags/$totalFlags'
                                              : '$redFlags/$totalFlags',
                                          style: TextStyle(
                                            color: hexToColor('#838383'),
                                            fontSize: 18.sp,
                                          ),
                                        ),
                                      ],
                                    ),
                                ],
                              )
                            ],
                          ),
                        ),
                        Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => OrderAndPaysScreen(
                                          storeId: widget.store.storeId),
                                    ),
                                  );
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 16.w, vertical: 18.h),
                                  height: 112.h,
                                  width: 300.w,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: hexToColor('#F3F3F3'),
                                    borderRadius: BorderRadius.circular(50.r),
                                  ),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      CircleAvatar(
                                          backgroundColor: Colors.white,
                                          child: Icon(Icons.person_outline,
                                              color: Colors.black)),
                                      SizedBox(width: 16.w),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            'Orders & Pays',
                                            style: TextStyle(
                                              fontFamily: 'Poppins',
                                              fontWeight: FontWeight.w600,
                                              fontSize: 20.sp,
                                            ),
                                          ),
                                          SizedBox(
                                            width: 100,
                                            child: Text(
                                              'Orders, Payments & Coupons',
                                              style: TextStyle(
                                                color: hexToColor('#838383'),
                                                fontFamily: 'Gotham',
                                                fontSize: 14.sp,
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
                              SizedBox(height: 16.h),
                              GestureDetector(
                                onTap: () async {
                                  await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          StoreSettingsScreen(store: store),
                                    ),
                                  );
                                  _refresh();
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 16.w, vertical: 18.h),
                                  height: 112.h,
                                  width: 300.w,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: hexToColor('#F3F3F3'),
                                    borderRadius: BorderRadius.circular(50.r),
                                  ),
                                  child: Row(
                                    children: [
                                      CircleAvatar(
                                          backgroundColor: Colors.white,
                                          child: Icon(Icons.settings_outlined,
                                              color: Colors.black)),
                                      SizedBox(width: 16.w),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            'My Settings',
                                            style: TextStyle(
                                              fontFamily: 'Poppins',
                                              fontWeight: FontWeight.w600,
                                              fontSize: 20.sp,
                                            ),
                                          ),
                                          Text(
                                            'Store Settings',
                                            style: TextStyle(
                                              color: hexToColor('#838383'),
                                              fontFamily: 'Gotham',
                                              fontSize: 14.sp,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              )
                            ])
                      ],
                    ),
                  ),

                  SizedBox(height: 20.0),

                  // Updates
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 25.w),
                        child: Text(
                          'Updates',
                          style: TextStyle(
                            color: hexToColor('#343434'),
                            fontSize: 24.sp,
                          ),
                        ),
                      ),
                      SizedBox(height: 10.0),
                      Container(
                        height: 220.h,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: [
                            GestureDetector(
                              onTap: _addStoreUpdate,
                              child: Container(
                                  margin: EdgeInsets.only(left: 24.w),
                                  height: 72.h,
                                  width: 72.w,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: hexToColor('#EBEBEB'),
                                  ),
                                  child: Icon(Icons.add,
                                      size: 40.sp,
                                      color: hexToColor('#B5B5B5'))),
                            ),
                            ...storeUpdates.map((update) {
                              return RemovableUpdateTile(
                                image: update.imageUrl,
                                onRemove: () =>
                                    _deleteStoreUpdate(update.updateId),
                                onTap: () => _previewUpdate(update),
                              );
                            }).toList(),
                          ],
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 50.h),
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
                                fontSize: 24.sp,
                              ),
                            ),
                            Spacer(),
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
                                  builder: (context) =>
                                      _addFeaturedProductBottomSheet(),
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
                      FeatureProductsListView(
                          featuredProductIds: store.featuredProductIds),
                    ],
                  ),
                  SizedBox(height: 20.0),

                  FutureBuilder<List<StoreCategoryModel>>(
                    future: _fetchCategories(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      } else {
                        List<StoreCategoryModel> categories = snapshot.data!;
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

  Widget _addFeaturedProductBottomSheet() {
    return Container(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Add Featured Product',
            style: TextStyle(
              color: hexToColor('#343434'),
              fontSize: 18.0,
            ),
          ),
          SizedBox(height: 20.0),
          TextField(
            controller: searchController,
            decoration: InputDecoration(
              hintText: 'Search for a product',
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
            onChanged: _filterProducts,
          ),
          SizedBox(height: 20.0),
          Expanded(
            child: GridView.builder(
              padding: EdgeInsets.symmetric(horizontal: 8.0),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemCount: filteredProducts.length,
              itemBuilder: (context, index) {
                final product = filteredProducts[index];
                return FeaturedProductTile(product: product);
              },
            ),
          )
        ],
      ),
    );
  }
}

class FeatureProductsListView extends StatefulWidget {
  final List<String> featuredProductIds;

  const FeatureProductsListView({Key? key, required this.featuredProductIds})
      : super(key: key);

  @override
  State<FeatureProductsListView> createState() =>
      _FeatureProductsListViewState();
}

class _FeatureProductsListViewState extends State<FeatureProductsListView> {
  Future<List<ProductModel>> fetchProducts() async {
    if (widget.featuredProductIds.isEmpty) {
      return [];
    }
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('products')
        .where(FieldPath.documentId, whereIn: widget.featuredProductIds)
        .get();

    print('Fetched ${querySnapshot.docs.length} products');
    return querySnapshot.docs
        .map((doc) => ProductModel.fromFirestore(doc))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 340.h,
      child: FutureBuilder<List<ProductModel>>(
        future: fetchProducts(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            List<ProductModel> featuredProducts = snapshot.data!;
            if (featuredProducts.isEmpty) {
              return Center(
                child: Text(
                  'No Products in Featured',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              );
            }
            return ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: featuredProducts.length,
              itemBuilder: (context, index) {
                return RemovableProductTile(
                  product: featuredProducts[index],
                  onRemove: () {
                    setState(() {
                      widget.featuredProductIds
                          .remove(featuredProducts[index].productId);
                    });
                  },
                );
              },
            );
          }
        },
      ),
    );
  }
}

class CategoryProductsListView extends StatefulWidget {
  final StoreCategoryModel category;

  const CategoryProductsListView({Key? key, required this.category})
      : super(key: key);

  @override
  State<CategoryProductsListView> createState() =>
      _CategoryProductsListViewState();
}

class _CategoryProductsListViewState extends State<CategoryProductsListView> {
  Future<List<ProductModel>> fetchProducts() async {
    if (widget.category.productIds.isEmpty) {
      return [];
    }
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
    return FutureBuilder<List<ProductModel>>(
      future: fetchProducts(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return SizedBox.shrink(); // Don't show anything while loading
        } else if (snapshot.hasError) {
          return SizedBox.shrink(); // Don't show anything on error
        } else {
          List<ProductModel> products = snapshot.data!;
          if (products.isEmpty) {
            return SizedBox
                .shrink(); // Don't show the category if there are no products
          }
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  widget.category.name,
                  style: TextStyle(
                    color: hexToColor('#343434'),
                    fontSize: 24.sp,
                  ),
                ),
              ),
              SizedBox(height: 10.0),
              Container(
                height: 340.h,
                margin: EdgeInsets.only(bottom: 50.0),
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    return RemovableProductTile(
                      product: products[index],
                      onRemove: () {
                        setState(() {
                          widget.category.productIds
                              .remove(products[index].productId);
                        });
                      },
                    );
                  },
                ),
              ),
            ],
          );
        }
      },
    );
  }
}
