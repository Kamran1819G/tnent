import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:convert';
import 'package:tnennt/helpers/color_utils.dart';
import 'package:tnennt/pages/catalog_pages/checkout_screen.dart';

class CartItem {
  final String productID;
  final String variation;
  final int quantity;
  String productName;
  String productImage;
  double productPrice;

  CartItem({
    required this.productID,
    required this.variation,
    required this.quantity,
    this.productName = '',
    this.productImage = '',
    this.productPrice = 0.0,
  });

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      productID: json['productID'],
      variation: json['variation'],
      quantity: json['quantity'],
    );
  }
}

class CartScreen extends StatefulWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  bool selectedItems = false;
  List<CartItem> cartItems = [];
  double totalAmount = 0.0;

  @override
  void initState() {
    super.initState();
  }

  String getCurrentUserId() {
    return FirebaseAuth.instance.currentUser?.uid ?? '';
  }

  Stream<List<CartItem>> fetchCartItems() {
    String userId = getCurrentUserId();
    print("Fetching cart items for user: $userId"); // Add this

    return FirebaseFirestore.instance
        .collection('Users')
        .doc(userId)
        .snapshots()
        .asyncMap((snapshot) async {
      print("Got snapshot: ${snapshot.data()}"); // Add this
      if (!snapshot.exists) {
        print("User document does not exist"); // Add this
        return [];
      }

      String cartJson = snapshot.data()?['mycart'] ?? '[]';
      print("Cart JSON: $cartJson"); // Add this
      List<dynamic> cartList = json.decode(cartJson);
      List<CartItem> items = cartList.map((item) => CartItem.fromJson(item)).toList();

      print("Parsed ${items.length} cart items"); // Add this

      // Fetch product details for each item
      for (var item in items) {
        await fetchProductDetails(item);
      }

      return items;
    });
  }
  Future<void> fetchProductDetails(CartItem item) async {
    DocumentSnapshot productDoc = await FirebaseFirestore.instance
        .collection('Products')
        .doc(item.productID)
        .get();

    if (productDoc.exists) {
      Map<String, dynamic> data = productDoc.data() as Map<String, dynamic>;
      item.productName = data['name'] ?? '';
      item.productImage = data['image'] ?? '';
      item.productPrice = (data['price'] ?? 0).toDouble();
    }
  }

  double calculateTotalAmount(List<CartItem> items) {
    return items.fold(0, (sum, item) => sum + (item.productPrice * item.quantity));
  }

  Future<void> removeFromCart(String productID) async {
    String userId = getCurrentUserId();
    DocumentReference userRef = FirebaseFirestore.instance.collection('Users').doc(userId);

    return FirebaseFirestore.instance.runTransaction((transaction) async {
      DocumentSnapshot snapshot = await transaction.get(userRef);
      if (!snapshot.exists) {
        throw Exception("User does not exist!");
      }

      String cartJson = snapshot.get('mycart') ?? '[]';
      List<dynamic> cartList = json.decode(cartJson);
      cartList.removeWhere((item) => item['productID'] == productID);

      transaction.update(userRef, {'mycart': json.encode(cartList)});
    });
  }

  Future<void> updateQuantity(String productID, int newQuantity) async {
    String userId = getCurrentUserId();
    DocumentReference userRef = FirebaseFirestore.instance.collection('Users').doc(userId);

    return FirebaseFirestore.instance.runTransaction((transaction) async {
      DocumentSnapshot snapshot = await transaction.get(userRef);
      if (!snapshot.exists) {
        throw Exception("User does not exist!");
      }

      String cartJson = snapshot.get('mycart') ?? '[]';
      List<dynamic> cartList = json.decode(cartJson);
      int index = cartList.indexWhere((item) => item['productID'] == productID);

      if (index != -1) {
        if (newQuantity > 0) {
          cartList[index]['quantity'] = newQuantity;
        } else {
          cartList.removeAt(index);
        }
      }

      transaction.update(userRef, {'mycart': json.encode(cartList)});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: StreamBuilder<List<CartItem>>(
          stream: fetchCartItems(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }

            cartItems = snapshot.data ?? [];
            totalAmount = calculateTotalAmount(cartItems);

            return Column(
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
                              '₹ ${totalAmount.toStringAsFixed(2)}',
                              style: TextStyle(
                                color: hexToColor('#A9A9A9'),
                                fontSize: 18.0,
                              ),
                            ),
                          ],
                        ),
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
                  child: ListView.builder(
                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                    itemCount: cartItems.length,
                    itemBuilder: (context, index) {
                      return CartProductTile(
                        id: cartItems[index].productID,
                        productImage: cartItems[index].productImage,
                        productName: cartItems[index].productName,
                        productPrice: cartItems[index].productPrice,
                        quantity: cartItems[index].quantity,
                        variation: cartItems[index].variation,
                        selectedItem: selectedItems,
                        onRemove: removeFromCart,
                        onUpdateQuantity: updateQuantity,
                      );
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class CartProductTile extends StatefulWidget {
  final String id;
  final String productImage;
  final String productName;
  final double productPrice;
  final int quantity;
  final String variation;
  final bool selectedItem;
  final Function(String) onRemove;
  final Function(String, int) onUpdateQuantity;

  CartProductTile({
    required this.id,
    required this.productImage,
    required this.productName,
    required this.productPrice,
    required this.quantity,
    required this.variation,
    required this.onRemove,
    required this.onUpdateQuantity,
    this.selectedItem = false,
  });

  @override
  State<CartProductTile> createState() => _CartProductTileState();
}

class _CartProductTileState extends State<CartProductTile> {
  bool _isInWishlist = true;
  bool _isSelected = false;

  void _toggleWishlist() {
    setState(() {
      _isInWishlist = !_isInWishlist;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 6.0, vertical: 14.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Stack(
            children: [
              Container(
                height: 190,
                width: 150,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4.0),
                  image: DecorationImage(
                    image: NetworkImage(widget.productImage),
                    fit: BoxFit.fill,
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
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                widget.productName,
                style: TextStyle(
                  color: hexToColor('#343434'),
                  fontSize: 20.0,
                ),
              ),
              SizedBox(height: 8.0),
              Text(
                'Variation: ${widget.variation}',
                style: TextStyle(
                  color: hexToColor('#989898'),
                  fontSize: 14.0,
                ),
              ),
              SizedBox(height: 25.0),
              Text(
                '₹${widget.productPrice.toStringAsFixed(2)}',
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
                    onPressed: () => widget.onUpdateQuantity(widget.id, widget.quantity - 1),
                  ),
                  Text(widget.quantity.toString()),
                  IconButton(
                    icon: Icon(Icons.add),
                    onPressed: () => widget.onUpdateQuantity(widget.id, widget.quantity + 1),
                  ),
                ],
              ),
              SizedBox(height: 15.0),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () => widget.onRemove(widget.id),
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
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CheckoutScreen(),
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
                        'Buy Now',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12.0,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 8.0),
                  if (widget.selectedItem)
                    Checkbox(
                      checkColor: Colors.black,
                      activeColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        side: BorderSide(color: Colors.black),
                        borderRadius: BorderRadius.circular(4.0),
                      ),
                      overlayColor: MaterialStateProperty.all(Colors.black),
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
        ],
      ),
    );
  }
}