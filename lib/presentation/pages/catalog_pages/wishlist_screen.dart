import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:tnent/core/helpers/snackbar_utils.dart';
import 'package:tnent/models/product_model.dart';
import 'package:tnent/presentation/pages/product_detail_screen.dart';
import '../../../core/helpers/color_utils.dart';
import 'checkout_screen.dart';

class WishlistScreen extends StatefulWidget {
  const WishlistScreen({Key? key}) : super(key: key);

  @override
  _WishlistScreenState createState() => _WishlistScreenState();
}

class _WishlistScreenState extends State<WishlistScreen> {
  bool _allItemsSelected = false;
  bool isLoading = true;
  List<Map<String, dynamic>> wishlistItems = [];
  double _totalAmount = 0.0;

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
          List<dynamic> wishlist =
              (userDoc.data() as Map<String, dynamic>)['wishlist'] ?? [];
          List<Map<String, dynamic>> updatedWishlistItems = [];

          for (var item in wishlist) {
            try {
              Map<String, dynamic> productDetails =
                  await _fetchProductDetails(item['productId']);
              if (productDetails.isNotEmpty) {
                updatedWishlistItems.add({
                  ...item,
                  ...productDetails,
                  'quantity': 1,
                  'variationDetails': productDetails['variations']
                      [item['variation']],
                  'isSelected': false,
                });
              }
            } catch (e) {
              print('Error fetching product ${item['productId']}: $e');
              // Optionally, you can add a placeholder or error item here
            }
          }

