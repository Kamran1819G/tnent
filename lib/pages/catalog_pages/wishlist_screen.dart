import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tnennt/models/product_model.dart';
import 'package:tnennt/screens/product_detail_screen.dart';
import '../../helpers/color_utils.dart';

class WishlistScreen extends StatefulWidget {
  const WishlistScreen({Key? key}) : super(key: key);

  @override
  _WishlistScreenState createState() => _WishlistScreenState();
}

class _WishlistScreenState extends State<WishlistScreen> {
  bool selectAllItems = false;
  bool isLoading = true;
  List<String> wishlistItems = [];
  double totalPrice = 0.0;

  @override
  void initState() {
    super.initState();
    fetchWishlistItems();
  }

  Future<void> fetchWishlistItems() async {
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
          List<dynamic> wishlist = (userDoc.data() as Map<String, dynamic>)['wishlist'] ?? [];
          setState(() {
            wishlistItems = wishlist.cast<String>();
            isLoading = false;
          });
        }
      }
    } catch (e) {
      print('Error fetching wishlist: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  void updateTotalPrice() {
    double newTotal = 0.0;
    for (var item in wishlistItems) {
      if (selectedItems.contains(item)) {
        newTotal += itemPrices[item] ?? 0.0;
      }
    }
    setState(() {
      totalPrice = newTotal;
    });
  }

  Set<String> selectedItems = {};
  Map<String, double> itemPrices = {};

  void toggleSelectAll(bool? value) {
    setState(() {
      selectAllItems = value ?? false;
      if (selectAllItems) {
        selectedItems = Set.from(wishlistItems);
      } else {
        selectedItems.clear();
      }
      updateTotalPrice();
    });
  }

  void toggleItemSelection(String itemId, bool isSelected, double price) {
    setState(() {
      if (isSelected) {
        selectedItems.add(itemId);
      } else {
        selectedItems.remove(itemId);
      }
      itemPrices[itemId] = price;
      updateTotalPrice();
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
                        '₹ ${totalPrice.toStringAsFixed(2)}',
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
                            'Select All Items',
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
                        value: selectAllItems,
                        onChanged: toggleSelectAll,
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
                  return WishlistItemTile(
                    productId: wishlistItems[index],
                    isSelected: selectedItems.contains(wishlistItems[index]),
                    onSelectionChanged: (isSelected, price) {
                      toggleItemSelection(wishlistItems[index], isSelected, price);
                    },
                    onRemove: () {
                      setState(() {
                        wishlistItems.removeAt(index);
                        selectedItems.remove(wishlistItems[index]);
                        updateTotalPrice();
                      });
                      // Update the user's wishlist in Firestore
                      updateUserWishlist();
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> updateUserWishlist() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await FirebaseFirestore.instance
            .collection('Users')
            .doc(user.uid)
            .update({'wishlist': wishlistItems});
      }
    } catch (e) {
      print('Error updating wishlist: $e');
    }
  }
}

class WishlistItemTile extends StatefulWidget {
  final String productId;
  final bool isSelected;
  final Function(bool, double) onSelectionChanged;
  final VoidCallback onRemove;

  WishlistItemTile({
    required this.productId,
    required this.isSelected,
    required this.onSelectionChanged,
    required this.onRemove,
  });

  @override
  _WishlistItemTileState createState() => _WishlistItemTileState();
}

class _WishlistItemTileState extends State<WishlistItemTile> {
  late ProductModel product;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchProductDetails();
  }

  Future<void> fetchProductDetails() async {
    try {
      DocumentSnapshot productDoc = await FirebaseFirestore.instance
          .collection('products')
          .doc(widget.productId)
          .get();

      if (productDoc.exists) {
        setState(() {
          product = ProductModel.fromFirestore(productDoc);
          isLoading = false;
        });
      }
    } catch (e) {
      print('Error fetching product details: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Center(child: CircularProgressIndicator());
    }

    ProductVariant? firstVariant = product.variations.isNotEmpty
        ? product.variations.values.first
        : null;
    double price = firstVariant?.price ?? 0.0;

    String? firstVariationKey = product.variations.isNotEmpty
        ? product.variations.keys.first
        : null;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetailScreen(product: product),
          ),
        );
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 6.0, vertical: 14.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: 190,
              width: 150,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4.0),
                image: DecorationImage(
                  image: NetworkImage(product.imageUrls.first),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(width: 12.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: TextStyle(
                      color: hexToColor('#343434'),
                      fontSize: 20.0,
                    ),
                  ),
                  SizedBox(height: 8.0),
                  if (firstVariationKey != null)
                    Text(
                      'Variation: $firstVariationKey',
                      style: TextStyle(
                        color: hexToColor('#737373'),
                        fontSize: 14.0,
                      ),
                    ),
                  SizedBox(height: 55.0),
                  Text(
                    firstVariant != null
                        ? '₹${firstVariant.price.toStringAsFixed(2)}'
                        : 'Price not available',
                    style: TextStyle(
                      color: hexToColor('#343434'),
                      fontSize: 20.0,
                    ),
                  ),
                  SizedBox(height: 25.0),
                  Row(
                    children: [
                      GestureDetector(
                        onTap: widget.onRemove,
                        child: Container(
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
                      Checkbox(
                        checkColor: Colors.black,
                        activeColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          side: BorderSide(color: Colors.black),
                          borderRadius: BorderRadius.circular(4.0),
                        ),
                        value: widget.isSelected,
                        onChanged: (value) {
                          widget.onSelectionChanged(value ?? false, price);
                        },
                      ),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}