import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tnennt/helpers/color_utils.dart';
import 'package:tnennt/models/product_model.dart';
import 'package:tnennt/pages/catalog_pages/checkout_screen.dart';

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
          Map<String, dynamic> productDetails = await _fetchProductDetails(item['productId']);
          updatedCartItems.add({
            ...item,
            ...productDetails,
            'variationDetails': productDetails['variations'][item['variation']],
            'isSelected': false, // Add a selection state for each item
          });
        }

        setState(() {
          _cartItems = updatedCartItems;
          _updateSelectionState();
        });
      }
    });
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
      'storeId': product.storeId,
      'productImage': product.imageUrls.isNotEmpty ? product.imageUrls[0] : '',
      'variations': product.variations,
    };
  }

  void _updateSelectionState() {
    _allItemsSelected = _cartItems.isNotEmpty && _cartItems.every((item) => item['isSelected'] == true);
    _calculateTotalAmount();
  }

  void _calculateTotalAmount() {
    _totalAmount = _cartItems
        .where((item) => item['isSelected'] == true)
        .fold(0, (sum, item) => sum + (item['variationDetails'].price * item['quantity']));
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

  void _updateFirestore() {
    String userId = FirebaseAuth.instance.currentUser?.uid ?? '';
    List<Map<String, dynamic>> cartData = _cartItems.map((item) => {
      'productId': item['productId'],
      'quantity': item['quantity'],
      'variation': item['variation'],
    }).toList();

    FirebaseFirestore.instance
        .collection('Users')
        .doc(userId)
        .update({'cart': cartData});
  }

  void _removeFromCart(String productId, String variation) {
    setState(() {
      _cartItems.removeWhere((item) =>
      item['productId'] == productId && item['variation'] == variation);
      _updateSelectionState();
    });
    _updateFirestore();
  }

  void _updateQuantity(String productId, String variation, int newQuantity) {
    setState(() {
      int index = _cartItems.indexWhere((item) =>
      item['productId'] == productId && item['variation'] == variation);
      if (index != -1) {
        if (newQuantity > 0) {
          _cartItems[index]['quantity'] = newQuantity;
        } else {
          _cartItems.removeAt(index);
        }
        _updateSelectionState();
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
              height: 100,
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  Row(
                    children: [
                      Text(
                        'Cart'.toUpperCase(),
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
                    ],
                  ),
                  Spacer(),
                  Container(
                    margin: EdgeInsets.all(8.0),
                    child: CircleAvatar(
                      backgroundColor: Colors.grey[100],
                      child: IconButton(
                        icon: Icon(Icons.arrow_back_ios_new,
                            color: Colors.black),
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
              height: 75,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 4.0),
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
                          '₹ ${_totalAmount.toStringAsFixed(2)}',
                          style: TextStyle(
                            color: hexToColor('#A9A9A9'),
                            fontSize: 18.0,
                          ),
                        ),
                      ],
                    ),
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
                          value: _allItemsSelected,
                          onChanged: _toggleAllItemsSelection,
                        ),
                      ],
                    ),
                ],
              ),
            ),
            SizedBox(height: 16.0),
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: 8.0),
                itemCount: _cartItems.length,
                itemBuilder: (context, index) {
                  final item = _cartItems[index];
                  return CartItemTile(
                    item: item,
                    onRemove: _removeFromCart,
                    onUpdateQuantity: _updateQuantity,
                    onUpdateSelection: _updateItemSelection,
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                child: Text('Buy Selected Items'),
                onPressed: _cartItems.any((item) => item['isSelected'] == true)
                    ? _navigateToCheckout
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: hexToColor('#343434'),
                  foregroundColor: Colors.white,
                  minimumSize: Size(double.infinity, 50),
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

  const CartItemTile({
    Key? key,
    required this.item,
    required this.onRemove,
    required this.onUpdateQuantity,
    required this.onUpdateSelection,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 6.0, vertical: 14.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            height: 190,
            width: 150,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4.0),
              image: DecorationImage(
                image: NetworkImage(item['productImage']),
                fit: BoxFit.fill,
              ),
            ),
          ),
          SizedBox(width: 12.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
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
                  'Variation: ${item['variation']}',
                  style: TextStyle(
                    color: hexToColor('#989898'),
                    fontSize: 14.0,
                  ),
                ),
                SizedBox(height: 25.0),
                Text(
                  '₹${item['variationDetails'].price.toStringAsFixed(2)}',
                  style: TextStyle(
                    color: hexToColor('#343434'),
                    fontSize: 20.0,
                  ),
                ),
                SizedBox(height: 15.0),
                Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.remove),
                      onPressed: () {
                        int newQuantity = item['quantity'] - 1;
                        if (newQuantity >= 0) {
                          onUpdateQuantity(
                              item['productId'], item['variation'], newQuantity);
                        }
                      },
                    ),
                    Text(item['quantity'].toString()),
                    IconButton(
                      icon: Icon(Icons.add),
                      onPressed: () {
                        int newQuantity = item['quantity'] + 1;
                        onUpdateQuantity(
                            item['productId'], item['variation'], newQuantity);
                      },
                    ),
                  ],
                ),
                SizedBox(height: 15.0),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () => onRemove(item['productId'], item['variation']),
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 12.0, vertical: 8.0),
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
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                CheckoutScreen(selectedItems: [item]),
                          ),
                        );
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 12.0, vertical: 8.0),
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
                    SizedBox(width: 8.0),
                    Checkbox(
                      checkColor: Colors.black,
                      activeColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        side: BorderSide(color: Colors.black),
                        borderRadius: BorderRadius.circular(4.0),
                      ),
                      value: item['isSelected'] ?? false,
                      onChanged: (value) {
                        onUpdateSelection(item['productId'], item['variation'], value ?? false);
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
