import 'dart:async';
import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';
import 'package:tnent/helpers/color_utils.dart';
import 'package:tnent/models/store_category_model.dart';
import 'package:tnent/models/product_model.dart';
import 'package:tnent/models/store_model.dart';
import 'package:tnent/models/store_update_model.dart';
import 'package:tnent/models/user_model.dart';
import 'package:tnent/pages/catalog_pages/cart_screen.dart';
import 'package:tnent/screens/explore_screen.dart';
import 'package:tnent/screens/notification_screen.dart';
import 'package:tnent/screens/stores_screen.dart';
import 'package:tnent/screens/users_screens/myprofile_screen.dart';
import 'package:tnent/widgets/wishlist_product_tile.dart';
import '../../screens/update_screen.dart';
import '../../screens/users_screens/storeprofile_screen.dart';

class Home extends StatefulWidget {
  final UserModel currentUser;

  const Home({Key? key, required this.currentUser}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with TickerProviderStateMixin {
  late String firstName;
  late String lastName;
  late TabController _tabController;
  int _selectedIndex = 0;
  bool isNewNotification = true;

  final List<String> carouselImgList = [
    'assets/carousel1.png',
    'assets/carousel2.png',
    'assets/carousel3.png',
  ];

  List<Map<String, dynamic>> categories = [
    {
      'name': 'Clothings',
      'image': 'assets/categories/clothings.png',
    },
    {
      'name': 'Electronics',
      'image': 'assets/categories/electronics.png',
    },
    {
      'name': 'Grocery',
      'image': 'assets/categories/grocery.png',
    },
    {
      'name': 'Accessories',
      'image': 'assets/categories/accessories.png',
    },
    {
      'name': 'Books',
      'image': 'assets/categories/books.png',
    },
    {
      'name': 'More',
      'image': 'assets/categories/more.png',
    },
  ];

  List<StoreUpdateModel> updates = [];

  /*List<ProductModel> featuredProducts = List.generate(5, (index) {
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
  });*/

  /*List<StoreModel> featuredStores = List.generate(5, (index) {
    return StoreModel(
      storeId: 'store$index',
      ownerId: 'owner$index',
      name: 'Store Name $index',
      logoUrl: 'https://via.placeholder.com/150',
      phone: '123-456-789$index',
      email: 'store$index@example.com',
      website: 'https://example.com/store$index',
      upiUsername: 'upiUser$index',
      upiId: 'upiId$index',
      location: 'Location $index',
      category: 'Category $index',
      isActive: index % 2 == 0,
      createdAt: Timestamp.now(),
      totalProducts: index * 10,
      totalPosts: index * 5,
      storeEngagement: index * 20,
      greenFlags: index * 2,
      redFlags: index,
      followerIds: [],
      featuredProductIds: [],
    );
  });
*/
  List<StoreModel> featuredStores = [];
  List<ProductModel> featuredProducts = [];

  @override
  void initState() {
    super.initState();
    _fetchFeaturedStores();
    _fetchFeaturedProducts();
    _fetchUpdates();

    setState(() {
      firstName = widget.currentUser.firstName;
      lastName = widget.currentUser.lastName;
    });
    _tabController = TabController(
      length: 6,
      vsync: this,
    );
    _tabController.addListener(() {
      setState(() {
        _selectedIndex = _tabController.index;
      });
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  String _getTabLabel(int index) {
    switch (index) {
      case 0:
        return 'Electronics';
      case 1:
        return 'Clothings';
      case 2:
        return 'Accessories';
      case 3:
        return 'Groceries';
      case 4:
        return 'Books';
      case 5:
        return 'More';
      default:
        return '';
    }
  }

  String getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Good Morning ⛅';
    } else if (hour < 18) {
      return 'Good Afternoon 🌤️';
    } else {
      return 'Good Evening 🌕';
    }
  }

  Future<void> _fetchFeaturedStores() async {
    try {
      // Fetch the featured-store document from the Featured Stores collection
      final featuredStoreDoc = await FirebaseFirestore.instance
          .collection('Featured Stores')
          .doc('featured-stores')
          .get();

      // Extract the store IDs from the array field
      final List<String> storeId =
          List<String>.from(featuredStoreDoc['stores'] ?? []);

      // Fetch the actual store documents using the store IDs
      if (storeId.isNotEmpty) {
        final storesSnapshot = await FirebaseFirestore.instance
            .collection('Stores')
            .where(FieldPath.documentId, whereIn: storeId)
            .get();

        setState(() {
          featuredStores = storesSnapshot.docs
              .map((doc) => StoreModel.fromFirestore(doc))
              .toList();
        });
      } else {
        setState(() {
          featuredStores = [];
        });
      }
    } catch (e) {
      print('Error fetching featured stores: $e');
    }
  }

  Future<void> _fetchFeaturedProducts() async {
    try {
      // Fetch the featured-products document from the Featured Products collection
      final featuredProductDoc = await FirebaseFirestore.instance
          .collection('Featured Products')
          .doc('featured-products')
          .get();

      // Extract the product IDs from the array field
      final List<String> productIds =
          List<String>.from(featuredProductDoc['products'] ?? []);

      // Fetch the actual product documents using the product IDs
      if (productIds.isNotEmpty) {
        List<ProductModel> products = [];

        for (String productId in productIds) {
          final productDoc = await FirebaseFirestore.instance
              .collection('products')
              .doc(productId)
              .get();

          if (productDoc.exists) {
            products.add(ProductModel.fromFirestore(productDoc));
          }
        }

        setState(() {
          featuredProducts = products;
        });
      } else {
        setState(() {
          featuredProducts = [];
        });
      }
    } catch (e) {
      print('Error fetching featured products: $e');
    }
  }

  void _fetchUpdates() async {
    List<StoreUpdateModel> fetchedUpdates = await _fetchAndPopulateUpdates();
    setState(() {
      updates = fetchedUpdates;
      sortInGroupedupdates();
    });
  }

  bool isUpdatesLoading = false;

  Future<List<StoreUpdateModel>> _fetchAndPopulateUpdates() async {
    final now = DateTime.now();
    final oneDayAgo = now.subtract(const Duration(hours: 24));
    final currentUserId = FirebaseAuth.instance.currentUser!.uid;

    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('storeUpdates')
        .where('createdAt', isGreaterThanOrEqualTo: oneDayAgo)
        .get();

    setState(() {
      isUpdatesLoading = true;
    });

    List<StoreUpdateModel> updatesLocal = [];

    for (var doc in snapshot.docs) {
      final createdAt = (doc['createdAt'] as Timestamp).toDate();
      final expiresAt = (doc['expiresAt'] as Timestamp).toDate();
      final storeId = doc['storeId'];

      if (now.isBefore(expiresAt) && createdAt.isAfter(oneDayAgo)) {
        DocumentSnapshot storeDoc = await FirebaseFirestore.instance
            .collection('Stores')
            .doc(storeId)
            .get();

        List<String> followerIds = List<String>.from(storeDoc['followerIds']);
        if (followerIds.contains(currentUserId)) {
          final storeUpdateModel = StoreUpdateModel.fromFirestore(doc);
          // Handling the logic that 2/more updates from same store dont show individually in home page

          updatesLocal.add(storeUpdateModel);
        }
      }
    }

    setState(() {
      isUpdatesLoading = false;
    });

    return updatesLocal;
  }

  Map<String, List<StoreUpdateModel>> groupedUpdates = {};

  void sortInGroupedupdates() {
    for (var update in updates) {
      if (groupedUpdates.containsKey(update.storeName)) {
        groupedUpdates[update.storeName]!.add(update);
      } else {
        groupedUpdates[update.storeName] = [update];
      }
    }
  }

  final double size = 30.0;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 100.h,
          margin: EdgeInsets.only(top: 20.h, bottom: 20.h),
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(getGreeting().toUpperCase(),
                        style: TextStyle(
                            color: hexToColor('#727272'), fontSize: 18.sp)),
                    SizedBox(height: 12.h),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.5,
                      child: RichText(
                        text: TextSpan(children: [
                          TextSpan(
                            text: '$firstName $lastName',
                            style: TextStyle(
                              color: Colors.black,
                              fontFamily: 'Gotham Black',
                              fontSize: 35.sp,
                            ),
                          ),
                          TextSpan(
                            text: ' •',
                            style: TextStyle(
                              fontFamily: 'Gotham Black',
                              fontSize: 35.sp,
                              color: hexToColor('#42FF00'),
                            ),
                          ),
                        ]),
                        overflow: TextOverflow.ellipsis,
                      ),
                    )
                  ],
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return const CartScreen();
                  }));
                },
                child: Icon(
                  Icons.shopping_cart_outlined,
                  color: hexToColor('#999999'),
                  size: 35.sp,
                ),
              ),
              SizedBox(width: 22.w),
              GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const NotificationScreen()));
                    setState(() {
                      isNewNotification = false;
                    });
                  },
                  child: isNewNotification
                      ? Image.asset(
                          'assets/icons/new_notification_box.png',
                          height: 35.h,
                          width: 35.w,
                          fit: BoxFit.cover,
                        )
                      : Image.asset(
                          'assets/icons/no_new_notification_box.png',
                          height: 35.h,
                          width: 35.w,
                          fit: BoxFit.cover,
                        )),
              SizedBox(width: 22.w),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const MyProfileScreen()));
                },
                child: widget.currentUser.photoURL != null
                    ? CircleAvatar(
                        radius: 30.0,
                        backgroundImage:
                            NetworkImage(widget.currentUser.photoURL ?? ''),
                      )
                    : CircleAvatar(
                        radius: 30.0,
                        backgroundColor: Theme.of(context).primaryColor,
                        child: const Icon(Icons.person,
                            color: Colors.white, size: 30.0),
                      ),
              ),
            ],
          ),
        ),
        GestureDetector(
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const ExploreScreen()));
          },
          child: Container(
            margin: EdgeInsets.all(28.w),
            padding: EdgeInsets.all(12.w),
            width: 605.w,
            height: 95.h,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(50.r),
              border: Border.all(
                width: 1,
                color: hexToColor('#DDDDDD'),
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 35.w,
                  backgroundColor: hexToColor('#EEEEEE'),
                  child: CircleAvatar(
                    radius: 22.w,
                    backgroundColor: hexToColor('#DDDDDD'),
                    child: Icon(
                      Icons.search,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ),
                SizedBox(width: 30.w),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Search Products & Store',
                      style: TextStyle(
                        color: hexToColor('#6D6D6D'),
                        fontSize: 24.sp,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        'clothings, electronics, groceries & more...',
                        style: TextStyle(
                          color: hexToColor('#989898'),
                          fontFamily: 'Gotham',
                          fontSize: 14.sp,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        // Updates Section
        /*Container(
          height: 125.0,
          padding: EdgeInsets.only(left: 8.0),
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: updates.length,
            itemBuilder: (context, index) {
              return UpdateTile(
                  name: updates[index]["name"],
                  image: updates[index]["coverImage"]);
            },
          ),
        ),*/
        isUpdatesLoading
            ? Padding(
                padding: const EdgeInsets.only(left: 20),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children:
                        List.generate(4, (index) => updatesShimmerEffect()),
                  ),
                ),
              )
            : updates.isEmpty
                ? Container()
                : Container(
                    height: 110.0,
                    padding: const EdgeInsets.only(left: 8.0),
                    child: ListView(
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      children: groupedUpdates.entries.map((e) {
                        String storeName = e.key;
                        List<StoreUpdateModel> individualStoreUpdates = e.value;
                        int indexClicked = 0;

                        for (int i = 0; i < updates.length; i++) {
                          if (updates[i] == individualStoreUpdates[0]) {
                            indexClicked = i;
                          }
                        }
                        return UpdateTile(
                          name: storeName,
                          image: individualStoreUpdates[0].logoUrl,
                          index: indexClicked,
                          updates: updates,
                        );
                      }).toList(),
                    ),
                  ),
        const SizedBox(height: 10.0),
        SizedBox(
          height: 250.h,
          child: PageView(
            controller: PageController(viewportFraction: 1),
            children: [
              Image.asset('assets/store_profile_banner.png'),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 16.w),
                decoration: BoxDecoration(
                  color: hexToColor('#F5F5F5'),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Center(
                  child: Text('Second Page Content'),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 30.h),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: EdgeInsets.symmetric(horizontal: 12.w),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 12.w,
            mainAxisSpacing: 12.h,
            childAspectRatio: 3 / 4,
          ),
          itemCount: categories.length,
          itemBuilder: (context, index) {
            return CategoryTile(
              category: categories[index],
            );
          },
        ),
        SizedBox(height: 30.h),

        // Featured Section
        Padding(
          padding: EdgeInsets.only(left: 16.w),
          child: Wrap(
            children: List.generate(6, (index) {
              return Container(
                margin: EdgeInsets.symmetric(horizontal: 6.w),
                padding: EdgeInsets.symmetric(horizontal: 4.w),
                child: ChoiceChip(
                  label: Text(_getTabLabel(index)),
                  labelStyle: TextStyle(
                    fontSize: 19.sp,
                    color: _selectedIndex == index
                        ? Colors.white
                        : hexToColor("#343434"),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50.r),
                    side: BorderSide(
                      color: hexToColor('#343434'),
                    ),
                  ),
                  showCheckmark: false,
                  selected: _selectedIndex == index,
                  selectedColor: hexToColor('#343434'),
                  backgroundColor: Colors.white,
                  onSelected: (selected) {
                    setState(() {
                      _selectedIndex = index;
                      _tabController.index = index;
                    });
                  },
                ),
              );
            }),
          ),
        ),

        SizedBox(height: 50.h),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            'Featured Products',
            style: TextStyle(
              color: hexToColor('#343434'),
              fontSize: 35.sp,
            ),
          ),
        ),

        SizedBox(height: 30.h),

        Container(
          height: 340.h,
          padding: const EdgeInsets.only(left: 8.0),
          child: TabBarView(
            controller: _tabController,
            children: [
              ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: featuredProducts.length,
                itemBuilder: (context, index) {
                  return WishlistProductTile(
                    product: featuredProducts[index],
                  );
                },
              ),
              ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 5,
                itemBuilder: (context, index) {
                  return WishlistProductTile(
                    product: featuredProducts[index],
                  );
                },
              ),
              ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 5,
                itemBuilder: (context, index) {
                  return WishlistProductTile(
                    product: featuredProducts[index],
                  );
                },
              ),
              ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 5,
                itemBuilder: (context, index) {
                  return WishlistProductTile(
                    product: featuredProducts[index],
                  );
                },
              ),
              ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 5,
                itemBuilder: (context, index) {
                  return WishlistProductTile(
                    product: featuredProducts[index],
                  );
                },
              ),
              ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 5,
                itemBuilder: (context, index) {
                  return WishlistProductTile(
                    product: featuredProducts[index],
                  );
                },
              ),
            ],
          ),
        ),

        SizedBox(height: 30.h),

        Container(
          height: 350.h,
          child: CarouselSlider(
            options: CarouselOptions(
              height: 350.h,
              viewportFraction: 1.0,
              autoPlay: true,
              enlargeCenterPage: true,
            ),
            items: [
              Container(
                margin: EdgeInsets.symmetric(horizontal: 16.w),
                decoration: BoxDecoration(
                  color: hexToColor('#F5F5F5'),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Center(
                  child: Text('First Page Content'),
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 16.w),
                decoration: BoxDecoration(
                  color: hexToColor('#F5F5F5'),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Center(
                  child: Text('Second Page Content'),
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 16.w),
                decoration: BoxDecoration(
                  color: hexToColor('#F5F5F5'),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Center(
                  child: Text('Third Page Content'),
                ),
              ),
            ],
          ),
        ),

        SizedBox(height: 50.h),

        // Feature Store Section
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 18.w),
          child: Row(
            children: [
              Text(
                'Featured Stores',
                style: TextStyle(
                  color: hexToColor('#343434'),
                  fontSize: 35.sp,
                ),
              )
            ],
          ),
        ),
        SizedBox(height: 30.h),
        SizedBox(
          height: 200.h,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              ...featuredStores.map((store) {
                return StoreTile(
                  store: store,
                );
              }).toList(),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const StoresScreen()));
                },
                child: Container(
                  padding: EdgeInsets.all(18.w),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: 120.h,
                        width: 120.w,
                        decoration: BoxDecoration(
                          color: const Color(0xFFF5F5F5),
                          borderRadius: BorderRadius.circular(23.r),
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.arrow_forward_ios,
                            color: Color(0xFFB5B5B5),
                          ),
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        'View All',
                        style: TextStyle(fontSize: 16.sp),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),

        SizedBox(height: 50.h),

        Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Special Products',
                style: TextStyle(
                  color: hexToColor('#343434'),
                  fontSize: 35.sp,
                ),
              ),
              SizedBox(height: 30.h),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: EdgeInsets.symmetric(horizontal: 12.w),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12.w,
                  mainAxisSpacing: 12.h,
                  childAspectRatio: 0.8,
                ),
                itemCount: featuredProducts.length,
                itemBuilder: (context, index) {
                  return WishlistProductTile(
                    product: featuredProducts[index],
                  );
                },
              ),
            ],
          ),
        ),

        SizedBox(height: 200.h),
      ],
    );
  }

  Widget updatesShimmerEffect() {
    int rand = Random().nextInt(3);
    String text = rand == 1 ? "Loading..." : "Just a sec...";
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade400,
      child: Padding(
        padding: const EdgeInsets.all(2.0),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 12.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: size + 3.5,
                backgroundColor: Colors.green,
                child: CircleAvatar(
                  radius: size + 1.5,
                  backgroundColor: Colors.white,
                  child: CircleAvatar(
                    radius: size,
                  ),
                ),
              ),
              SizedBox(height: 12.h),
              Text(
                text,
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w600,
                  fontSize: 15.sp,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class StoreTile extends StatelessWidget {
  final StoreModel store;

  StoreTile({required this.store});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => StoreProfileScreen(
              store: store,
            ),
          ),
        );
      },
      child: Container(
        padding: EdgeInsets.all(18.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ClipRRect(
                borderRadius: BorderRadius.circular(23.r),
                child: Image.network(
                  store.logoUrl,
                  fit: BoxFit.fill,
                  height: 120.h,
                  width: 120.w,
                )),
            SizedBox(height: 8.h),
            Text(
              store.name,
              style: TextStyle(fontSize: 16.sp),
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

class CategoryTile extends StatelessWidget {
  Map<String, dynamic> category;

  CategoryTile({required this.category});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CategoryProductsScreen(
              categoryName: category['name'],
            ),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 175.h,
              width: 175.w,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20.r),
                  image: DecorationImage(
                    image: AssetImage(category['image']),
                    fit: BoxFit.cover,
                  )),
            ),
            SizedBox(height: 8.h),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                category['name'],
                style: TextStyle(
                  color: hexToColor('#343434'),
                  fontSize: 20.sp,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CategoryProductsScreen extends StatelessWidget {
  final String categoryName;

  const CategoryProductsScreen({Key? key, required this.categoryName})
      : super(key: key);

  Stream<QuerySnapshot> _getProductsStream() {
    if (categoryName.toLowerCase() == 'more') {
      return FirebaseFirestore.instance.collection('products').where(
          'productCategory',
          whereNotIn: ['SpecialCategory1', 'SpecialCategory2']).snapshots();
    } else {
      return FirebaseFirestore.instance
          .collection('products')
          .where('productCategory', isEqualTo: categoryName)
          .snapshots();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 100,
              padding: const EdgeInsets.fromLTRB(16, 0, 8, 0),
              child: Row(
                children: [
                  Text(
                    categoryName.toUpperCase(),
                    style: TextStyle(
                      color: hexToColor('#1E1E1E'),
                      fontWeight: FontWeight.w400,
                      fontSize: 24.0,
                      letterSpacing: 1.5,
                    ),
                  ),
                  Text(
                    ' •',
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 28.0,
                      color: hexToColor('#FAD524'),
                    ),
                  ),
                  const Spacer(),
                  Container(
                    margin: const EdgeInsets.all(8.0),
                    child: CircleAvatar(
                      backgroundColor: Colors.grey[100],
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back_ios_new,
                            color: Colors.black),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: _getProductsStream(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Center(
                        child: Text('No products found in this category'));
                  }

                  final products = snapshot.data!.docs;

                  return GridView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8,
                      childAspectRatio: 0.8,
                    ),
                    itemCount: products.length,
                    itemBuilder: (context, index) {
                      final product =
                          ProductModel.fromFirestore(products[index]);
                      return WishlistProductTile(product: product);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class UpdateTile extends StatelessWidget {
  final String name;
  final String image;
  final int index;
  final List<StoreUpdateModel> updates;

  const UpdateTile({
    super.key,
    required this.name,
    required this.image,
    required this.index,
    required this.updates,
  });

  final double size = 30;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => UpdateScreen(
              storeName: name,
              storeImage: Image(
                image: CachedNetworkImageProvider(updates[index].logoUrl),
              ),
              initialUpdateIndex: index,
              updates: updates,
            ),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.all(2.0).copyWith(top: 0),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 12.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: size + 3.5,
                backgroundColor: Colors.green,
                child: CircleAvatar(
                  radius: size + 1.5,
                  backgroundColor: Colors.white,
                  child: CircleAvatar(
                    backgroundImage: CachedNetworkImageProvider(image),
                    radius: size,
                  ),
                ),
              ),
              SizedBox(height: 12.h),
              Text(
                name,
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w600,
                  fontSize: 15.sp,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
