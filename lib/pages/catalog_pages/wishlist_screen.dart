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
  List<Map<String, dynamic>> wishlistItems = [];
  double totalPrice = 0.0;
  Set<String> selectedItems = {};

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
          List<Map<String, dynamic>> updatedWishlistItems = [];

          for (var item in wishlist) {
            Map<String, dynamic> productDetails = await _fetchProductDetails(item['productId']);
            updatedWishlistItems.add({
              ...item,
              ...productDetails,
              'variationDetails': productDetails['variations'][item['variationKey']],
              'isSelected': false,
            });
          }

          setState(() {
            wishlistItems = updatedWishlistItems;
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

  Future<Map<String, dynamic>> _fetchProductDetails(String productId) async {
    DocumentSnapshot productDoc = await FirebaseFirestore.instance
        .collection('products')
        .doc(productId)
        .get();

    if (!productDoc.exists) {
      return {};
    }

    ProductModel product = ProductModel.fromFirestore(productDoc);
    return {
      'productName': product.name,
      'productImage': product.imageUrls.isNotEmpty ? product.imageUrls[0] : '',
      'variations': product.variations,
    };
  }

  void updateTotalPrice() {
    double newTotal = 0.0;
    for (var item in wishlistItems) {
      if (selectedItems.contains('${item['productId']}_${item['variationKey']}')) {
        newTotal += item['variationDetails'].price;
      }
    }
    setState(() {
      totalPrice = newTotal;
    });
  }

  void toggleSelectAll(bool? value) {
    setState(() {
      selectAllItems = value ?? false;
      if (selectAllItems) {
        selectedItems = Set.from(wishlistItems.map((item) => '${item['productId']}_${item['variationKey']}'));
      } else {
        selectedItems.clear();
      }
      updateTotalPrice();
    });
  }

  void toggleItemSelection(String itemId, bool isSelected) {
    setState(() {
      if (isSelected) {
        selectedItems.add(itemId);
      } else {
        selectedItems.remove(itemId);
      }
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
                    item: wishlistItems[index],
                    isSelected: selectedItems.contains('${wishlistItems[index]['productId']}_${wishlistItems[index]['variationKey']}'),
                    onSelectionChanged: (isSelected) {
                      toggleItemSelection('${wishlistItems[index]['productId']}_${wishlistItems[index]['variationKey']}', isSelected);
                    },
                    onRemove: () {
                      setState(() {
                        wishlistItems.removeAt(index);
                        selectedItems.remove('${wishlistItems[index]['productId']}_${wishlistItems[index]['variationKey']}');
                        updateTotalPrice();
                      });
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
        List<Map<String, dynamic>> wishlistData = wishlistItems.map((item) => {
          'productId': item['productId'],
          'variation': item['variation'],
        }).toList();

        await FirebaseFirestore.instance
            .collection('Users')
            .doc(user.uid)
            .update({'wishlist': wishlistData});
      }
    } catch (e) {
      print('Error updating wishlist: $e');
    }
  }
}

class WishlistItemTile extends StatelessWidget {
  final Map<String, dynamic> item;
  final bool isSelected;
  final Function(bool) onSelectionChanged;
  final VoidCallback onRemove;

  const WishlistItemTile({
    Key? key,
    required this.item,
    required this.isSelected,
    required this.onSelectionChanged,
    required this.onRemove,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetailScreen(product: ProductModel.fromFirestore(item as DocumentSnapshot<Object?>?)),
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
                  image: NetworkImage(item['productImage']),
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
                    item['productName'],
                    style: TextStyle(
                      color: hexToColor('#343434'),
                      fontSize: 20.0,
                    ),
                  ),
                  SizedBox(height: 8.0),
                  Text(
                    'Variation: ${item['variationKey']}',
                    style: TextStyle(
                      color: hexToColor('#737373'),
                      fontSize: 14.0,
                    ),
                  ),
                  SizedBox(height: 55.0),
                  Text(
                    '₹${item['variationDetails'].price.toStringAsFixed(2)}',
                    style: TextStyle(
                      color: hexToColor('#343434'),
                      fontSize: 20.0,
                    ),
                  ),
                  SizedBox(height: 25.0),
                  Row(
                    children: [
                      GestureDetector(
                        onTap: onRemove,
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
                        value: isSelected,
                        onChanged: (value) {
                          onSelectionChanged(value ?? false);
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