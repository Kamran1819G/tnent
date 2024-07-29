import 'dart:ffi';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tnennt/helpers/color_utils.dart';
import 'package:tnennt/models/store_category_model.dart';
import 'package:tnennt/screens/store_owner_screens/add_product_screen.dart';
import 'package:tnennt/screens/store_owner_screens/all_products_screen.dart';
import 'package:tnennt/screens/store_owner_screens/category_products_screen.dart';

class ProductCategoriesScreen extends StatefulWidget {
  final String storeId;

  ProductCategoriesScreen({required this.storeId});

  @override
  State<ProductCategoriesScreen> createState() => _ProductCategoriesScreenState();
}

class _ProductCategoriesScreenState extends State<ProductCategoriesScreen> {
  TextEditingController _newCategoryController = TextEditingController();
  List<StoreCategoryModel> categories = [];
  List<StoreCategoryModel> selectedCategories = [];
  bool isSelectionMode = false;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    QuerySnapshot querySnapshot = await _firestore
        .collection('Stores')
        .doc(widget.storeId)
        .collection('categories')
        .get();

    List<StoreCategoryModel> loadedCategories = querySnapshot.docs
        .map((doc) => StoreCategoryModel.fromFirestore(doc))
        .toList();

    setState(() {
      categories = loadedCategories;
    });
  }

  Future<void> _addNewCategory(String name) async {
    DocumentReference docRef = await _firestore
        .collection('Stores')
        .doc(widget.storeId)
        .collection('categories')
        .add({
      'name': name,
      'totalProduct': 0,
      'productIds': [],
      'createdAt': FieldValue.serverTimestamp(),
    });

    StoreCategoryModel newCategory = StoreCategoryModel(
      id: docRef.id,
      name: name,
      totalProducts: 0,
      productIds: [],
    );

    setState(() {
      categories.add(newCategory);
    });
  }

  Future<void> _refreshCategories() async {
    await _loadCategories();
  }

  void _toggleSelectionMode() {
    setState(() {
      isSelectionMode = !isSelectionMode;
      if (!isSelectionMode) {
        selectedCategories.clear();
      }
    });
  }

  void _toggleCategorySelection(StoreCategoryModel category) {
    setState(() {
      if (selectedCategories.contains(category)) {
        selectedCategories.remove(category);
      } else {
        selectedCategories.add(category);
      }
    });
  }

  Future<void> _deleteSelectedCategories() async {
    try {
      for (StoreCategoryModel category in selectedCategories) {
        // Delete category document
        await _firestore
            .collection('Stores')
            .doc(widget.storeId)
            .collection('categories')
            .doc(category.id)
            .delete();

        // Remove category from products
        QuerySnapshot productsSnapshot = await _firestore
            .collection('products')
            .where('storeId', isEqualTo: widget.storeId)
            .where('storeCategory', isEqualTo: category.id)
            .get();

        WriteBatch batch = _firestore.batch();
        for (DocumentSnapshot doc in productsSnapshot.docs) {
          batch.update(doc.reference, {'storeCategory': ''});
        }
        await batch.commit();
      }

      // Refresh the category list
      await _refreshCategories();
      _toggleSelectionMode();
    } catch (e) {
      print('Error deleting categories: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete categories. Please try again.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: _refreshCategories,
        child: SafeArea(
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 100,
                      padding: EdgeInsets.only(left: 16, right: 8),
                      child: Row(
                        children: [
                          Image.asset('assets/black_tnennt_logo.png', width: 30, height: 30),
                          Spacer(),
                          Container(
                            margin: EdgeInsets.all(8.0),
                            child: CircleAvatar(
                              backgroundColor: Colors.grey[100],
                              child: IconButton(
                                icon: Icon(Icons.arrow_back_ios_new, color: Colors.black),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 30.h),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 24.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: 400.w,
                            child: Text(
                              'Choose Your Personalized Category',
                              style: TextStyle(fontSize: 32.sp, color: Colors.black),
                            ),
                          ),
                          SizedBox(height: 12.h),
                          Text(
                            'Create dedicated sections for your product list add items to their respective slot.',
                            style: TextStyle(
                              fontSize: 20.sp,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w500,
                              color: hexToColor('#636363'),
                            ),
                          ),
                          SizedBox(height: 40.h),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => AllProductsScreen(storeId: widget.storeId),
                                ),
                              );
                            },
                            child: Container(
                              height: 70.h,
                              width: 240.w,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: Theme.of(context).primaryColor,
                                borderRadius: BorderRadius.circular(100),
                              ),
                              child: Text(
                                'View All Products',
                                style: TextStyle(
                                    fontSize: 16.sp,
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w500,
                                    color: hexToColor('#FFFFFF')),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 50.h),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 24.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'New Categories:',
                            style: TextStyle(
                              fontSize: 20.sp,
                              color: hexToColor('#545454'),
                            ),
                          ),
                          SizedBox(height: 12.h),
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: hexToColor('#848484'),
                              ),
                              borderRadius: BorderRadius.circular(20.r),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  margin: EdgeInsets.only(left: 8),
                                  padding: EdgeInsets.all(12.w),
                                  decoration: BoxDecoration(
                                    color: hexToColor('#2D332F'),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Icon(
                                    Icons.add,
                                    color: Colors.white,
                                    size: 22.sp,
                                  ),
                                ),
                                Expanded(
                                  child: TextField(
                                    controller: _newCategoryController,
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontFamily: 'Gotham',
                                        fontWeight: FontWeight.w700,
                                        fontSize: 20.sp),
                                    decoration: InputDecoration(
                                      hintText: 'Create Your New Category',
                                      hintTextDirection: TextDirection.ltr,
                                      hintStyle: TextStyle(
                                        color: hexToColor('#A1A1A1'),
                                        fontSize: 20.sp,
                                        fontFamily: 'Gotham',
                                        fontWeight: FontWeight.w700,
                                      ),
                                      border: InputBorder.none,
                                      contentPadding: EdgeInsets.symmetric(
                                        horizontal: 30.w,
                                        vertical: 30.h,
                                      ),
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    if (_newCategoryController.text.isNotEmpty) {
                                      _addNewCategory(_newCategoryController.text);
                                      _newCategoryController.clear();
                                    }
                                  },
                                  child: Container(
                                    margin: EdgeInsets.only(right: 12.w),
                                    padding: EdgeInsets.all(18.w),
                                    decoration: BoxDecoration(
                                      color: Theme.of(context).primaryColor,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Icon(
                                      Icons.arrow_forward,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(height: 50.h),
                    if (isSelectionMode)
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          children: [
                            Text(
                              '${selectedCategories.length} selected',
                              style: TextStyle(
                                fontSize: 24.sp,
                                color: Colors.black,
                              ),
                            ),
                            Spacer(),
                            TextButton(
                              onPressed: _deleteSelectedCategories,
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(Colors.red),
                                foregroundColor: MaterialStateProperty.all(Colors.white),
                              ),
                              child: Text('Delete'),
                            ),
                            SizedBox(width: 12.w),
                            TextButton(
                              onPressed: _toggleSelectionMode,
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(Colors.grey),
                                foregroundColor: MaterialStateProperty.all(Colors.white),
                              ),
                              child: Text('Cancel'),
                            ),
                          ],
                        ),
                      ),
                    SizedBox(height: 10.h),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        'Created Categories:',
                        style: TextStyle(
                          fontSize: 20.sp,
                          color: hexToColor('#545454'),
                        ),
                      ),
                    ),
                    SizedBox(height: 30.h),
                  ],
                ),
              ),
              SliverPadding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                sliver: SliverGrid(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 14,
                    mainAxisSpacing: 14,
                    childAspectRatio: 1.1,
                  ),
                  delegate: SliverChildBuilderDelegate(
                        (context, index) => CategoryTile(
                      category: categories[index],
                      storeId: widget.storeId,
                      isSelectionMode: isSelectionMode,
                      isSelected: selectedCategories.contains(categories[index]),
                      onTap: () {
                        if (isSelectionMode) {
                          _toggleCategorySelection(categories[index]);
                        } else {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CategoryProductsScreen(
                                category: categories[index],
                                storeId: widget.storeId,
                              ),
                            ),
                          );
                        }
                      },
                      onLongPress: () {
                        if (!isSelectionMode) {
                          _toggleSelectionMode();
                          _toggleCategorySelection(categories[index]);
                        }
                      },
                    ),
                    childCount: categories.length,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CategoryTile extends StatelessWidget {
  final StoreCategoryModel category;
  final String storeId;
  final Color color;
  final bool isSelectionMode;
  final bool isSelected;
  final VoidCallback onTap;
  final VoidCallback onLongPress;

  static final List<Color> colorList = [
    Color(0xFFDDF1EF),
    Color(0xFFFFF0E6),
    Color(0xFFE6F3FF),
    Color(0xFFF0E6FF),
    Color(0xFFE6FFEA),
    Color(0xFFFFE6E6),
  ];

  CategoryTile({
    required this.category,
    required this.storeId,
    required this.isSelectionMode,
    required this.isSelected,
    required this.onTap,
    required this.onLongPress,
  }) : color = colorList[Random().nextInt(colorList.length)];

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Container(
        height: 155.h,
        width: 200.w,
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(18.r),
          border: isSelected ? Border.all(color: Colors.blue, width: 2) : null,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              category.name.toUpperCase(),
              style: TextStyle(
                color: Colors.black,
                fontSize: 16.sp,
              ),
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: 10.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      category.totalProducts.toString(),
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 32.sp,
                      ),
                    ),
                    Text(
                      'Items'.toUpperCase(),
                      style: TextStyle(
                        color: Colors.grey[700],
                        fontSize: 16.sp,
                      ),
                    ),
                  ],
                ),
                if (!isSelectionMode)
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AddProductScreen(category: category, storeId: storeId),
                        ),
                      );
                    },
                    child: Container(
                      margin: EdgeInsets.only(left: 12.w),
                      padding: EdgeInsets.all(8.w),
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Icon(
                        Icons.add,
                        color: Colors.white,
                        size: 20.sp,
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}