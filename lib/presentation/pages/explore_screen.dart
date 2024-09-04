import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tnent/core/helpers/color_utils.dart';
import 'package:tnent/models/product_model.dart';
import 'package:tnent/models/store_model.dart';
import 'package:tnent/presentation/pages/notification_screen.dart';
import 'package:tnent/presentation/pages/users_screens/storeprofile_screen.dart';
import 'package:tnent/presentation/widgets/wishlist_product_tile.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({Key? key}) : super(key: key);

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  int? _selectedFilterOption;
  final _searchController = TextEditingController();
  final _searchSubject = BehaviorSubject<String>();
  List<ProductModel> allProducts = [];
  List<StoreModel> allStores = [];
  List<ProductModel> filteredProducts = [];
  List<StoreModel> filteredStores = [];
  bool isLoading = false;
  bool isNewNotification = true;

  @override
  void initState() {
    super.initState();
    _setupSearchListener();
    _fetchProductsAndStores();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _fetchProductsAndStores();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchSubject.close();
    super.dispose();
  }

  void _setupSearchListener() {
    _searchSubject
        .debounceTime(const Duration(milliseconds: 300))
        .distinct()
        .listen((query) {
      _filterProductsAndStores(query);
    });
  }

  Future<void> _fetchProductsAndStores() async {
    setState(() {
      isLoading = true;
    });

    try {
      final productsQuery = FirebaseFirestore.instance.collection('products');
      final storesQuery = FirebaseFirestore.instance.collection('Stores');

      final productSnapshot = await productsQuery.get();
      final storeSnapshot = await storesQuery.get();

      allProducts = productSnapshot.docs
          .map((doc) => ProductModel.fromFirestore(doc))
          .toList();
      allStores = storeSnapshot.docs
          .map((doc) => StoreModel.fromFirestore(doc))
          .toList();

      setState(() {
        isLoading = false;
      });
    } catch (e) {
      print('Error fetching products and stores: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  void _filterProductsAndStores(String query) {
    if (query.isEmpty) {
      setState(() {
        filteredProducts = allProducts;
        filteredStores = allStores;
      });
      return;
    }

    final lowercaseQuery = query.toLowerCase();
    filteredProducts = allProducts.where((product) {
      return product.name.toLowerCase().contains(lowercaseQuery) ||
          product.description.toLowerCase().contains(lowercaseQuery);
    }).toList();

    filteredStores = allStores.where((store) {
      return store.name.toLowerCase().contains(lowercaseQuery);
    }).toList();

    setState(() {
      filteredProducts = filteredProducts;
      filteredStores = filteredStores;
    });
  }

  void _applyFilter() {
    if (_selectedFilterOption == null) return;

    setState(() {
      switch (_selectedFilterOption) {
        case 0: // Featured
          // Implement featured logic here
          break;
        case 1: // High to Low
          filteredProducts.sort((a, b) => b.variations.values.first.price
              .compareTo(a.variations.values.first.price));
          break;
        case 2: // Low to High
          filteredProducts.sort((a, b) => a.variations.values.first.price
              .compareTo(b.variations.values.first.price));
          break;
        case 3: // Discount
          filteredProducts.sort((a, b) => b.variations.values.first.discount
              .compareTo(a.variations.values.first.discount));
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            _buildSearchBox(),
            SizedBox(height: 30.h),
            _buildSearchInfo(),
            SizedBox(height: 30.h),
            _buildResultsList(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      height: 100.h,
      margin: EdgeInsets.only(top: 20.h, bottom: 20.h),
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Row(
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
          const Spacer(),
          _buildBackButton(),
        ],
      ),
    );
  }

  Widget _buildSearchBox() {
    return Container(
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
              controller: _searchController,
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
              onChanged: (value) => _searchSubject.add(value),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchInfo() {
    final bool hasResults =
        filteredProducts.isNotEmpty || filteredStores.isNotEmpty;
    final String query = _searchController.text;

    if (!hasResults || query.isEmpty) return const SizedBox.shrink();

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 26.w),
      child: Row(
        children: [
          SizedBox(
            width: 500.w,
            child: Text(
              'Showing ${filteredProducts.length + filteredStores.length} results for "$query"',
              style: TextStyle(
                color: hexToColor('#6D6D6D'),
                fontSize: 22.sp,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const Spacer(),
          _buildFilterButton(),
        ],
      ),
    );
  }

  Widget _buildResultsList() {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    final bool hasResults =
        filteredProducts.isNotEmpty || filteredStores.isNotEmpty;
    final String query = _searchController.text;

    if (!hasResults && query.isNotEmpty) {
      return Center(
        child: ClipRRect(
          child: Image.asset(
            'assets/no_results.png',
            height: 495.h,
            width: 445.w,
          ),
        ),
      );
    }

    return Expanded(
      child: CustomScrollView(
        slivers: [
          if (filteredStores.isNotEmpty) ...[
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.only(left: 20.w, top: 20.h, bottom: 20.h),
                child: Text(
                  'Stores',
                  style: TextStyle(fontSize: 28.sp),
                ),
              ),
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) => StoreTile(store: filteredStores[index]),
                childCount: filteredStores.length,
              ),
            ),
          ],
          if (filteredProducts.isNotEmpty) ...[
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.only(left: 20.w, top: 20.h, bottom: 20.h),
                child: Text(
                  'Products',
                  style: TextStyle(fontSize: 28.sp),
                ),
              ),
            ),
            SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
                childAspectRatio: 0.8,
              ),
              delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
                  return WishlistProductTile(product: filteredProducts[index]);
                },
                childCount: filteredProducts.length,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildNotificationIcon() {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const NotificationScreen()),
        );
        setState(() {
          isNewNotification = false;
        });
      },
      child: Image.asset(
        isNewNotification
            ? 'assets/icons/new_notification_box.png'
            : 'assets/icons/no_new_notification_box.png',
        height: 35.h,
        width: 35.w,
        fit: BoxFit.cover,
      ),
    );
  }

  Widget _buildBackButton() {
    return IconButton(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(Colors.grey[100]),
        shape: MaterialStateProperty.all(const CircleBorder()),
      ),
      icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
      onPressed: () => Navigator.pop(context),
    );
  }

  Widget _buildFilterButton() {
    return GestureDetector(
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
    );
  }

  Widget _buildBottomSheet() {
    return Container(
      padding: const EdgeInsets.all(20),
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
                style: TextStyle(fontSize: 24.sp),
              ),
              const Spacer(),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.pop(context),
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

  StoreTile({Key? key, required this.store}) : super(key: key);

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
