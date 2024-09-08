import 'dart:async';
import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import 'package:tnent/core/helpers/color_utils.dart';
import 'package:tnent/core/helpers/snackbar_utils.dart';
import 'package:tnent/models/product_model.dart';
import 'package:tnent/models/store_model.dart';
import 'package:tnent/models/store_update_model.dart';
import 'package:tnent/models/user_model.dart';
import 'package:tnent/presentation/pages/accept_reject_order_screen.dart';
import 'package:tnent/presentation/pages/catalog_pages/cart_screen.dart';
import 'package:tnent/presentation/pages/explore_screen.dart';
import 'package:tnent/presentation/pages/notification_screen.dart';
import 'package:tnent/presentation/pages/stores_screen.dart';
import 'package:tnent/presentation/pages/users_screens/myprofile_screen.dart';
import 'package:tnent/presentation/widgets/wishlist_product_tile.dart';
import '../update_screen.dart';
import '../users_screens/storeprofile_screen.dart';

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

  List<Map<String, dynamic>> categories = [
    {
      'name': 'Restaurant',
      'image': 'assets/categories2/restaurant.png',
    },
    {
      'name': 'Cafe',
      'image': 'assets/categories2/cafe.png',
    },
    {
      'name': 'Clothings',
      'image': 'assets/categories2/clothing.png',
    },
    {
      'name': 'Bakery',
      'image': 'assets/categories2/bakery.png',
    },
    {
      'name': 'Grocery',
      'image': 'assets/categories2/grocery.png',
    },
    {
      'name': 'Books',
      'image': 'assets/categories2/books.png',
    },
  ];

  List<StoreUpdateModel> updates = [];
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

  Stream<bool> _getNewNotificationsStream() {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return Stream.value(false);

    return Stream.periodic(const Duration(seconds: 2), (_) => null)
        .asyncMap((_) => _checkForNewNotifications(user.uid))
        .distinct();
  }

  Future<bool> _checkForNewNotifications(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    final lastCheckTime = prefs.getInt('lastNotificationCheck') ?? 0;

    final snapshot = await FirebaseFirestore.instance
        .collection('Users')
        .doc(userId)
        .collection('notifications')
        .where('createdAt',
            isGreaterThan: Timestamp.fromMillisecondsSinceEpoch(lastCheckTime))
        .get();

    final hasNewNotifications = snapshot.docs.isNotEmpty;

    if (hasNewNotifications) {
      // Update the last check time
      await prefs.setInt(
          'lastNotificationCheck', DateTime.now().millisecondsSinceEpoch);
    }

    return hasNewNotifications;
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
      final featuredStoreDoc = await FirebaseFirestore.instance
          .collection('Featured Stores')
          .doc('featured-stores')
          .get();

      final List<String> storeIds =
          List<String>.from(featuredStoreDoc['stores'] ?? []);

      if (storeIds.isNotEmpty) {
        final storesSnapshot = await FirebaseFirestore.instance
            .collection('Stores')
            .where(FieldPath.documentId, whereIn: storeIds)
            .get();

        setState(() {
          featuredStores = storesSnapshot.docs
              .map((doc) => StoreModel.fromFirestore(doc))
              .where((store) => store.isActive) // Filter active stores
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
      final featuredProductDoc = await FirebaseFirestore.instance
          .collection('Featured Products')
          .doc('featured-products')
          .get();

      final List<String> productIds =
          List<String>.from(featuredProductDoc['products'] ?? []);

      if (productIds.isNotEmpty) {
        List<ProductModel> products = [];

        for (String productId in productIds) {
          final productDoc = await FirebaseFirestore.instance
              .collection('products')
              .doc(productId)
              .get();

          if (productDoc.exists) {
            final product = ProductModel.fromFirestore(productDoc);

            // Check if the store is active
            final storeDoc = await FirebaseFirestore.instance
                .collection('Stores')
                .doc(product.storeId)
                .get();

            if (storeDoc.exists && storeDoc.data()?['isActive'] == true) {
              products.add(product);
            }
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

  Widget underWidget(String text) => Padding(
        padding:
            const EdgeInsets.symmetric(horizontal: 10).copyWith(bottom: 13),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Container(
            // width: 350 * (235 / 342),
            height: 350,
            color: Colors.grey,
            child: Center(
              child: Text(text),
            ),
          ),
        ),
      );

  final double size = 30.0;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
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
                  color: const Color.fromRGBO(179, 179, 179, 1),
                  size: 35.sp,
                ),
              ),
              SizedBox(width: 28.w),
              StreamBuilder<bool>(
                stream: _getNewNotificationsStream(),
                builder: (context, snapshot) {
                  bool hasNewNotifications = snapshot.data ?? false;
                  return GestureDetector(
                    onTap: () async {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  const NotificationScreen()));
                      // After returning from NotificationScreen, update the last check time
                      final prefs = await SharedPreferences.getInstance();
                      await prefs.setInt('lastNotificationCheck',
                          DateTime.now().millisecondsSinceEpoch);
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(1.5),
                      child: Image.asset(
                        hasNewNotifications
                            ? 'assets/icons/new_notification_box.png'
                            : 'assets/icons/no_new_notification_box.png',
                        height: 35.h,
                        width: 35.w,
                        fit: BoxFit.cover,
                      ),
                    ),
                  );
                },
              ),
              SizedBox(width: 28.w),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const MyProfileScreen()),
                  );
                },
                child: CircleAvatar(
                  radius: 25.0,
                  backgroundImage: widget.currentUser.photoURL != null
                      ? CachedNetworkImageProvider(
                          widget.currentUser.photoURL ?? ' ')
                      : null,
                  backgroundColor: Colors.transparent,
                  child: widget.currentUser.photoURL == null
                      ? Image.asset(
                          'assets/icons/profile_pic.png',
                          fit: BoxFit.cover,
                        )
                      : null,
                ),
              )
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
                SizedBox(width: 25.w),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Search Products & Store',
                      style: TextStyle(
                        color: hexToColor('#6D6D6D'),
                        fontSize: 21.sp,
                      ),
                    ),
                    Text(
                      'restaurants, cafes, bakeries, clothings & more...',
                      style: TextStyle(
                        color: hexToColor('#989898'),
                        fontFamily: 'Gotham',
                        fontSize: 12.sp,
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
        SizedBox(
          child: CarouselSlider(
            options: CarouselOptions(
              autoPlay: true,
              viewportFraction: 1.0,
              enlargeCenterPage: true,
            ),
            items: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Image.asset(
                  'assets/categories2/vbnm.png',
                  scale: 0.8,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Image.asset(
                  'assets/categories2/dfgn.png',
                  scale: 0.8,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Image.asset(
                  'assets/categories2/dfghj.png',
                  scale: 0.8,
                ),
              ),
            ],
          ),
        ),
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
            'Featured',
            style: TextStyle(
              color: hexToColor('#343434'),
              fontSize: 30.sp,
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

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: CarouselSlider(
            options: CarouselOptions(
              aspectRatio: 235 / 342,
              // height: 350,
              viewportFraction: 1,
              autoPlay: true,
              enableInfiniteScroll: false,
              enlargeCenterPage: false,
            ),
            items: List.generate(
              4,
              (index) => underWidget(index.toString()),
            ),
          ),
        ),

        SizedBox(height: 50.h),

        // Feature Store Section
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 18.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Featured Stores',
                style: TextStyle(
                  color: hexToColor('#343434'),
                  fontSize: 30.sp,
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const StoresScreen()));
                },
                child: CircleAvatar(
                  backgroundColor: hexToColor('#094446'),
                  radius: 13,
                  child: const Icon(
                    Icons.arrow_forward_ios_rounded,
                    color: Colors.white,
                    size: 15,
                  ),
                ),
              ),
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
              featuredStores.length > 10
                  ? GestureDetector(
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
                  : Container(),
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
                  fontSize: 30.sp,
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

  StoreTile({super.key, required this.store});

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

  CategoryTile({super.key, required this.category});

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
      return FirebaseFirestore.instance
          .collection('products')
          .where('productCategory', whereNotIn: [
        'Clothings',
        'Electronics',
        'Accessories',
        'Groceries',
        'Books'
      ]).snapshots();
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

                  return FutureBuilder<List<ProductModel>>(
                    future: _filterActiveStoreProducts(products),
                    builder: (context, activeProductsSnapshot) {
                      if (activeProductsSnapshot.connectionState ==
                          ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      if (activeProductsSnapshot.hasError) {
                        return Center(
                            child:
                                Text('Error: ${activeProductsSnapshot.error}'));
                      }

                      final activeProducts = activeProductsSnapshot.data ?? [];

                      if (activeProducts.isEmpty) {
                        return const Center(
                            child: Text(
                                'No active products found in this category'));
                      }

                      return GridView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 8,
                          mainAxisSpacing: 8,
                          childAspectRatio: 0.8,
                        ),
                        itemCount: activeProducts.length,
                        itemBuilder: (context, index) {
                          return WishlistProductTile(
                              product: activeProducts[index]);
                        },
                      );
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

  Future<List<ProductModel>> _filterActiveStoreProducts(
      List<QueryDocumentSnapshot> products) async {
    List<ProductModel> activeProducts = [];

    for (var doc in products) {
      final product = ProductModel.fromFirestore(doc);
      final storeDoc = await FirebaseFirestore.instance
          .collection('Stores')
          .doc(product.storeId)
          .get();

      if (storeDoc.exists && storeDoc.data()?['isActive'] == true) {
        activeProducts.add(product);
      }
    }

    return activeProducts;
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
              storeImage: CachedNetworkImage(
                imageUrl: updates[index].logoUrl,
                placeholder: (context, url) => CircularProgressIndicator(
                  color: hexToColor('#094446'),
                ),
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
                radius: size + 2.5,
                backgroundColor: hexToColor('#2D332F'),
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
