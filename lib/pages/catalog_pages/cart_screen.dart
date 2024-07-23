import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tnennt/helpers/color_utils.dart';
import 'package:tnennt/pages/catalog_pages/checkout_screen.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  bool allItemsSelected = false;
  List<Map<String, dynamic>> cartItems = [];
  double totalAmount = 0.0;

  @override
  void initState() {
    super.initState();
  }

  String getCurrentUserId() {
    return FirebaseAuth.instance.currentUser?.uid ?? '';
  }

  Stream<List<Map<String, dynamic>>> fetchCartItems() {
    String userId = getCurrentUserId();
    print("Fetching cart items for user: $userId");

    return FirebaseFirestore.instance
        .collection('Users')
        .doc(userId)
        .snapshots()
        .asyncMap((snapshot) async {
      print("Got snapshot: ${snapshot.data()}");
      if (!snapshot.exists) {
        print("User document does not exist");
        return [];
      }

      List<dynamic> cartList = snapshot.data()?['cart'] ?? [];
      List<Map<String, dynamic>> items = [];

      for (var item in cartList) {
        Map<String, dynamic> cartItem = Map<String, dynamic>.from(item);
        await fetchProductDetails(cartItem);
        cartItem['isSelected'] = false;
        items.add(cartItem);
      }

      print("Parsed ${items.length} cart items");
      return items;
    });
  }

  Future<void> fetchProductDetails(Map<String, dynamic> item) async {
    DocumentSnapshot productDoc = await FirebaseFirestore.instance
        .collection('products')
        .doc(item['productId'])
        .get();

    if (productDoc.exists) {
      Map<String, dynamic> data = productDoc.data() as Map<String, dynamic>;

      item['productName'] = data['name'] ?? '';
      item['productImage'] = data['imageUrls'][0] ?? '';

      if (data.containsKey('variations') && data['variations'] is Map) {
        Map<String, dynamic> variations = data['variations'];

        if (variations.containsKey(item['variation'])) {
          Map<String, dynamic> variationData = variations[item['variation']];
          item['productImage'] = variationData['image'] ?? item['productImage'];
          item['productPrice'] = (variationData['price'] ?? 0).toDouble();
          item['sku'] = variationData['sku'] ?? '';
        } else {
          item['productPrice'] = (data['price'] ?? 0).toDouble();
        }
      } else {
        item['productPrice'] = (data['price'] ?? 0).toDouble();
      }
    }
  }

  double calculateTotalAmount(List<Map<String, dynamic>> items) {
    return items.where((item) => item['isSelected']).fold(
        0, (sum, item) => sum + (item['productPrice'] * item['quantity']));
  }

  Future<void> removeFromCart(String productId, String variation) async {
    String userId = getCurrentUserId();
    DocumentReference userRef =
        FirebaseFirestore.instance.collection('Users').doc(userId);

    return FirebaseFirestore.instance.runTransaction((transaction) async {
      DocumentSnapshot snapshot = await transaction.get(userRef);
      if (!snapshot.exists) {
        throw Exception("User does not exist!");
      }

      List<dynamic> cartList = snapshot.get('cart') ?? [];
      cartList.removeWhere((item) =>
          item['productId'] == productId &&
          item['variation'] == variation);

      transaction.update(userRef, {'cart': cartList});

      setState(() {
        cartItems.removeWhere((item) =>
            item['productId'] == productId &&
            item['variation'] == variation);
        totalAmount = calculateTotalAmount(cartItems);
      });
    });
  }

  Future<void> updateQuantity(
      String productId, String variation, int newQuantity) async {
    String userId = getCurrentUserId();
    DocumentReference userRef =
        FirebaseFirestore.instance.collection('Users').doc(userId);

    return FirebaseFirestore.instance.runTransaction((transaction) async {
      DocumentSnapshot snapshot = await transaction.get(userRef);
      if (!snapshot.exists) {
        throw Exception("User does not exist!");
      }

      List<dynamic> cartList = snapshot.get('cart') ?? [];
      int index = cartList.indexWhere((item) =>
          item['productId'] == productId &&
          item['variation'] == variation);

      if (index != -1) {
        if (newQuantity > 0) {
          cartList[index]['quantity'] = newQuantity;
        } else {
          cartList.removeAt(index);
        }
      }

      transaction.update(userRef, {'cart': cartList});

      setState(() {
        int itemIndex = cartItems.indexWhere((item) =>
            item['productId'] == productId &&
            item['variation'] == variation);
        if (itemIndex != -1) {
          if (newQuantity > 0) {
            cartItems[itemIndex]['quantity'] = newQuantity;
          } else {
            cartItems.removeAt(itemIndex);
          }
          totalAmount = calculateTotalAmount(cartItems);
        }
      });
    });
  }

  void navigateToCheckout() {
    List<Map<String, dynamic>> selectedItems =
    cartItems.where((item) => item['isSelected']).toList();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CheckoutScreen(selectedItems: selectedItems),
      ),
    );
  }

  void updateItemSelection(
      String productId, String variation, bool isSelected) {
    setState(() {
      int index = cartItems.indexWhere((item) =>
      item['productId'] == productId &&
          item['variation'] == variation);
      if (index != -1) {
        cartItems[index]['isSelected'] = isSelected;
        totalAmount = calculateTotalAmount(cartItems);
      }
      allItemsSelected = cartItems.every((item) => item['isSelected']);
    });
  }

  void toggleAllItemsSelection(bool? value) {
    setState(() {
      allItemsSelected = value ?? false;
      for (var item in cartItems) {
        item['isSelected'] = allItemsSelected;
      }
      totalAmount = calculateTotalAmount(cartItems);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: StreamBuilder<List<Map<String, dynamic>>>(
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
                              '₹ ${totalAmount.toStringAsFixed(2)}',
                              style: TextStyle(
                                color: hexToColor('#A9A9A9'),
                                fontSize: 18.0,
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (cartItems.length > 1)
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
                            onChanged: toggleAllItemsSelection,
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
                      final item = cartItems[index];
                      return CartProductTile(
                        productId: item['productId'],
                        productImage: item['productImage'],
                        productName: item['productName'],
                        productPrice: item['productPrice'],
                        quantity: item['quantity'],
                        variation: item['variation'],
                        isSelected: item['isSelected'],
                        onRemove: removeFromCart,
                        onUpdateQuantity: updateQuantity,
                        onUpdateSelection: updateItemSelection,
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ElevatedButton(
                    child: Text('Buy Selected Items'),
                    onPressed: cartItems.any((item) => item['isSelected'])
                        ? navigateToCheckout
                        : null,
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
  final String productId;
  final String productImage;
  final String productName;
  final double productPrice;
  final int quantity;
  final String variation;
  final bool isSelected;
  final Function(String, String) onRemove;
  final Function(String, String, int) onUpdateQuantity;
  final Function(String, String, bool) onUpdateSelection;

  CartProductTile({
    required this.productId,
    required this.productImage,
    required this.productName,
    required this.productPrice,
    required this.quantity,
    required this.variation,
    required this.isSelected,
    required this.onRemove,
    required this.onUpdateQuantity,
    required this.onUpdateSelection,
  });

  @override
  State<CartProductTile> createState() => _CartProductTileState();
}

class _CartProductTileState extends State<CartProductTile> {
  bool _isInWishlist = false;
  late bool _isSelected;
  late Map<String, dynamic> _wishlistItem;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    _isSelected = widget.isSelected;
    _checkWishlistStatus();
  }

  @override
  void didUpdateWidget(CartProductTile oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isSelected != widget.isSelected) {
      setState(() {
        _isSelected = widget.isSelected;
      });
    }
  }

  void _checkWishlistStatus() async {
    User? user = _auth.currentUser;
    if (user != null) {
      DocumentSnapshot userDoc = await _firestore.collection('Users').doc(user.uid).get();
      if (userDoc.exists) {
        List<dynamic> wishlist = (userDoc.data() as Map<String, dynamic>)['wishlist'] ?? [];
        setState(() {
          _isInWishlist = wishlist.any((item) =>
          item['productId'] == widget.productId &&
              item['variation'] == widget.variation
          );
        });
      }
    }
  }


  Future<void> _toggleWishlist() async {
    User? user = _auth.currentUser;
    if (user == null) {
      print('User is not logged in');
      return;
    }

    setState(() {
      _isInWishlist = !_isInWishlist;
    });

    try {
      DocumentReference userDocRef = _firestore.collection('Users').doc(user.uid);
      Map<String, dynamic> wishlistItem = {
        'productId': widget.productId,
        'variation': widget.variation,
      };

      if (_isInWishlist) {
        await userDocRef.update({
          'wishlist': FieldValue.arrayUnion([wishlistItem])
        });
        print('Added to wishlist: $wishlistItem');
      } else {
        await userDocRef.update({
          'wishlist': FieldValue.arrayRemove([wishlistItem])
        });
        print('Removed from wishlist: $wishlistItem');
      }
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
          Expanded(
            child: Column(
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
                      onPressed: () {
                        int newQuantity = widget.quantity - 1;
                        if (newQuantity >= 0) {
                          widget.onUpdateQuantity(widget.productId,
                              widget.variation, newQuantity);
                        }
                      },
                    ),
                    Text(widget.quantity.toString()),
                    IconButton(
                      icon: Icon(Icons.add),
                      onPressed: () {
                        int newQuantity = widget.quantity + 1;
                        widget.onUpdateQuantity(
                            widget.productId, widget.variation, newQuantity);
                      },
                    ),
                  ],
                ),
                SizedBox(height: 15.0),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () => widget.onRemove(
                          widget.productId, widget.variation),
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
                        builder: (context) => CheckoutScreen(selectedItems: [
                          {
                            'productId': widget.productId,
                            'productName': widget.productName,
                            'productPrice': widget.productPrice,
                            'quantity': widget.quantity,
                            'variation': widget.variation,
                          }
                        ]),
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
                      value: _isSelected,
                      onChanged: (value) {
                        setState(() {
                          _isSelected = value ?? false;
                        });
                        widget.onUpdateSelection(widget.productId, widget.variation, _isSelected);
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
