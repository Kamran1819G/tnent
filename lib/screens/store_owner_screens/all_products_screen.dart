import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:tnent/helpers/color_utils.dart';
import 'package:tnent/screens/product_detail_screen.dart';
import 'package:tnent/models/product_model.dart';

class AllProductsScreen extends StatefulWidget {
  final String storeId;

  const AllProductsScreen({Key? key, required this.storeId}) : super(key: key);

  @override
  State<AllProductsScreen> createState() => _AllProductsScreenState();
}

class _AllProductsScreenState extends State<AllProductsScreen> {
  late Stream<QuerySnapshot> _productsStream;
  List<ProductModel> selectedProducts = [];
  bool isSelectionMode = false;

  @override
  void initState() {
    super.initState();
    _productsStream = FirebaseFirestore.instance
        .collection('products')
        .where('storeId', isEqualTo: widget.storeId)
        .snapshots();
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
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    scaffoldMessenger.showSnackBar(
      const SnackBar(content: Text('Deleting products...'), duration: Duration(seconds: 30)),
    );

    try {
      final batch = FirebaseFirestore.instance.batch();
      final storeRef = FirebaseFirestore.instance.collection('Stores').doc(widget.storeId);

      for (ProductModel product in selectedProducts) {
        // Delete product document
        final productRef = FirebaseFirestore.instance.collection('products').doc(product.productId);
        batch.delete(productRef);

        // Decrease product total from store
        batch.update(storeRef, {'totalProducts': FieldValue.increment(-1)});

        // Remove from featured products if present
        batch.update(storeRef, {
          'featuredProductIds': FieldValue.arrayRemove([product.productId]),
        });

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
      }

      // Commit the batch
      await batch.commit();

      scaffoldMessenger.hideCurrentSnackBar();
      scaffoldMessenger.showSnackBar(
        const SnackBar(content: Text('Products deleted successfully')),
      );

      _toggleSelectionMode();
    } catch (e) {
      print('Error deleting products: $e');
      scaffoldMessenger.hideCurrentSnackBar();
      scaffoldMessenger.showSnackBar(
        const SnackBar(content: Text('Failed to delete products. Please try again.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            if (isSelectionMode) _buildSelectionBar(),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: _productsStream,
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return const Center(child: Text('Something went wrong'));
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Center(child: Text('No products found'));
                  }

                  List<ProductModel> products = snapshot.data!.docs
                      .map((doc) => ProductModel.fromFirestore(doc))
                      .toList();

                  return _buildProductGrid(products);
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      height: 100,
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
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
          const Spacer(),
          CircleAvatar(
            backgroundColor: Colors.grey[100],
            child: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSelectionBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        children: [
          Text(
            '${selectedProducts.length} selected',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const Spacer(),
          ElevatedButton(
            onPressed: _deleteSelectedProducts,
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete'),
          ),
          const SizedBox(width: 8.0),
          ElevatedButton(
            onPressed: _toggleSelectionMode,
            style: ElevatedButton.styleFrom(backgroundColor: Colors.grey),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  Widget _buildProductGrid(List<ProductModel> products) {
    return GridView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
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
          onTap: () => _handleProductTap(product),
          onLongPress: () => _handleProductLongPress(product),
        );
      },
    );
  }

  void _handleProductTap(ProductModel product) {
    if (isSelectionMode) {
      _toggleProductSelection(product);
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ProductDetailScreen(product: product),
        ),
      );
    }
  }

  void _handleProductLongPress(ProductModel product) {
    if (!isSelectionMode) {
      _toggleSelectionMode();
      _toggleProductSelection(product);
    }
  }
}

class ProductTile extends StatelessWidget {
  final ProductModel product;
  final bool isSelectionMode;
  final bool isSelected;
  final VoidCallback onTap;
  final VoidCallback onLongPress;

  const ProductTile({
    Key? key,
    required this.product,
    required this.isSelectionMode,
    required this.isSelected,
    required this.onTap,
    required this.onLongPress,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var firstVariation = product.variations.isNotEmpty ? product.variations.values.first : null;
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
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: product.imageUrls.isNotEmpty
                    ? CachedNetworkImage(
                  imageUrl: product.imageUrls[0],
                  fit: BoxFit.cover,
                  placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                )
                    : const Center(child: Icon(Icons.image_not_supported, size: 40, color: Colors.grey)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
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