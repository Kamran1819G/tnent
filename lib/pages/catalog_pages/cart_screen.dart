import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tnennt/helpers/color_utils.dart';
import 'package:tnennt/pages/catalog_pages/checkout_screen.dart';

class CartItem {
  final String productID;
  final String variation;
  int quantity;
  String productName;
  String productImage;
  double productPrice;
  double discount;
  double mrp;
  String sku;
  String storeId;

  CartItem({
    required this.productID,
    required this.variation,
    required this.quantity,
    this.productName = '',
    this.productImage = '',
    this.productPrice = 0.0,
    this.discount = 0.0,
    this.mrp = 0.0,
    this.sku = '',
    this.storeId = '',
  });

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      productID: json['productId'] ?? '',
      variation: json['variation'] ?? '',
      quantity: json['quantity'] ?? 0,
      productName: json['name'] ?? '',
      productImage: json['imageUrl'] ?? '',
      productPrice: (json['price'] ?? 0).toDouble(),
      discount: (json['discount'] ?? 0).toDouble(),
      mrp: (json['mrp'] ?? 0).toDouble(),
      sku: json['sku'] ?? '',
      storeId: json['storeId'] ?? '',
    );
  }
}

class CartScreen extends StatefulWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  bool allItemsSelected = false;
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
    print("Fetching cart items for user: $userId");

    return FirebaseFirestore.instance
        .collection('Users')
        .doc(userId)
        .snapshots()
        .map((snapshot) {
      print("Got snapshot: ${snapshot.data()}");
      if (!snapshot.exists) {
        print("User document does not exist");
        return [];
      }

      List<dynamic> cartList = snapshot.data()?['cart'] ?? [];
      print("Cart List: $cartList");
      List<CartItem> items = cartList.map((item) => CartItem.fromJson(item)).toList();

      print("Parsed ${items.length} cart items");
      return items;
    });
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

      List<dynamic> cartList = snapshot.get('cart') ?? [];
      cartList.removeWhere((item) => item['productId'] == productID);

      transaction.update(userRef, {'cart': cartList});

      setState(() {
        cartItems.removeWhere((item) => item.productID == productID);
        totalAmount = calculateTotalAmount(cartItems);
      });
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

      List<dynamic> cartList = snapshot.get('cart') ?? [];
      int index = cartList.indexWhere((item) => item['productId'] == productID);

      if (index != -1) {
        if (newQuantity > 0) {
          cartList[index]['quantity'] = newQuantity;
        } else {
          cartList.removeAt(index);
        }
      }

      transaction.update(userRef, {'cart': cartList});

      setState(() {
        int itemIndex = cartItems.indexWhere((item) => item.productID == productID);
        if (itemIndex != -1) {
          if (newQuantity > 0) {
            cartItems[itemIndex].quantity = newQuantity;
          } else {
            cartItems.removeAt(itemIndex);
          }
          totalAmount = calculateTotalAmount(cartItems);
        }
      });
    });
  }

  void updatePrice(String productId, int newQuantity, double price) {
    setState(() {
      int index = cartItems.indexWhere((item) => item.productID == productId);
      if (index != -1) {
        cartItems[index].quantity = newQuantity;
        totalAmount = calculateTotalAmount(cartItems);
      }
    });
  }

  void navigateToCheckout() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CheckoutScreen(),
      ),
    );
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
                            value: allItemsSelected,
                            onChanged: (value) {
                              setState(() {
                                allItemsSelected = value!;
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
                        item: cartItems[index],
                        selectedItem: allItemsSelected,
                        onRemove: removeFromCart,
                        onUpdateQuantity: updateQuantity,
                        onUpdatePrice: updatePrice,
                      );
                    },
                  ),
                ),
                if (allItemsSelected)
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: ElevatedButton(
                      child: Text('Buy All Selected Items'),
                      onPressed: navigateToCheckout,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: hexToColor('#343434'),
                        foregroundColor: Colors.white,
                        minimumSize: Size(double.infinity, 50),
                      ),
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
  final CartItem item;
  final bool selectedItem;
  final Function(String) onRemove;
  final Function(String, int) onUpdateQuantity;
  final Function(String, int, double) onUpdatePrice;

  CartProductTile({
    required this.item,
    required this.onRemove,
    required this.onUpdateQuantity,
    required this.onUpdatePrice,
    this.selectedItem = false,
  });

  @override
  State<CartProductTile> createState() => _CartProductTileState();
}

