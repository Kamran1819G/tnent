import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:convert';

// Assume this helper function is defined in color_utils.dart
import '../../helpers/color_utils.dart';

class WishlistItem {
  final String productID;

  WishlistItem({required this.productID});

  factory WishlistItem.fromJson(Map<String, dynamic> json) {
    return WishlistItem(productID: json['productID'] as String);
  }
}

class WishlistScreen extends StatefulWidget {
  const WishlistScreen({Key? key}) : super(key: key);

  @override
  _WishlistScreenState createState() => _WishlistScreenState();
}

class _WishlistScreenState extends State<WishlistScreen> {
  bool selectedItems = false;
  List<WishlistItem> wishlistItems = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchWishlistData();
  }

  Future<void> fetchWishlistData() async {
    setState(() {
      isLoading = true;
    });

    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('Users')
            .doc(user.uid)
            .get();

        if (userDoc.exists) {
          String wishlistString = userDoc.get('wishlist') as String;
          List<dynamic> wishlistJson = jsonDecode(wishlistString);
          wishlistItems = wishlistJson
              .map((item) => WishlistItem.fromJson(item))
              .toList();
        }
      }
    } catch (e) {
      print('Error fetching wishlist data: $e');
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Container(
              height: 100,
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  Text(
                    'Wishlist'.toUpperCase(),
                    style: TextStyle(
                      color: hexToColor('#1E1E1E'),
                      fontSize: 24.0,
                      letterSpacing: 1.5,
                    ),
                  ),
                  Text(
                    ' •',
                    style: TextStyle(
                      fontSize: 24.0,
                      color: hexToColor('#42FF00'),
                    ),
                  ),
                  Spacer(),
                  CircleAvatar(
                    backgroundColor: Colors.grey[100],
                    child: IconButton(
                      icon: Icon(Icons.arrow_back_ios_new, color: Colors.black),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16.0),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12.0),
              height: 75,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
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
                        '₹ 0.00',
                        style: TextStyle(
                          color: hexToColor('#A9A9A9'),
                          fontSize: 18.0,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Select Items',
                            style: TextStyle(
                              color: hexToColor('#343434'),
                              fontSize: 16.0,
                            ),
                          ),
                          Text(
                            'Buy All The Selected Products Together',
                            style: TextStyle(
                              color: hexToColor('#989898'),
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w500,
                              fontSize: 9.0,
                            ),
                          ),
                        ],
                      ),
                      Checkbox(
                        activeColor: Theme.of(context).primaryColor,
                        value: selectedItems,
                        onChanged: (value) {
                          setState(() {
                            selectedItems = value!;
                          });
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 16.0),
            Expanded(
              child: isLoading
                  ? Center(child: CircularProgressIndicator())
                  : ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: 8.0),
                itemCount: wishlistItems.length,
                itemBuilder: (context, index) {
                  return WishlistProductTile(
                    productID: wishlistItems[index].productID,
                    selectedItem: selectedItems,
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

class WishlistProductTile extends StatefulWidget {
  final String productID;
  final bool selectedItem;

  WishlistProductTile({
    required this.productID,
    this.selectedItem = false,
  });

  @override
  _WishlistProductTileState createState() => _WishlistProductTileState();
}

class _WishlistProductTileState extends State<WishlistProductTile> {
  bool _isInWishlist = true;
  bool _isSelected = false;
  String productName = '';
  int productPrice = 0;
  String productImage = '';
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchProductDetails();
  }

  Future<void> fetchProductDetails() async
  {
    try
    {
      DocumentSnapshot productDoc = await FirebaseFirestore.instance
          .collection('Products')
          .doc(widget.productID)
          .get();

      if (productDoc.exists) {
        setState(() {
          productName = productDoc.get('ProductName') as String;
          productPrice = productDoc.get('ProductPrice') as int;
          productImage = productDoc.get('ProductImg') as String;
          isLoading = false;
        });
      }
    }
    catch (e)
    {
      print('Error fetching product details: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  void _toggleWishlist() {
    setState(() {
      _isInWishlist = !_isInWishlist;
    });
    // Here you would update the wishlist in Firebase
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Center(child: CircularProgressIndicator());
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 6.0, vertical: 14.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Stack(
            children: [
              Container(
                height: 190,
                width: 150,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4.0),
                  image: DecorationImage(
                    image: NetworkImage(productImage),
                    fit: BoxFit.cover,
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
          SizedBox(width: 12.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  productName,
                  style: TextStyle(
                    color: hexToColor('#343434'),
                    fontSize: 20.0,
                  ),
                ),
                SizedBox(height: 65.0),
                Text(
                  '₹$productPrice',
                  style: TextStyle(
                    color: hexToColor('#343434'),
                    fontSize: 20.0,
                  ),
                ),
                SizedBox(height: 25.0),
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                      decoration: BoxDecoration(
                        border: Border.all(color: hexToColor('#343434')),
                        borderRadius: BorderRadius.circular(100.0),
                      ),
                      child: Text(
                        'Remove',
                        style: TextStyle(
                          color: hexToColor('#737373'),
                          fontSize: 12.0,
                        ),
                      ),
                    ),
                    SizedBox(width: 8.0),
                    GestureDetector(
                      onTap: () {
                        // Navigate to checkout screen
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                        decoration: BoxDecoration(
                          color: hexToColor('#343434'),
                          borderRadius: BorderRadius.circular(100.0),
                        ),
                        child: Text(
                          'Buy Now',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12.0,
                          ),
                        ),
                      ),
                    ),
                    if (widget.selectedItem)
                      Checkbox(
                        checkColor: Colors.black,
                        activeColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          side: BorderSide(color: Colors.black),
                          borderRadius: BorderRadius.circular(4.0),
                        ),
                        value: _isSelected,
                        onChanged: (value) {
                          setState(() {
                            _isSelected = value!;
                          });
                        },
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