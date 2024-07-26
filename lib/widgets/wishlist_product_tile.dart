import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tnennt/models/product_model.dart';
import 'package:tnennt/screens/product_detail_screen.dart';
import '../helpers/color_utils.dart';

class WishlistProductTile extends StatefulWidget {
  final ProductModel product;
  final double width;
  final double height;

  WishlistProductTile({
    required this.product,
    this.width = 150.0,
    this.height = 200.0,
  });

  @override
  _WishlistProductTileState createState() => _WishlistProductTileState();
}

class _WishlistProductTileState extends State<WishlistProductTile> {
  bool _isInWishlist = false;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late Map<String, dynamic> _wishlistItem;

  @override
  void initState() {
    super.initState();
    _wishlistItem = {
      'productId': widget.product.productId,
      'variation': widget.product.variations.keys.first,
    };
    _checkWishlistStatus();
  }

  void _checkWishlistStatus() async {
    User? user = _auth.currentUser;
    if (user != null) {
      DocumentSnapshot userDoc = await _firestore.collection('Users').doc(user.uid).get();
      if (userDoc.exists) {
        List<dynamic> wishlist = (userDoc.data() as Map<String, dynamic>)['wishlist'] ?? [];
        setState(() {
          _isInWishlist = wishlist.any((item) =>
          item['productId'] == _wishlistItem['productId'] &&
              item['variation'] == _wishlistItem['variation']);
        });
      }
    }
  }

  Future<void> _toggleWishlist() async {
    User? user = _auth.currentUser;
    if (user == null) {
      // Handle the case when the user is not logged in
      print('User is not logged in');
      return;
    }

    setState(() {
      _isInWishlist = !_isInWishlist;
    });

    try {
      DocumentReference userDocRef = _firestore.collection('Users').doc(user.uid);

      if (_isInWishlist) {
        // Add product to wishlist
        await userDocRef.update({
          'wishlist': FieldValue.arrayUnion([_wishlistItem])
        });
        print('Added to wishlist: $_wishlistItem');
      } else {
        // Remove product from wishlist
        await userDocRef.update({
          'wishlist': FieldValue.arrayRemove([_wishlistItem])
        });
        print('Removed from wishlist: $_wishlistItem');
      }
    } catch (e) {
      print('Error updating wishlist: $e');
      // Revert the UI state if the operation failed
      setState(() {
        _isInWishlist = !_isInWishlist;
      });
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