class _CartProductTileState extends State<CartProductTile> {
  bool _isInWishlist = false;
  bool _isSelected = false;

  @override
  void initState() {
    super.initState();
    _checkIfInWishlist();
  }

  void _checkIfInWishlist() async {
    String userId = FirebaseAuth.instance.currentUser?.uid ?? '';
    DocumentSnapshot userDoc = await FirebaseFirestore.instance
        .collection('Users')
        .doc(userId)
        .get();

    if (userDoc.exists) {
      String wishlistString = userDoc.get('wishlist') ?? '';
      List<String> wishlist = wishlistString.split(',').where((item) => item.isNotEmpty).toList();
      setState(() {
        _isInWishlist = wishlist.contains(widget.item.productID);
      });
    }
  }

  void _toggleWishlist() async {
    setState(() {
      _isInWishlist = !_isInWishlist;
    });

    String userId = FirebaseAuth.instance.currentUser?.uid ?? '';
    DocumentReference userRef = FirebaseFirestore.instance.collection('Users').doc(userId);

    try {
      await FirebaseFirestore.instance.runTransaction((transaction) async {
        DocumentSnapshot snapshot = await transaction.get(userRef);
        if (snapshot.exists) {
          Map<String, dynamic> userData = snapshot.data() as Map<String, dynamic>;
          String wishlistString = userData['wishlist'] ?? '';
          List<String> wishlist = wishlistString.split(',').where((item) => item.isNotEmpty).toList();

          if (_isInWishlist) {
            if (!wishlist.contains(widget.item.productID)) {
              wishlist.add(widget.item.productID);
            }
          } else {
            wishlist.remove(widget.item.productID);
          }

          String updatedWishlistString = wishlist.join(',');
          transaction.update(userRef, {'wishlist': updatedWishlistString});
        }
      });
    } catch (e) {
      print('Error updating wishlist: $e');
      setState(() {
        _isInWishlist = !_isInWishlist;
      });
    }
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
            image: NetworkImage(widget.item.productImage),
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
    widget.item.productName,
    style: TextStyle(
    color: hexToColor('#343434'),
    fontSize: 20.0,
    ),
    ),
    SizedBox(height: 8.0),
    Text(
    'Variation: ${widget.item.variation}',
    style: TextStyle(
    color: hexToColor('#989898'),
    fontSize: 14.0,
    ),
    ),
    SizedBox(height: 8.0),
    Text(
    'SKU: ${widget.item.sku}',
    style: TextStyle(
    color: hexToColor('#989898'),
    fontSize: 14.0,
    ),
    ),
      SizedBox(height: 25.0),
      Row(
        children: [
          Text(
            '₹${widget.item.productPrice.toStringAsFixed(2)}',
            style: TextStyle(
              color: hexToColor('#343434'),
              fontSize: 20.0,
            ),
          ),
          SizedBox(width: 10),
          Text(
            '₹${widget.item.mrp.toStringAsFixed(2)}',
            style: TextStyle(
              color: hexToColor('#989898'),
              fontSize: 16.0,
              decoration: TextDecoration.lineThrough,
            ),
          ),
        ],
      ),
      SizedBox(height: 8.0),
      Text(
        'Discount: ${widget.item.discount.toStringAsFixed(2)}%',
        style: TextStyle(
          color: hexToColor('#4CAF50'),
          fontSize: 14.0,
        ),
      ),
      SizedBox(height: 15.0),
      Row(
        children: [
          IconButton(
            icon: Icon(Icons.remove),
            onPressed: () {
              int newQuantity = widget.item.quantity - 1;
              if (newQuantity >= 0) {
                widget.onUpdateQuantity(widget.item.productID, newQuantity);
                widget.onUpdatePrice(widget.item.productID, newQuantity, widget.item.productPrice);
              }
            },
          ),
          Text(widget.item.quantity.toString()),
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              int newQuantity = widget.item.quantity + 1;
              widget.onUpdateQuantity(widget.item.productID, newQuantity);
              widget.onUpdatePrice(widget.item.productID, newQuantity, widget.item.productPrice);
            },
          ),
        ],
      ),
      SizedBox(height: 15.0),
      Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () => widget.onRemove(widget.item.productID),
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