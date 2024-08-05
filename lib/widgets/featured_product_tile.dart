import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tnent/models/product_model.dart';
import 'package:tnent/models/store_model.dart';
import 'package:tnent/screens/product_detail_screen.dart';
import '../helpers/color_utils.dart';

class FeaturedProductTile extends StatefulWidget {
  final ProductModel product;
  final double width;
  final double height;

  const FeaturedProductTile({
    super.key,
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
    DocumentSnapshot storeDoc =
        await _firestore.collection('Stores').doc(widget.product.storeId).get();
    if (storeDoc.exists) {
      StoreModel store = StoreModel.fromFirestore(storeDoc);
      setState(() {
        _isFeatured =
            store.featuredProductIds.contains(widget.product.productId);
      });
    }
  }

  Future<void> _toggleFeatured() async {
    DocumentReference storeDocRef =
        _firestore.collection('Stores').doc(widget.product.storeId);

    try {
      await _firestore.runTransaction((transaction) async {
        DocumentSnapshot storeDoc = await transaction.get(storeDocRef);
        if (!storeDoc.exists) {
          throw Exception('Store document does not exist');
        }

        StoreModel store = StoreModel.fromFirestore(storeDoc);
        List<String> featuredProductIds = store.featuredProductIds;

        if (!_isFeatured && featuredProductIds.length >= 5) {
          throw Exception('Maximum 5 featured products allowed');
        }

        if (_isFeatured) {
          featuredProductIds.remove(widget.product.productId);
        } else {
          featuredProductIds.add(widget.product.productId);
        }

        transaction
            .update(storeDocRef, {'featuredProductIds': featuredProductIds});
      });

      setState(() {
        _isFeatured = !_isFeatured;
      });

      String message = _isFeatured
          ? 'Added to featured products: ${widget.product.productId}'
          : 'Removed from featured products: ${widget.product.productId}';
      print(message);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Product Added to Featured Products')),
      );
    } catch (e) {
      print('Error updating featured products: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content:
                Text('Failed to update featured products: ${e.toString()}')),
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
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(6.0)),
                      image: widget.product.imageUrls.isNotEmpty
                          ? DecorationImage(
                              image: NetworkImage(widget.product.imageUrls[0]),
                              fit: BoxFit.cover,
                            )
                          : null,
                    ),
                    child: widget.product.imageUrls.isEmpty
                        ? Center(
                            child: Icon(Icons.image_not_supported,
                                size: 40, color: Colors.grey))
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
