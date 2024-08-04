import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tnent/helpers/color_utils.dart';
import 'package:tnent/models/product_model.dart';
import 'package:tnent/models/store_model.dart';
import 'package:tnent/screens/notification_screen.dart';
import 'package:tnent/screens/users_screens/storeprofile_screen.dart';
import 'package:tnent/widgets/wishlist_product_tile.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  int? _selectedFilterOption;
  String searchQuery = '';
  List<ProductModel> products = [];
  List<StoreModel> stores = [];
  bool isLoading = false;
  bool isNewNotification = true;

  @override
  void initState() {
    super.initState();
    _fetchProductsAndStores();
  }

  Future<void> _fetchProductsAndStores() async {
    setState(() {
      isLoading = true;
    });

    try {
      // Fetch all products and stores
      QuerySnapshot productSnapshot = await FirebaseFirestore.instance.collection('products').get();
      QuerySnapshot storeSnapshot = await FirebaseFirestore.instance.collection('Stores').get();

      // Convert to lists of models
      List<ProductModel> allProducts = productSnapshot.docs.map((doc) => ProductModel.fromFirestore(doc)).toList();
      List<StoreModel> allStores = storeSnapshot.docs.map((doc) => StoreModel.fromFirestore(doc)).toList();

      // Filter based on search query
      if (searchQuery.isNotEmpty) {
        String lowercaseQuery = searchQuery.toLowerCase();
        products = allProducts.where((product) => product.name.toLowerCase().contains(lowercaseQuery)).toList();
        stores = allStores.where((store) => store.name.toLowerCase().contains(lowercaseQuery)).toList();
      } else {
        products = allProducts;
        stores = allStores;
      }

      print('Stores: $stores');

      setState(() {
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('Error fetching products and stores: $e');
    }
  }

  void _filterProductsAndStores(String query) {
    setState(() {
      searchQuery = query;
    });
    _fetchProductsAndStores();
  }

  void _applyFilter() {
    List<ProductModel> tempProducts = products;
    if (_selectedFilterOption != null) {
      switch (_selectedFilterOption) {
        case 0:
          // Add logic for 'Featured'
          break;
        case 1:
          // High to Low
          tempProducts.sort((a, b) {
            double aPrice = a.variations.values.first.price;
            double bPrice = b.variations.values.first.price;
            return bPrice.compareTo(aPrice);
          });
          break;
        case 2:
          // Low to High
          tempProducts.sort((a, b) {
            double aPrice = a.variations.values.first.price;
            double bPrice = b.variations.values.first.price;
            return aPrice.compareTo(bPrice);
          });
          break;
        case 3:
          // Discount
          tempProducts.sort((a, b) {
            double aDiscount = a.variations.values.first.discount;
            double bDiscount = b.variations.values.first.discount;
            return bDiscount.compareTo(aDiscount);
          });
          break;
        default:
          break;
      }
    }
    setState(() {
      products = tempProducts;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Container(
              height: 100.h,
              margin: EdgeInsets.only(top: 20.h, bottom: 20.h),
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Row(
                children: [
                  Row(
                    children: [
                      Text(
                        'Explore'.toUpperCase(),
                        style: TextStyle(
                          color: hexToColor('#1E1E1E'),
                          fontSize: 35.sp,
                          letterSpacing: 1.5,
                        ),
                      ),
                      Text(
                        ' •',
                        style: TextStyle(
                          fontWeight: FontWeight.w900,
                          fontSize: 35.sp,
                          color: hexToColor('#FAD524'),
                        ),
                      ),
                    ],
                  ),
                  Spacer(),
                  Row(
                    children: [
                      GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => NotificationScreen()));
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
                      IconButton(
                        style: ButtonStyle(
                          backgroundColor: WidgetStateProperty.all(
                            Colors.grey[100],
                          ),
                          shape: WidgetStateProperty.all(
                            CircleBorder(),
                          ),
                        ),
                        icon: Icon(Icons.arrow_back_ios_new, color: Colors.black),
                        onPressed: () {
                            Navigator.pop(context);
                        },
                      ),
                    ],
                  )
                ],
              ),
            ),

            // Search Box
            Container(
              margin: EdgeInsets.symmetric(horizontal: 16.w),
              height: 95.h,
              width: 605.w,
              padding: EdgeInsets.all(12.w),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(50),
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
                  Expanded(
                    child: TextField(
                      style: TextStyle(
                        color: hexToColor('#6D6D6D'),
                        fontSize: 24.sp,
                      ),
                      decoration: InputDecoration(
                        hintText: 'Search Products & Store',
                        hintStyle: TextStyle(
                          color: hexToColor('#6D6D6D'),
                          fontSize: 24.sp,
                        ),
                        border: InputBorder.none,
                      ),
                      onSubmitted: (value) {
                        _filterProductsAndStores(value);
                      },
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 30.h),

            // Search Info & Filter
            if ((products.isNotEmpty || stores.isNotEmpty) &&
                searchQuery.isNotEmpty)
              Container(
                padding: EdgeInsets.symmetric(horizontal: 26.w),
                child: Row(
                  children: [
                    SizedBox(
                      width: 500.w,
                      child: Text(
                        'Showing ${products.length + stores.length} results for "$searchQuery"',
                        style: TextStyle(
                          color: hexToColor('#6D6D6D'),
                          fontSize: 22.sp,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Spacer(),
                    GestureDetector(
                      onTap: () {
                        showModalBottomSheet(
                          context: context,
                          builder: (context) => _buildBottomSheet(),
                        );
                      },
                      child: Container(
                        height: 55.h,
                        width: 55.w,
                        padding: EdgeInsets.all(10.w),
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          borderRadius: BorderRadius.circular(14.r),
                        ),
                        child: Image.asset(
                          'assets/icons/filter.png',
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            SizedBox(height: 30.h),

            // Products & Stores
            isLoading
                ? Center(child: CircularProgressIndicator())
                : (products.isNotEmpty || stores.isNotEmpty) &&
                        searchQuery.isNotEmpty
                    ? Expanded(
                        child: CustomScrollView(
                          slivers: [
                            if (stores.isNotEmpty) ...[
                              SliverToBoxAdapter(
                                child: Padding(
                                  padding: EdgeInsets.only(left: 20.w, top: 20.h, bottom: 20.h),
                                  child: Text(
                                    'Stores',
                                    style: TextStyle(
                                      fontSize: 28.sp,
                                    ),
                                  ),
                                ),
                              ),
                              SliverList(
                                delegate: SliverChildBuilderDelegate(
                                      (context, index) => StoreTile(store: stores[index]),
                                  childCount: stores.length,
                                ),
                              ),
                            ],
                            if (products.isNotEmpty) ...[
                              SliverToBoxAdapter(
                                child: Padding(
                                  padding: EdgeInsets.only(left: 20.w, top: 20.h, bottom: 20.h),
                                  child: Text(
                                    'Products',
                                    style: TextStyle(
                                      fontSize: 28.sp,
                                    ),
                                  ),
                                ),
                              ),
                              SliverGrid(
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                      crossAxisSpacing: 8,
                                      mainAxisSpacing: 8,
                                      childAspectRatio: 0.8,
                                ),
                                delegate: SliverChildBuilderDelegate(
                                  (BuildContext context, int index) {
                                    return WishlistProductTile(
                                        product: products[index]);
                                  },
                                  childCount: products.length,
                                ),
                              ),
                            ],
                          ],
                        ),
                      )
                    : products.isEmpty &&
                            stores.isEmpty &&
                            searchQuery.isNotEmpty
                        ? ClipRRect(
                            child: Image.asset(
                              'assets/no_results.png',
                              height: 495.h,
                              width: 445.w,
                            ),
                          )
                        : Container(),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomSheet() {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(18.r)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Text(
                'Sort & Filter',
                style: TextStyle(
                  fontSize: 24.sp,
                ),
              ),
              Spacer(),
              IconButton(
                icon: Icon(Icons.close),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
          SizedBox(height: 30.w),
          Column(
            children: [
              _buildFilterOption(0, 'Featured'),
              _buildFilterOption(1, 'Price: High to Low'),
              _buildFilterOption(2, 'Price: Low to High'),
              _buildFilterOption(3, 'Discount'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFilterOption(int index, String title) {
    return RadioListTile<int>(
      value: index,
      groupValue: _selectedFilterOption,
      onChanged: (int? value) {
        setState(() {
          _selectedFilterOption = value;
        });
        _applyFilter();
        Navigator.pop(context);
      },
      title: Text(
        title,
        style: TextStyle(
          fontSize: 22.sp,
          fontFamily: 'Gotham',
          fontWeight: FontWeight.w500,
          color: Theme.of(context).primaryColor,
        ),
      ),
      activeColor: Theme.of(context).primaryColor,
    );
  }
}

class StoreTile extends StatelessWidget {
  final StoreModel store;

  const StoreTile({Key? key, required this.store}) : super(key: key);

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
        width: 600.w,
        margin: EdgeInsets.only(left: 33.w, bottom: 20.h),
        child: Row(
          children: [
            Container(
              height: 90.h,
              width: 90.w,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18.r),
                image: DecorationImage(
                  image: NetworkImage(store.logoUrl),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(width: 20.w),
            Text(
              store.name,
              style: TextStyle(
                fontSize: 30.sp,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
