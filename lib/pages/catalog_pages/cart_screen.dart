import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tnennt/helpers/color_utils.dart';
import 'package:tnennt/pages/catalog_pages/checkout_screen.dart';

class CartItem {
  final String productID;
  final String variation;
  int quantity;
  String? sku;
  String productName;
  String productImage;
  double productPrice;
  bool isSelected;

  CartItem({
    required this.productID,
    required this.variation,
    required this.quantity,
    this.sku,
    this.productName = '',
    this.productImage = '',
    this.productPrice = 0.0,
    this.isSelected = false,
  });

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      productID: json['productId'],
      variation: json['variation'],
      quantity: json['quantity'],
      sku: json['sku'],
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
        .asyncMap((snapshot) async {
      print("Got snapshot: ${snapshot.data()}");
      if (!snapshot.exists) {
        print("User document does not exist");
        return [];
      }

      List<dynamic> cartList = snapshot.data()?['cart'] ?? [];
      List<CartItem> items = cartList.map((item) => CartItem.fromJson(item)).toList();

      print("Parsed ${items.length} cart items");

      for (var item in items) {
        await fetchProductDetails(item);
      }

      return items;
    });
  }

  Future<void> fetchProductDetails(CartItem item) async {
    DocumentSnapshot productDoc = await FirebaseFirestore.instance
        .collection('products')
        .doc(item.productID)
        .get();

    if (productDoc.exists) {
      Map<String, dynamic> data = productDoc.data() as Map<String, dynamic>;

      if (data.containsKey('variations') && data['variations'] is Map) {
        Map<String, dynamic> variations = data['variations'];
        if (variations.containsKey(item.variation)) {
          Map<String, dynamic> variationData = variations[item.variation];

          item.productName = data['name'] ?? '';
          item.productImage = variationData['imageUrls'] ?? data['imageUrls'][0] ?? '';
          item.productPrice = (variationData['price'] ?? data['price'] ?? 0).toDouble();
          item.sku = variationData['sku'] ?? '';
        } else {
          item.productName = data['name'] ?? '';
          item.productImage = data['imageUrls'][0] ?? '';
          item.productPrice = (data['price'] ?? 0).toDouble();
        }
      } else {
        item.productName = data['name'] ?? '';
        item.productImage = data['imageUrls'][0] ?? '';
        item.productPrice = (data['price'] ?? 0).toDouble();
      }
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

  void handleItemSelection(String productId, bool isSelected) {
    setState(() {
      int index = cartItems.indexWhere((item) => item.productID == productId);
      if (index != -1) {
        cartItems[index].isSelected = isSelected;
        allItemsSelected = cartItems.every((item) => item.isSelected);
      }
    });
  }


  void navigateToCheckout() {
    List<Map<String, String>> selectedItems = cartItems
        .where((item) => item.isSelected)
        .map((item) => {
      'productId': item.productID,
      'variation': item.variation,
    })
        .toList();

    if (selectedItems.isNotEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CheckoutScreen(selectedItems: selectedItems),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select items to checkout')),
      );
    }
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
                              onChanged: (value) {
                                setState(() {
                                  allItemsSelected = value!;
                                  for (var item in cartItems) {
                                    item.isSelected = allItemsSelected;
                                  }
                                });
                                print("All items selected: $allItemsSelected"); // Add this line for debugging
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
                        selectedItem: cartItems[index].isSelected,
                        onRemove: removeFromCart,
                        onUpdateQuantity: updateQuantity,
                        onUpdatePrice: updatePrice,
                        onSelectItem: handleItemSelection,
                        showCheckbox: cartItems.length > 1,
                        onBuyNow: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CheckoutScreen(
                                selectedItems: [{
                                  'productId': cartItems[index].productID,
                                  'variation': cartItems[index].variation,
                                }],
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
                if (cartItems.length > 1)
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: ElevatedButton(
                      child: Text('Buy Selected Items'),
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
  final String id;
  final String productImage;
  final String productName;
  final double productPrice;
  final int quantity;
  final String variation;
  final bool selectedItem;
  final Function(String) onRemove;
  final Function(String, int) onUpdateQuantity;
  final Function(String, int, double) onUpdatePrice;
  final Function(String, bool) onSelectItem;
  final bool showCheckbox;
  final Function() onBuyNow;

  CartProductTile({
    required this.id,
    required this.productImage,
    required this.productName,
    required this.productPrice,
    required this.quantity,
    required this.variation,
    required this.onRemove,
    required this.onUpdateQuantity,
    required this.onUpdatePrice,
    required this.onSelectItem,
    required this.showCheckbox,
    required this.onBuyNow,
    this.selectedItem = false,
  });

  @override
  State<CartProductTile> createState() => _CartProductTileState();
}

class _CartProductTileState extends State<CartProductTile> {
  bool _isInWishlist = false;

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
        _isInWishlist = wishlist.contains(widget.id);
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
            if (!wishlist.contains(widget.id)) {
              wishlist.add(widget.id);
            }
          } else {
            wishlist.remove(widget.id);
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
                          widget.onUpdateQuantity(widget.id, newQuantity);
                          widget.onUpdatePrice(widget.id, newQuantity, widget.productPrice);
                        }
                      },
                    ),
                    Text(widget.quantity.toString()),
                    IconButton(
                      icon: Icon(Icons.add),
                      onPressed: () {
                        int newQuantity = widget.quantity + 1;
                        widget.onUpdateQuantity(widget.id, newQuantity);
                        widget.onUpdatePrice(widget.id, newQuantity, widget.productPrice);
                      },
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
                      onTap: widget.onBuyNow,
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
                    if (widget.showCheckbox) ...[
                      SizedBox(width: 8.0),
                      Checkbox(
                        checkColor: Colors.white,
                        activeColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          side: BorderSide(color: Colors.black),
                          borderRadius: BorderRadius.circular(4.0),
                        ),
                        value: widget.selectedItem,
                        onChanged: (value) {
                          widget.onSelectItem(widget.id, value ?? false);
                        },
                      ),
                    ],
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