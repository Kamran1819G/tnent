import 'package:flutter/material.dart';
import 'package:tnennt/models/product_model.dart';
import 'package:tnennt/screens/product_detail_screen.dart';
import '../helpers/color_utils.dart';

class ProductTile extends StatefulWidget {
  final ProductModel product;
  final double width;
  final double height;

  ProductTile({
    required this.product,
    this.width = 150.0,
    this.height = 200.0,
  });

  @override
  _ProductTileState createState() => _ProductTileState();
}

class _ProductTileState extends State<ProductTile> {
  bool _isInWishlist = false;

  void _toggleWishlist() {
    setState(() {
      _isInWishlist = !_isInWishlist;
    });

    // Send wishlist request to the server
    if (_isInWishlist) {
      print('Adding to wishlist...');
    } else {
      print('Removing from wishlist...');
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
                  ClipRRect(
                    borderRadius: BorderRadius.vertical(top: Radius.circular(6.0)),
                    child: Image.network(
                      widget.product.imageUrls.first,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                    right: 8.0,
                    top: 8.0,
                    child: GestureDetector(
                      onTap: _toggleWishlist,
                      child: Container(
                        padding: EdgeInsets.all(6.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          _isInWishlist ? Icons.favorite : Icons.favorite_border,
                          color: _isInWishlist ? Colors.red : Colors.grey,
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
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(width: 4.0),
                      if (discount > 0)
                        Text(
                          '${discount.toStringAsFixed(0)}% OFF',
                          style: TextStyle(
                            color: hexToColor('#4CAF50'),
                            fontSize: 10.0,
                            fontWeight: FontWeight.bold,
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