import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tnent/helpers/color_utils.dart';
import 'package:tnent/screens/product_detail_screen.dart';
import 'package:tnent/models/product_model.dart'; // Ensure you have this model

class AllProductsScreen extends StatefulWidget {
  final String storeId;

  AllProductsScreen({required this.storeId});

  @override
  State<AllProductsScreen> createState() => _AllProductsScreenState();
}

class _AllProductsScreenState extends State<AllProductsScreen> {
  late Future<List<ProductModel>> _productsFuture;
  List<ProductModel> selectedProducts = [];
  bool isSelectionMode = false;

  @override
  void initState() {
    super.initState();
    _productsFuture = _fetchProducts();
  }

  Future<List<ProductModel>> _fetchProducts() async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('products')
        .where('storeId', isEqualTo: widget.storeId)
        .get();

    return querySnapshot.docs
        .map((doc) => ProductModel.fromFirestore(doc))
        .toList();
  }

  Future<void> _deleteProduct(ProductModel product) async {
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    scaffoldMessenger.showSnackBar(
      SnackBar(
          content: Text('Deleting product...'),
          duration: Duration(seconds: 30)),
    );

    try {
      // Start a batch write
      final batch = FirebaseFirestore.instance.batch();

      // Delete product document
      final productRef = FirebaseFirestore.instance
          .collection('products')
          .doc(product.productId);
      batch.delete(productRef);

      // Decrease product total from store
      final storeRef =
          FirebaseFirestore.instance.collection('Stores').doc(widget.storeId);
      batch.update(storeRef, {'totalProducts': FieldValue.increment(-1)});

      // Check if product is in featured products array and remove it
      final storeDoc = await storeRef.get();
      final storeData = storeDoc.data();
      if (storeData != null &&
          storeData['featuredProductIds'].contains(product.productId)) {
        batch.update(storeRef, {
          'featuredProductIds': FieldValue.arrayRemove([product.productId]),
        });
      }

      // Remove product reference from category
      final categoryQuerySnapshot = await FirebaseFirestore.instance
          .collection('Stores')
          .doc(widget.storeId)
          .collection('categories')
          .where('name', isEqualTo: product.storeCategory)
          .get();

      if (categoryQuerySnapshot.docs.isNotEmpty) {
        final categoryDoc = categoryQuerySnapshot.docs.first;
        batch.update(categoryDoc.reference, {
          'productIds': FieldValue.arrayRemove([product.productId]),
          'totalProducts': FieldValue.increment(-1),
        });
      }

      // Commit the batch
      await batch.commit();

      // Refresh the product list
      setState(() {
        _productsFuture = _fetchProducts();
      });

      scaffoldMessenger.hideCurrentSnackBar();
      scaffoldMessenger.showSnackBar(
        SnackBar(content: Text('Product deleted successfully')),
      );
    } catch (e) {
      print('Error deleting product: $e');
      scaffoldMessenger.hideCurrentSnackBar();
      scaffoldMessenger.showSnackBar(
        SnackBar(content: Text('Failed to delete product. Please try again.')),
      );
    }
  }

  void _toggleSelectionMode() {
    setState(() {
      isSelectionMode = !isSelectionMode;
      if (!isSelectionMode) {
        selectedProducts.clear();
      }
    });
  }

  void _toggleProductSelection(ProductModel product) {
    setState(() {
      if (selectedProducts.contains(product)) {
        selectedProducts.remove(product);
      } else {
        selectedProducts.add(product);
      }
    });
  }

  Future<void> _deleteSelectedProducts() async {
    for (ProductModel product in selectedProducts) {
      await _deleteProduct(product);
    }
    _toggleSelectionMode();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(children: [
          Container(
            height: 100,
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                Row(
                  children: [
                    Text(
                      'All Products'.toUpperCase(),
                      style: TextStyle(
                        color: hexToColor('#1E1E1E'),
                        fontSize: 24.0,
                        letterSpacing: 1.5,
                      ),
                    ),
                    Text(
                      ' •',
                      style: TextStyle(
                        fontSize: 28.0,
                        color: hexToColor('#FF0000'),
                      ),
                    ),
                  ],
                ),
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
          if (isSelectionMode) ...[
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  Text(
                    '${selectedProducts.length} selected',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Spacer(),
                  TextButton(
                    onPressed: _deleteSelectedProducts,
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.red),
                      foregroundColor: MaterialStateProperty.all(Colors.white),
                    ),
                    child: Text('Delete'),
                  ),
                  const SizedBox(width: 8.0),
                  TextButton(
                    onPressed: _toggleSelectionMode,
                    child: Text('Cancel'),
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.grey),
                      foregroundColor: MaterialStateProperty.all(Colors.white),
                    ),
                  ),
                ],
              ),
            ),
           const SizedBox(height: 8.0),
          ],
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
                  padding: EdgeInsets.symmetric(horizontal: 8.0),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                    childAspectRatio: 0.8,
                  ),
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    final product = products[index];
                    return ProductTile(
                      product: product,
                      isSelectionMode: isSelectionMode,
                      isSelected: selectedProducts.contains(product),
                      onTap: () {
                        if (isSelectionMode) {
                          _toggleProductSelection(product);
                        } else {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  ProductDetailScreen(product: product),
                            ),
                          );
                        }
                      },
                      onLongPress: () {
                        if (!isSelectionMode) {
                          _toggleSelectionMode();
                          _toggleProductSelection(product);
                        }
                      },
                    );
                  },
                );
              },
            ),
          )
        ]),
      ),
    );
  }
}

class ProductTile extends StatelessWidget {
  final ProductModel product;
  final bool isSelectionMode;
  final bool isSelected;
  final VoidCallback onTap;
  final VoidCallback onLongPress;

  ProductTile({
    required this.product,
    required this.isSelectionMode,
    required this.isSelected,
    required this.onTap,
    required this.onLongPress,
  });

  ProductVariant? _getFirstVariation() {
    if (product.variations.isNotEmpty) {
      return product.variations.values.first;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    var firstVariation = _getFirstVariation();
    var price = firstVariation?.price ?? 0.0;

    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6.0),
          color: hexToColor('#F5F5F5'),
          border: isSelected ? Border.all(color: Colors.blue, width: 2) : null,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                  image: product.imageUrls.isNotEmpty
                      ? DecorationImage(
                          image: NetworkImage(product.imageUrls[0]),
                          fit: BoxFit.cover,
                        )
                      : null,
                ),
                child: product.imageUrls.isEmpty
                    ? Center(
                        child: Icon(Icons.image_not_supported,
                            size: 40, color: Colors.grey))
                    : null,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4),
                  Text(
                    '\$${price.toStringAsFixed(2)}',
                    style: TextStyle(fontSize: 10, color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
