import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
                      crossAxisCount: 3,
                      crossAxisSpacing: 8.0,
                      mainAxisSpacing: 16.0,
                      childAspectRatio: 0.7,
                    ),
                    itemCount: products.length,
                    itemBuilder: (context, index) {
                      final product = products[index];
                      return GestureDetector(
                        onTap: () {
                         /* Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ProductDetailScreen(

                              ),
                            ),
                          );*/
                        },
                        child: ProductTile(
                          product: product,
                          onRemove: () {
                            // Remove product from category
                            setState(() {
                              widget.category.productIds.removeWhere((element) => element == product.productId);
                            });
                          },
                        ),
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

class ProductTile extends StatefulWidget {
  ProductModel product;
  final double width;
  final double height;
  final Function onRemove;

  ProductTile({
    required this.product,
    this.width = 150.0,
    this.height = 200.0,
    required this.onRemove,
  });

  @override
  _ProductTileState createState() => _ProductTileState();
}

class _ProductTileState extends State<ProductTile> {
  void _removeProduct() {
    widget.onRemove();
  }


  ProductVariant? _getFirstVariation() {
    if (widget.product.variations.isNotEmpty) {
      var firstType = widget.product.variations.keys.first;
      if (widget.product.variations[firstType]?.isNotEmpty ?? false) {
        return widget.product.variations[firstType]?.values.first;
      }
    }
    return null;
  }
  @override
  Widget build(BuildContext context) {
    var firstVariation = _getFirstVariation();
    var price = firstVariation?.price ?? 0.0;
    var mrp = firstVariation?.mrp ?? 0.0;
    var discount = firstVariation?.discount ?? 0.0;

    return Container(
      height: 200,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6.0),
        color: hexToColor('#F5F5F5'),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                    image: DecorationImage(
                      image: NetworkImage(widget.product.imageUrls[0]),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Positioned(
                  right: 8.0,
                  top: 8.0,
                  child: GestureDetector(
                    onTap: _removeProduct,
                    child: Container(
                      padding: EdgeInsets.all(6.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(100.0),
                      ),
                      child: Icon(
                        Icons.remove,
                        color: Colors.red,
                        size: 16.0,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 8.0),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.product.name,
                  style: TextStyle(
                    color: hexToColor('#343434'),
                    fontSize: 10.0,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 4.0),
                Text(
                  '\$${price.toStringAsFixed(2)}',
                  style: TextStyle(
                    color: hexToColor('#343434'),
                    fontSize: 10.0,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
