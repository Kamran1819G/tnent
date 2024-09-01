import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tnent/core/helpers/color_utils.dart';
import 'package:tnent/models/product_model.dart';
import 'package:tnent/presentation/pages/catalog_pages/checkout_screen.dart';

import '../product_detail_screen.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  bool _allItemsSelected = false;
  List<Map<String, dynamic>> _cartItems = [];
  double _totalAmount = 0.0;

  @override
  void initState() {
    super.initState();
    _fetchCartItems();
  }


  Future<void> _fetchCartItems() async {
    String userId = FirebaseAuth.instance.currentUser?.uid ?? '';
    FirebaseFirestore.instance
        .collection('Users')
        .doc(userId)
        .snapshots()
        .listen((snapshot) async {
      if (snapshot.exists) {
        List<dynamic> cartData = snapshot.data()?['cart'] ?? [];

        List<Map<String, dynamic>> updatedCartItems = [];
        for (var item in cartData) {
          try {
            ProductModel product = await _fetchProductDetails(item['productId']);
            if (product != null) {
              updatedCartItems.add({
                ...item,
                'product': product,
                'variationDetails': product.variations[item['variation']],
                'isSelected': item['isSelected'] ?? false,
              });
            }
          } catch (e) {
            print('Error fetching product ${item['productId']}: $e');
          }
        }

        setState(() {
          _cartItems = updatedCartItems.reversed.toList();
          _updateSelectionState();
        });
      }
    });
  }

  Future<ProductModel> _fetchProductDetails(String productId) async {
    try {
      DocumentSnapshot productDoc = await FirebaseFirestore.instance
          .collection('products')
          .doc(productId)
          .get();

      if (!productDoc.exists) {
        throw Exception('Product not found');
      }

      return ProductModel.fromFirestore(productDoc);
    } catch (e) {
      print('Error fetching product details for ID $productId: $e');
      throw e;
    }
  }

  void _updateSelectionState() {
    setState(() {
      _allItemsSelected = _cartItems.isNotEmpty &&
          _cartItems.every((item) => item['isSelected'] == true);
      _calculateTotalAmount();
    });
  }

  void _calculateTotalAmount() {
    _totalAmount = _cartItems.where((item) => item['isSelected'] == true).fold(
        0,
            (sum, item) =>
        sum + (item['variationDetails'].price * item['quantity']));
  }

  void _toggleAllItemsSelection(bool? value) {
    setState(() {
      _allItemsSelected = value ?? false;
      for (var item in _cartItems) {
        item['isSelected'] = _allItemsSelected;
      }
      _calculateTotalAmount();
    });
    _updateFirestore();
  }

  void _updateItemSelection(String productId, String variation, bool isSelected) {
    setState(() {
      int index = _cartItems.indexWhere((item) =>
      item['productId'] == productId && item['variation'] == variation);
      if (index != -1) {
        _cartItems[index]['isSelected'] = isSelected;
        _updateSelectionState();
      }
    });
  }

  void _navigateToProductDetail(ProductModel product) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProductDetailScreen(product: product),
      ),
    );
  }

  void _updateFirestore() {
    String userId = FirebaseAuth.instance.currentUser?.uid ?? '';
    List<Map<String, dynamic>> cartData = _cartItems.reversed
        .map((item) => {
              'productId': item['productId'],
              'quantity': item['quantity'],
              'variation': item['variation'],
              'isSelected': item['isSelected'], // Include selection state
            })
        .toList();

    FirebaseFirestore.instance
        .collection('Users')
        .doc(userId)
        .update({'cart': cartData});
  }

  void _removeFromCart(String productId, String variation) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Remove Product'),
          content: Text('Are you sure you want to remove this product from your cart?'),
          actions: <Widget>[
            TextButton(
              child: Text('No'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
            TextButton(
              child: Text('Yes'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                setState(() {
                  _cartItems.removeWhere((item) =>
                  item['productId'] == productId && item['variation'] == variation);
                  _updateSelectionState();
                });
                _updateFirestore();
              },
            ),
          ],
        );
      },
    );
  }

  void _updateQuantity(String productId, String variation, int newQuantity) {
    setState(() {
      int index = _cartItems.indexWhere((item) =>
      item['productId'] == productId && item['variation'] == variation);
      if (index != -1) {
        _cartItems[index]['quantity'] = newQuantity.clamp(1, double.infinity).toInt();
        _updateSelectionState(); // This will recalculate the total amount
      }
    });
    _updateFirestore();
  }

  void _navigateToCheckout() {
    List<Map<String, dynamic>> selectedItems =
        _cartItems.where((item) => item['isSelected'] == true).toList();
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
                        'Cart'.toUpperCase(),
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
                  if (_cartItems.length > 1)
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
              child: ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: 12.w),
                itemCount: _cartItems.length,
                itemBuilder: (context, index) {
                  final item = _cartItems[index];
                  return CartItemTile(
                    key: ValueKey('${item['productId']}_${item['variation']}'),
                    item: item,
                    onRemove: _removeFromCart,
                    onUpdateQuantity: _updateQuantity,
                    onUpdateSelection: _updateItemSelection,
                    onProductTap:
                      _navigateToProductDetail,
                  );
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.all(24.w),
              child: ElevatedButton(
                child: Text('Buy Selected Items',
                    style: TextStyle(fontSize: 22.sp)),
                onPressed: _cartItems.any((item) => item['isSelected'] == true)
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

class CartItemTile extends StatelessWidget {
  final Map<String, dynamic> item;
  final Function(String, String) onRemove;
  final Function(String, String, int) onUpdateQuantity;
  final Function(String, String, bool) onUpdateSelection;
  final Function(ProductModel) onProductTap;

  const CartItemTile({
    Key? key,
    required this.item,
    required this.onRemove,
    required this.onUpdateQuantity,
    required this.onUpdateSelection,
    required this.onProductTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 285.h,
      margin: EdgeInsets.symmetric(vertical: 12.h, horizontal: 18.w),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          GestureDetector(
         onTap: () => onProductTap(item['product']),
          child : Container(
            height: 285.h,
            width: 255.w,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: CachedNetworkImage(
              imageUrl: item['product'].imageUrls.isNotEmpty ? item['product'].imageUrls[0] : '',
              fit: BoxFit.cover,
              placeholder: (context, url) =>
                  Center(child: CircularProgressIndicator()),
              errorWidget: (context, url, error) => Icon(
                  Icons.image_not_supported,
                  size: 50.sp,
                  color: Colors.grey),
            ),
          ),
          ),
          SizedBox(width: 16.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                item['product'].name,
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
              Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.remove, size: 20.sp),
                    onPressed: () {
                      int newQuantity = item['quantity'] - 1;
                      if (newQuantity >= 1) {
                        onUpdateQuantity(
                            item['productId'], item['variation'], newQuantity);
                      }
                    },
                  ),
                  Text(item['quantity'].toString(),
                      style: TextStyle(fontSize: 20.sp)),
                  IconButton(
                    icon: Icon(Icons.add, size: 20.sp),
                    onPressed: () {
                      int newQuantity = item['quantity'] + 1;
                      onUpdateQuantity(
                          item['productId'], item['variation'], newQuantity);
                    },
                  ),
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () => onRemove(item['productId'], item['variation']),
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
                      onUpdateSelection(
                          item['productId'], item['variation'], value ?? false);
                    },
                  ),
                ],
              )
            ],
          ),
        ],
      ),
    );
  }
}
