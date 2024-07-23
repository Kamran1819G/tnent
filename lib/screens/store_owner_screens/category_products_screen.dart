import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tnennt/widgets/removable_product_tile.dart';
import 'package:tnennt/helpers/color_utils.dart';
import 'package:tnennt/models/category_model.dart';
import 'package:tnennt/models/product_model.dart';
import 'package:tnennt/helpers/text_utils.dart';

class CategoryProductsScreen extends StatefulWidget {
  final CategoryModel category;
  final String storeId;

  CategoryProductsScreen({required this.category, required this.storeId});

  @override
  State<CategoryProductsScreen> createState() => _CategoryProductsScreenState();
}

class _CategoryProductsScreenState extends State<CategoryProductsScreen> {
  late Future<List<ProductModel>> _productsFuture;

  @override
  void initState() {
    super.initState();
    _productsFuture = _fetchProducts();
  }

  Future<List<ProductModel>> _fetchProducts() async {
    try {
      final storeDoc = await FirebaseFirestore.instance
          .collection('Stores')
          .doc(widget.storeId)
          .collection('categories')
          .doc(widget.category.id)
          .get();

      if (!storeDoc.exists) {
        print('Store document does not exist');
        return [];
      }

      final data = storeDoc.data();
      if (data == null || !data.containsKey('productIds')) {
        print('productIds field is missing in the document');
        return [];
      }

      final productIds = (data['productIds'] as List<dynamic>?)
          ?.map((dynamic item) => item.toString())
          .toList() ?? [];

      print('Product IDs: $productIds');

      final productDocs = await Future.wait(productIds.map((productId) =>
          FirebaseFirestore.instance.collection('products').doc(productId).get()));

      final products = productDocs
          .where((doc) => doc.exists)
          .map((doc) {
        try {
          return ProductModel.fromFirestore(doc);
        } catch (e, stackTrace) {
          print('Error creating ProductModel from document ${doc.id}: $e');
          print('Stack trace: $stackTrace');
          print('Document data: ${doc.data()}');
          return null;
        }
      })
          .where((product) => product != null)
          .cast<ProductModel>()
          .toList();

      print('Fetched ${products.length} products');
      return products;
    } catch (e, stackTrace) {
      print('Error in _fetchProducts: $e');
      print('Stack trace: $stackTrace');
      return [];
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
            SizedBox(height: 10),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                widget.category.name.capitalize(),
                style: TextStyle(
                  color: hexToColor('#343434'),
                  fontSize: 18.0,
                ),
              ),
            ),
            SizedBox(height: 30),
            Expanded(
              child: FutureBuilder<List<ProductModel>>(
                future: _productsFuture,
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    print(snapshot.error);
                    return Center(child: Text('Something went wrong'));
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }

                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(child: Text('No products found'));
                  }

                  List<ProductModel> products = snapshot.data!;

                  return GridView.builder(
                    shrinkWrap: true,
                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8,
                    ),
                    itemCount: products.length,
                    itemBuilder: (context, index) {
                      final product = products[index];
                      return RemovableProductTile(
                        product: product,
                        onRemove: () {
                          // Remove product from category
                          setState(() {
                            widget.category.productIds.removeWhere((element) => element == product.productId);
                          });
                        },
                      );
                    },
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
