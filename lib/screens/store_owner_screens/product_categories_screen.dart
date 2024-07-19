import 'dart:math';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tnennt/helpers/color_utils.dart';
import 'package:tnennt/models/category_model.dart';
import 'package:tnennt/screens/store_owner_screens/add_product_screen.dart';
import 'package:tnennt/screens/store_owner_screens/all_products_screen.dart';
import 'package:tnennt/screens/store_owner_screens/category_products_screen.dart';

class ProductCategoriesScreen extends StatefulWidget {
  const ProductCategoriesScreen({Key? key}) : super(key: key);

  @override
  State<ProductCategoriesScreen> createState() => _ProductCategoriesScreenState();
}

class _ProductCategoriesScreenState extends State<ProductCategoriesScreen> {
  TextEditingController _newCategoryController = TextEditingController();
  List<CategoryModel> categories = [];
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    QuerySnapshot querySnapshot = await _firestore.collection('categories').get();
    List<CategoryModel> loadedCategories = querySnapshot.docs
        .map((doc) => CategoryModel.fromFirestore(doc))
        .toList();

    for (var category in loadedCategories) {
      await _updateCategoryItemCount(category);
    }

    setState(() {
      categories = loadedCategories;
    });
  }

  Future<void> _updateCategoryItemCount(CategoryModel category) async {
    QuerySnapshot productsSnapshot = await _firestore
        .collection('Products')
        .where('category', isEqualTo: category.name)
        .get();

    int itemCount = productsSnapshot.docs.length;

    await _firestore.collection('categories').doc(category.id).update({'itemCount': itemCount});

    category.itemCount = itemCount;
  }

  Future<void> _addCategory(String name) async {
    DocumentReference docRef = await _firestore.collection('categories').add({
      'name': name,
      'itemCount': 0,
      'createdAt': FieldValue.serverTimestamp(),
    });

    CategoryModel newCategory = CategoryModel(id: docRef.id, name: name, itemCount: 0, coverImage: '', products: [], );
    await _updateCategoryItemCount(newCategory);

    setState(() {
      categories.add(newCategory);
    });
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
            SizedBox(height: 20),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 300,
                    child: Text(
                      'Choose Your Personalized Category',
                      style: TextStyle(fontSize: 24, color: Colors.black),
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Create dedicated sections for your product list add items to their respective slot.',
                    style: TextStyle(
                      fontSize: 14,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w500,
                      color: hexToColor('#636363'),
                    ),
                  ),
                  SizedBox(height: 30),
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
                      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: Text(
                        'View All Products',
                        style: TextStyle(
                            fontSize: 12,
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
            SizedBox(height: 40),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'New Categories:',
                    style: TextStyle(
                      fontSize: 16,
                      color: hexToColor('#545454'),
                    ),
                  ),
                  SizedBox(height: 10),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: hexToColor('#848484'),
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          margin: EdgeInsets.only(left: 8),
                          padding: EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: hexToColor('#2D332F'),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            Icons.add,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                        Expanded(
                          child: TextField(
                            controller: _newCategoryController,
                            style: TextStyle(
                                color: Colors.black,
                                fontFamily: 'Gotham',
                                fontWeight: FontWeight.w700,
                                fontSize: 14.0),
                            decoration: InputDecoration(
                              hintText: 'Create Your New Category',
                              hintTextDirection: TextDirection.ltr,
                              hintStyle: TextStyle(
                                color: hexToColor('#A1A1A1'),
                                fontSize: 14,
                                fontFamily: 'Gotham',
                                fontWeight: FontWeight.w700,
                              ),
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 20,
                              ),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            if (_newCategoryController.text.isNotEmpty) {
                              _addCategory(_newCategoryController.text);
                              _newCategoryController.clear();
                            }
                          },
                          child: Container(
                            margin: EdgeInsets.only(right: 8),
                            padding: EdgeInsets.all(12),
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
            SizedBox(height: 40),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Created Categories:',
                style: TextStyle(
                  fontSize: 16,
                  color: hexToColor('#545454'),
                ),
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: GridView.builder(
                shrinkWrap: true,
                padding: EdgeInsets.symmetric(horizontal: 16),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 14,
                  mainAxisSpacing: 14,
                  childAspectRatio: 1.1,
                ),
                itemCount: categories.length,
                itemBuilder: (context, index) => CategoryTile(
                  category: categories[index],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CategoryTile extends StatelessWidget {
  final CategoryModel category;
  final Color color;

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
  }) : color = colorList[Random().nextInt(colorList.length)];

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CategoryProductsScreen(category: category),
          ),
        );
      },
      child: Container(
        height: 100,
        width: 125,
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              category.name.toUpperCase(),
              style: TextStyle(
                color: Colors.black,
                fontSize: 12.0,
              ),
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: 8.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      category.itemCount.toString(),
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18.0,
                      ),
                    ),
                    Text(
                      'Items'.toUpperCase(),
                      style: TextStyle(
                        color: Colors.grey[700],
                        fontSize: 10.0,
                      ),
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AddProductScreen(category: category.name),
                      ),
                    );
                  },
                  child: Container(
                    margin: EdgeInsets.only(left: 10.0),
                    padding: EdgeInsets.all(6.0),
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.circular(6.0),
                    ),
                    child: Icon(
                      Icons.add,
                      color: Colors.white,
                      size: 14.0,
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