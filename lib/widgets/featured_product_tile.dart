import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tnennt/models/product_model.dart';
import 'package:tnennt/screens/product_detail_screen.dart';
import '../helpers/color_utils.dart';

class FeaturedProductTile extends StatefulWidget {
  final ProductModel product;
  final double width;
  final double height;

  FeaturedProductTile({
    required this.product,
    this.width = 150.0,
    this.height = 200.0,
  });

  @override
  _FeaturedProductTileState createState() => _FeaturedProductTileState();
}

class _FeaturedProductTileState extends State<FeaturedProductTile> {
  bool _isFeatured = false;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    _checkFeaturedStatus();
  }

  void _checkFeaturedStatus() async {
    DocumentSnapshot storeDoc = await _firestore.collection('Stores').doc(widget.product.storeId).get();
    if (storeDoc.exists) {
      List<dynamic> featuredProducts = (storeDoc.data() as Map<String, dynamic>)['featuredProductIds'] ?? [];
      setState(() {
        _isFeatured = featuredProducts.contains(widget.product.productId);
      });
    }
  }

  Future<void> _toggleFeatured() async {
    DocumentReference storeDocRef = _firestore.collection('Stores').doc(widget.product.storeId);

    try {
      if (!_isFeatured) {
        // Check the current number of featured products
        DocumentSnapshot storeDoc = await storeDocRef.get();
        List<dynamic> featuredProducts = (storeDoc.data() as Map<String, dynamic>)['featuredProductIds'] ?? [];

        if (featuredProducts.length >= 5) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Maximum 5 featured products allowed')),
          );
          return;
        }
      }

      setState(() {
        _isFeatured = !_isFeatured;
      });

      if (_isFeatured) {
        // Add product to featured list
        await storeDocRef.update({
          'featuredProductIds': FieldValue.arrayUnion([widget.product.productId])
        });
        print('Added to featured products: ${widget.product.productId}');
      } else {
        // Remove product from featured list
        await storeDocRef.update({
          'featuredProductIds': FieldValue.arrayRemove([widget.product.productId])
        });
        print('Removed from featured products: ${widget.product.productId}');
      }
    } catch (e) {
      print('Error updating featured products: $e');
      // Revert the UI state if the operation failed
      setState(() {
        _isFeatured = !_isFeatured;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update featured products')),
      );
    }
  }

  ProductVariant? _getFirstVariation() {
    if (widget.product.variations.isNotEmpty) {
      return widget.product.variations.values.first;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    var firstVariation = _getFirstVariation();
    var price = firstVariation?.price ?? 0.0;
    var mrp = firstVariation?.mrp ?? 0.0;
    var discount = firstVariation?.discount ?? 0.0;
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetailScreen(
              product: widget.product,
            ),
          ),
        );
      },
      child: Container(
        width: widget.width,
        height: widget.height,
        margin: EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6.0),
          color: hexToColor('#F5F5F5'),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.vertical(top: Radius.circular(6.0)),
                      image: widget.product.imageUrls.isNotEmpty
                          ? DecorationImage(
                        image: NetworkImage(widget.product.imageUrls[0]),
                        fit: BoxFit.cover,
                      ) : null,
                    ),

                    child: widget.product.imageUrls.isEmpty
                        ? Center(child: Icon(Icons.image_not_supported, size: 40, color: Colors.grey))
                        : null,
                  ),
                  Positioned(
                    right: 8.0,
                    top: 8.0,
                    child: GestureDetector(
                      onTap: _toggleFeatured,
                      child: Container(
                        padding: EdgeInsets.all(6.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          _isFeatured ? Icons.check : Icons.add,
                          color: _isFeatured ? Colors.green : Colors.grey,
                          size: 18.0,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    widget.product.name,
                    style: TextStyle(
                      color: hexToColor('#343434'),
                      fontSize: 12.0,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4.0),
                  Row(
                    children: [
                      Text(
                        '₹${price.toStringAsFixed(2)}',
                        style: TextStyle(
                          color: hexToColor('#343434'),
                          fontSize: 12.0,
                        ),
                      ),
                      SizedBox(width: 4.0),
                      if (discount > 0)
                        Text(
                          '${discount.toStringAsFixed(0)}% OFF',
                          style: TextStyle(
                            color: hexToColor('#FF0000'),
                            fontSize: 10.0,
                          ),
                        ),
                    ],
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