          setState(() {
            wishlistItems = updatedWishlistItems.reversed.toList();
            isLoading = false;
          });
        } else {
          setState(() {
            isLoading = false;
          });
        }
      } else {
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      print('Error fetching wishlist: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<Map<String, dynamic>> _fetchProductDetails(String productId) async {
    try {
      DocumentSnapshot productDoc = await FirebaseFirestore.instance
          .collection('products')
          .doc(productId)
          .get(GetOptions(source: Source.cache));

      if (!productDoc.exists) {
        productDoc = await FirebaseFirestore.instance
            .collection('products')
            .doc(productId)
            .get(GetOptions(source: Source.server));
      }

      if (!productDoc.exists) {
        print('Product document not found for ID: $productId');
        return {};
      }

      ProductModel product = ProductModel.fromFirestore(productDoc);
      return {
        'productName': product.name,
        'productImage':
            product.imageUrls.isNotEmpty ? product.imageUrls[0] : '',
        'variations': product.variations,
      };
    } catch (e) {
      print('Error fetching product details for ID $productId: $e');
      return {};
    }
  }

  void _updateSelectionState() {
    _allItemsSelected = wishlistItems.isNotEmpty &&
        wishlistItems.every((item) => item['isSelected'] == true);
    _calculateTotalAmount();
  }

  void _calculateTotalAmount() {
    _totalAmount = wishlistItems
        .where((item) => item['isSelected'] == true)
        .fold(0, (sum, item) => sum + item['variationDetails'].price);
  }

  void _toggleAllItemsSelection(bool? value) {
    setState(() {
      _allItemsSelected = value ?? false;
      for (var item in wishlistItems) {
        item['isSelected'] = _allItemsSelected;
      }
      _calculateTotalAmount();
    });
    _updateFirestore();
  }

  void _updateItemSelection(
      String productId, String variation, bool isSelected) {
    setState(() {
      int index = wishlistItems.indexWhere((item) =>
          item['productId'] == productId && item['variation'] == variation);
      if (index != -1) {
        wishlistItems[index]['isSelected'] = isSelected;
        _updateSelectionState();
      }
    });
  }

  void _updateFirestore() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        List<Map<String, dynamic>> wishlistData = wishlistItems.reversed
            .map((item) => {
                  'productId': item['productId'],
                  'variation': item['variation'],
                })
            .toList();

        await FirebaseFirestore.instance
            .collection('Users')
            .doc(user.uid)
            .update({'wishlist': wishlistData});
      }
    } catch (e) {
      print('Error updating wishlist: $e');
    }
  }

  void _removeFromWishlist(String productId, String variation) {
    setState(() {
      wishlistItems.removeWhere((item) =>
          item['productId'] == productId && item['variation'] == variation);
      _updateSelectionState();
    });
    _updateFirestore();
  }

  void _navigateToCheckout() {
    List<Map<String, dynamic>> selectedItems =
        wishlistItems.where((item) => item['isSelected'] == true).toList();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CheckoutScreen(selectedItems: selectedItems),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Container(
              height: 100.h,
              margin: EdgeInsets.only(top: 20.h, bottom: 20.h),
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Row(
                children: [
                  Row(
                    children: [
                      Text(
                        'Wishlist'.toUpperCase(),
                        style: TextStyle(
                          color: hexToColor('#1E1E1E'),
                          fontSize: 35.sp,
                          letterSpacing: 1.5,
                        ),
                      ),
                      Text(
                        ' •',
                        style: TextStyle(
                          fontSize: 35.sp,
                          color: hexToColor('#42FF00'),
                        ),
                      ),
                    ],
                  ),
                  Spacer(),
                  IconButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                        Colors.grey[100],
                      ),
                      shape: MaterialStateProperty.all(
                        CircleBorder(),
                      ),
                    ),
                    icon: Icon(Icons.arrow_back_ios_new, color: Colors.black),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            ),
            SizedBox(height: 24.h),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              height: 100.h,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Total Amount',
                        style: TextStyle(
                          color: hexToColor('#343434'),
                          fontSize: 24.sp,
                        ),
                      ),
                      Text(
                        '₹ ${_totalAmount.toStringAsFixed(2)}',
                        style: TextStyle(
                          color: hexToColor('#A9A9A9'),
                          fontSize: 26.sp,
                        ),
                      ),
                    ],
                  ),
                  if (wishlistItems.length > 1)
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
                                fontSize: 22.sp,
                              ),
                            ),
                            Text(
                              'Buy All The Selected Products Together',
                              style: TextStyle(
                                color: hexToColor('#989898'),
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w500,
                                fontSize: 14.sp,
                              ),
                            ),
                          ],
                        ),
                        Checkbox(
                          activeColor: Theme.of(context).primaryColor,
                          value: _allItemsSelected,
                          onChanged: _toggleAllItemsSelection,
                        ),
                      ],
                    ),
                ],
              ),
            ),
            SizedBox(height: 20.h),
            Expanded(
              child: isLoading
                  ? Center(child: CircularProgressIndicator())
                  : wishlistItems.isEmpty
                      ? Center(child: Text('Your wishlist is empty'))
                      : ListView.builder(
                          padding: EdgeInsets.symmetric(horizontal: 12.w),
                          itemCount: wishlistItems.length,
                          itemBuilder: (context, index) {
                            final item = wishlistItems[index];
                            return WishlistItemTile(
                              key: ValueKey(
                                  '${item['productId']}_${item['variation']}'),
                              item: item,
                              onRemove: _removeFromWishlist,
                              onUpdateSelection: _updateItemSelection,
                            );
                          },
                        ),
            ),
            Padding(
              padding: EdgeInsets.all(24.w),
              child: ElevatedButton(
                child: Text('Buy Selected Items',
                    style: TextStyle(fontSize: 22.sp)),
                onPressed:
                    wishlistItems.any((item) => item['isSelected'] == true)
                        ? _navigateToCheckout
                        : null,
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.r),
                  ),
                  backgroundColor: hexToColor('#343434'),
                  foregroundColor: Colors.white,
                  minimumSize: Size(double.infinity, 75.h),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class WishlistItemTile extends StatelessWidget {
  final Map<String, dynamic> item;
  final Function(String, String) onRemove;
  final Function(String, String, bool) onUpdateSelection;

  const WishlistItemTile({
    Key? key,
    required this.item,
    required this.onRemove,
    required this.onUpdateSelection,
  }) : super(key: key);

  Future<void> _fetchProductAndNavigate(String productId) async {
    try {
      final DocumentSnapshot<Map<String, dynamic>> prodcutDoc =
          await FirebaseFirestore.instance
              .collection('products')
              .doc(productId)
              .get();

      if (!prodcutDoc.exists) {
        print('Product document not found for ID: $productId');
        return;
      }

      final ProductModel product = ProductModel.fromFirestore(prodcutDoc);

      Get.to(() => ProductDetailScreen(product: product));
    } catch (e) {
      print("Failed to fetch order");
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        _fetchProductAndNavigate(item['productId']);
      },
      child: Container(
        height: 285.h,
        margin: EdgeInsets.symmetric(vertical: 12.h, horizontal: 18.w),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              height: 285.h,
              width: 255.w,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.r),
                image: item['productImage'] != null
                    ? DecorationImage(
                        image: NetworkImage(item['productImage']),
                        fit: BoxFit.cover,
                      )
                    : null,
              ),
              child: item['productImage'] == null
                  ? Center(
                      child: Icon(Icons.image_not_supported,
                          size: 50.sp, color: Colors.grey))
                  : null,
            ),
            SizedBox(width: 16.w),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  item['productName'],
                  style: TextStyle(
                    color: hexToColor('#343434'),
                    fontSize: 26.sp,
                  ),
                ),
                if (item['variation'] != 'default') ...[
                  SizedBox(height: 8.h),
                  Text(
                    'Variation: ${item['variation']}',
                    style: TextStyle(
                      color: hexToColor('#989898'),
                      fontSize: 18.sp,
                    ),
                  ),
                ],
                SizedBox(height: 25.h),
                Text(
                  '₹${item['variationDetails'].price.toStringAsFixed(2)}',
                  style: TextStyle(
                    color: hexToColor('#343434'),
                    fontSize: 28.h,
                  ),
                ),
                SizedBox(height: 25.h),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () =>
                          onRemove(item['productId'], item['variation']),
                      child: Container(
                        height: 50.h,
                        width: 105.w,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          border: Border.all(color: hexToColor('#343434')),
                          borderRadius: BorderRadius.circular(50.r),
                        ),
                        child: Text(
                          'Remove',
                          style: TextStyle(
                            color: hexToColor('#737373'),
                            fontSize: 17.sp,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 8.w),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                CheckoutScreen(selectedItems: [item]),
                          ),
                        );
                      },
                      child: Container(
                        height: 50.h,
                        width: 105.w,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: hexToColor('#343434'),
                          borderRadius: BorderRadius.circular(50.r),
                        ),
                        child: Text(
                          'Buy Now',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 17.sp,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Checkbox(
                      checkColor: Colors.black,
                      activeColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        side: BorderSide(color: Colors.black),
                        borderRadius: BorderRadius.circular(6.r),
                      ),
                      value: item['isSelected'] ?? false,
                      onChanged: (value) {
                        onUpdateSelection(item['productId'], item['variation'],
                            value ?? false);
                      },
                    ),
                  ],
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
