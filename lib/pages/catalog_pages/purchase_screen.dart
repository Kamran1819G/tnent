import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tnennt/pages/catalog_pages/track_order_screen.dart';
import '../../helpers/color_utils.dart';
import 'detail_screen.dart';

class PurchaseItem {
  final String productId;
  final String variation;
  final String productName;
  final String productImage;
  final int productPrice;

  PurchaseItem({
    required this.productId,
    required this.variation,
    required this.productName,
    required this.productImage,
    required this.productPrice,
  });
}

class PurchaseScreen extends StatefulWidget {
  const PurchaseScreen({super.key});

  @override
  State<PurchaseScreen> createState() => _PurchaseScreenState();
}

class _PurchaseScreenState extends State<PurchaseScreen> {
  List<PurchaseItem> purchaseItems = [];
  int totalAmount = 0;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchPurchases();
  }

  Future<void> fetchPurchases() async {
    setState(() {
      isLoading = true;
    });

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final userDoc = await FirebaseFirestore.instance.collection('Users').doc(user.uid).get();
        final purchases = userDoc.data()?['purchases'] as List<dynamic>? ?? [];

        for (var purchase in purchases) {
          final productId = purchase['productId'] as String?;
          final variationKey = purchase['variation'] as String?;

          if (productId == null) {
            print('Warning: productId is null for a purchase');
            continue;
          }

          final productDoc = await FirebaseFirestore.instance.collection('products').doc(productId).get();
          final productData = productDoc.data();

          if (productData != null) {
            final productName = productData['name'] as String? ?? 'Unknown Product';
            final imageUrls = productData['imageUrls'] as List<dynamic>? ?? [];
            final productImage = imageUrls.isNotEmpty ? imageUrls[0] as String? : null;

            final variations = productData['variations'] as Map<String, dynamic>?;
            final variationData = variations?[variationKey] as Map<String, dynamic>?;

            if (variationData != null) {
              final productPrice = (variationData['price'] as num?)?.toInt() ?? 0;

              purchaseItems.add(PurchaseItem(
                productId: productId,
                variation: variationKey ?? 'default',
                productName: productName,
                productImage: productImage ?? 'https://placeholder.com/image.jpg',
                productPrice: productPrice,
              ));

              totalAmount += productPrice;
            } else {
              print('Warning: No variation data found for productId: $productId, variation: $variationKey');
            }
          } else {
            print('Warning: No product data found for productId: $productId');
          }
        }
      }
    } catch (e) {
      print('Error fetching purchases: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
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
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  Row(
                    children: [
                      Text(
                        'Purchase'.toUpperCase(),
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
            SizedBox(height: 16.0),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Total Amount',
                    style: TextStyle(
                      color: hexToColor('#343434'),
                      fontSize: 16.0,
                    ),
                  ),
                  Text(
                    '₹ $totalAmount',
                    style: TextStyle(
                      color: hexToColor('#A9A9A9'),
                      fontSize: 18.0,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16.0),
            Expanded(
              child: isLoading
                  ? Center(child: CircularProgressIndicator())
                  : purchaseItems.isEmpty
                  ? Center(child: Text('No purchases found'))
                  : ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: 10.0),
                itemCount: purchaseItems.length,
                itemBuilder: (context, index) {
                  final item = purchaseItems[index];
                  return PurchaseProductTile(
                    productId: item.productId,
                    productImage: item.productImage,
                    productName: item.productName,
                    productPrice: item.productPrice,
                    variation: item.variation,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PurchaseProductTile extends StatefulWidget {
  final String productId;  //
  final String productImage;
  final String productName;
  final int productPrice;
  final String variation;

  const PurchaseProductTile({
    required this.productId,
    required this.productImage,
    required this.productName,
    required this.productPrice,
    required this.variation,
  });

  @override
  State<PurchaseProductTile> createState() => _PurchaseProductTileState();
}

class _PurchaseProductTileState extends State<PurchaseProductTile> {
  bool _isInWishlist = true;

  void _toggleWishlist() {
    setState(() {
      _isInWishlist = !_isInWishlist;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 14.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              Container(
                height: 190,
                width: 150,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4.0),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(4.0),
                  child: Image.network(
                    widget.productImage,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Colors.grey[300],
                        child: Icon(Icons.image_not_supported, size: 50, color: Colors.grey[600]),
                      );
                    },
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Center(
                        child: CircularProgressIndicator(
                          value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                              : null,
                        ),
                      );
                    },
                  ),
                ),
              ),
              Positioned(
                right: 8.0,
                top: 8.0,
                child: GestureDetector(
                  onTap: _toggleWishlist,
                  child: Container(
                    padding: EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(100.0),
                    ),
                    child: Icon(
                      _isInWishlist ? Icons.favorite : Icons.favorite_border,
                      color: _isInWishlist ? Colors.red : Colors.grey,
                      size: 14.0,
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(width: 15.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.productName,
                  style: TextStyle(
                    color: hexToColor('#343434'),
                    fontSize: 20.0,
                  ),
                ),
                SizedBox(height: 4.0),
                Text(
                  'Variation: ${widget.variation}',
                  style: TextStyle(
                    color: hexToColor('#737373'),
                    fontSize: 14.0,
                  ),
                ),
                SizedBox(height: 8.0),
                Text(
                  '₹${widget.productPrice}',
                  style: TextStyle(
                    color: hexToColor('#343434'),
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 16.0),
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DetailScreen(
                              productId: widget.productId,
                              variation: widget.variation,
                            ),
                          ),
                        );
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                        decoration: BoxDecoration(
                          border: Border.all(color: hexToColor('#343434')),
                          borderRadius: BorderRadius.circular(100.0),
                        ),
                        child: Text(
                          'Details',
                          style: TextStyle(
                            color: hexToColor('#737373'),
                            fontSize: 12.0,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 8.0),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => TrackOrderScreen(
                              productImage: widget.productImage,
                              productName: widget.productName,
                              productPrice: widget.productPrice,
                            ),
                          ),
                        );
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                        decoration: BoxDecoration(
                          color: hexToColor('#343434'),
                          borderRadius: BorderRadius.circular(100.0),
                        ),
                        child: Text(
                          'Track Order',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12.0,
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}