import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tnennt/models/product_model.dart';
import 'package:tnennt/screens/product_detail_screen.dart';
import '../../helpers/color_utils.dart';
import 'checkout_screen.dart';

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
          List<dynamic> wishlist =
              (userDoc.data() as Map<String, dynamic>)['wishlist'] ?? [];
          List<Map<String, dynamic>> updatedWishlistItems = [];

          for (var item in wishlist) {
            Map<String, dynamic> productDetails =
                await _fetchProductDetails(item['productId']);
            updatedWishlistItems.add({
              ...item,
              ...productDetails,
              'variationDetails': productDetails['variations']
                  [item['variation']],
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
      if (selectedItems
          .contains('${item['productId']}_${item['variation']}')) {
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
        selectedItems = Set.from(wishlistItems
            .map((item) => '${item['productId']}_${item['variation']}'));
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
              height: 100.h,
              margin: EdgeInsets.only(top: 20.h, bottom: 20.h),
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Row(
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
                  Spacer(),
                  IconButton(
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all(
                        Colors.grey[100],
                      ),
                      shape: WidgetStateProperty.all(
                        CircleBorder(),
                      ),
                    ),
                    icon: Icon(Icons.arrow_back_ios_new,
                        color: Colors.black),
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
                        '₹ ${totalPrice.toStringAsFixed(2)}',
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
                          value: selectAllItems,
                          onChanged: toggleSelectAll,
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
                  : ListView.builder(
                      padding: EdgeInsets.symmetric(horizontal: 12.w),
                      itemCount: wishlistItems.length,
                      itemBuilder: (context, index) {
                        return WishlistItemTile(
                          item: wishlistItems[index],
                          isSelected: selectedItems.contains(
                              '${wishlistItems[index]['productId']}_${wishlistItems[index]['variation']}'),
                          onSelectionChanged: (isSelected) {
                            toggleItemSelection(
                                '${wishlistItems[index]['productId']}_${wishlistItems[index]['variation']}',
                                isSelected);
                          },
                          onRemove: () {
                            setState(() {
                              wishlistItems.removeAt(index);
                              selectedItems.remove(
                                  '${wishlistItems[index]['productId']}_${wishlistItems[index]['variation']}');
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
        List<Map<String, dynamic>> wishlistData = wishlistItems
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
            builder: (context) => ProductDetailScreen(
                product: ProductModel.fromFirestore(
                    item as DocumentSnapshot<Object?>?)),
          ),
        );
      },
      child: Container(
        height: 285.h,
        margin: EdgeInsets.symmetric(vertical: 12.h, horizontal: 18.w),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
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
                  ? Center(child: Icon(Icons.image_not_supported, size: 50.sp, color: Colors.grey))
                  : null,
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    item['productName'],
                    style: TextStyle(
                      color: hexToColor('#343434'),
                      fontSize: 26.sp,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    'Variation: ${item['variation']}',
                    style: TextStyle(
                      color: hexToColor('#737373'),
                      fontSize: 18.sp,
                    ),
                  ),
                  SizedBox(height: 60.h),
                  Text(
                    '₹${item['variationDetails'].price.toStringAsFixed(2)}',
                    style: TextStyle(
                      color: hexToColor('#343434'),
                      fontSize: 28.sp,
                    ),
                  ),
                  SizedBox(height: 40.h),
                  Row(
                    children: [
                      GestureDetector(
                        onTap: onRemove,
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
                          // Navigate to Checkout
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
                      SizedBox(width: 8.w),
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
