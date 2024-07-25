import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:share_plus/share_plus.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:tnennt/helpers/color_utils.dart';
import 'package:tnennt/helpers/text_utils.dart';
import 'package:tnennt/models/product_model.dart';
import 'package:tnennt/models/store_model.dart';
import 'package:tnennt/pages/catalog_pages/checkout_screen.dart';
import 'package:tnennt/screens/users_screens/storeprofile_screen.dart';
import 'package:tnennt/widgets/wishlist_product_tile.dart';
import 'package:tnennt/pages/catalog_pages/cart_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:convert';

class ProductDetailScreen extends StatefulWidget {
  ProductModel product;

  ProductDetailScreen({
    required this.product,
  });

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  PageController imagesController = PageController(viewportFraction: 0.6);
  late ProductModel _product;
  late String _selectedVariation;
  late ProductVariant _selectedVariant;
  bool _isInWishlist = false;
  late Map<String, dynamic> _wishlistItem;
  late Future<StoreModel> _storeFuture;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String _flagImage = 'assets/grey-flag.png';

  List<ProductModel> relatedProducts = List.generate(5, (index) {
    return ProductModel(
      productId: 'product123',
      storeId: 'EBJgGaWsnrluCKcaOUOT',
      name: 'Premium Cotton T-Shirt',
      description: 'A high-quality, comfortable cotton t-shirt',
      productCategory: 'T-Shirts',
      storeCategory: 'Apparel',
      imageUrls: [
        'https://via.placeholder.com/150',
        'https://via.placeholder.com/150',
        'https://via.placeholder.com/150',
      ],
      isAvailable: true,
      createdAt: Timestamp.now(),
      greenFlags: 0,
      redFlags: 0,
      variations: {
          'S': ProductVariant(
            price: 24.99,
            mrp: 29.99,
            discount: 16.67,
            stockQuantity: 50,
            sku: 'TS-S',
          ),
          'M': ProductVariant(
            price: 24.99,
            mrp: 29.99,
            discount: 16.67,
            stockQuantity: 100,
            sku: 'TS-M',
          ),
          'L': ProductVariant(
            price: 26.99,
            mrp: 31.99,
            discount: 15.63,
            stockQuantity: 75,
            sku: 'TS-L',
          ),
      },
    );
  });


  @override
  void initState() {
    super.initState();
    _product = widget.product;
    _storeFuture = _fetchStore();
    _initializeSelectedVariation();
    _checkWishlistStatus();
    _checkUserVote();
  }


  Future<StoreModel> _fetchStore() async {
    DocumentSnapshot storeDoc = await FirebaseFirestore.instance
        .collection('Stores')
        .doc(widget.product.storeId)
        .get();
    return StoreModel.fromFirestore(storeDoc);
  }

  void _initializeSelectedVariation() {
    if (widget.product.variations.isNotEmpty) {
      _selectedVariation = widget.product.variations.keys.first;
      _selectedVariant = widget.product.variations[_selectedVariation]!;
      _wishlistItem = {
        'productId': widget.product.productId,
        'variation': _selectedVariation,
      };
    }
  }

  void navigateToCheckout() {
    Map<String, dynamic> item = {
      'productId': widget.product.productId,
      'productImage': widget.product.imageUrls.first,
      'storeId': widget.product.storeId,
      'productName': widget.product.name,
      'variation': _selectedVariation,
      'quantity': 1,
      'variationDetails': _selectedVariant
    };

    if (_selectedVariant.stockQuantity > 0) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CheckoutScreen(selectedItems: [item]),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Unable to proceed to checkout')),
      );
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
          item['productId'] == _wishlistItem['productId'] &&
              item['variation'] == _wishlistItem['variation']);
        });
      }
    }
  }

  Future<void> _toggleWishlist() async {
    User? user = _auth.currentUser;
    if (user == null) {
      // Handle the case when the user is not logged in
      print('User is not logged in');
      return;
    }

    setState(() {
      _isInWishlist = !_isInWishlist;
    });

    try {
      DocumentReference userDocRef = _firestore.collection('Users').doc(user.uid);

      if (_isInWishlist) {
        // Add product to wishlist
        await userDocRef.update({
          'wishlist': FieldValue.arrayUnion([_wishlistItem])
        });
        print('Added to wishlist: $_wishlistItem');
      } else {
        // Remove product from wishlist
        await userDocRef.update({
          'wishlist': FieldValue.arrayRemove([_wishlistItem])
        });
        print('Removed from wishlist: $_wishlistItem');
      }
    } catch (e) {
      print('Error updating wishlist: $e');
      // Revert the UI state if the operation failed
      setState(() {
        _isInWishlist = !_isInWishlist;
      });
    }
  }

  Future<void> _checkUserVote() async {
    User? user = _auth.currentUser;
    if (user != null) {
      DocumentSnapshot voteDoc = await _firestore
          .collection('Users')
          .doc(user.uid)
          .collection('votes')
          .doc(_product.productId)
          .get();

      if (voteDoc.exists) {
        Map<String, dynamic> voteData = voteDoc.data() as Map<String, dynamic>;
        setState(() {
          if (voteData['greenFlag'] == true) {
            _flagImage = 'assets/green-flag.png';
          } else if (voteData['redFlag'] == true) {
            _flagImage = 'assets/red-flag.png';
          }
        });
      }
    }
  }

  Future<void> handleVote(String voteType) async {
    User? user = _auth.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please log in to vote')),
      );
      return;
    }

    String userId = user.uid;
    String productId = _product.productId;

    DocumentReference userVoteRef = _firestore.collection('Users').doc(userId).collection('votes').doc(productId);
    DocumentReference productRef = _firestore.collection('products').doc(productId);

    try {
      await _firestore.runTransaction((transaction) async {
        DocumentSnapshot voteDoc = await transaction.get(userVoteRef);
        DocumentSnapshot productDoc = await transaction.get(productRef);

        if (!productDoc.exists) {
          throw Exception('Product does not exist');
        }

        Map<String, dynamic> productData = productDoc.data() as Map<String, dynamic>;
        int greenFlags = productData['greenFlags'] ?? 0;
        int redFlags = productData['redFlags'] ?? 0;

        if (voteDoc.exists) {
          Map<String, dynamic> previousVote = voteDoc.data() as Map<String, dynamic>;

          if (previousVote['greenFlag'] && voteType == 'greenFlag') {
            greenFlags--;
            transaction.delete(userVoteRef);
            _flagImage = 'assets/grey-flag.png';
          } else if (previousVote['redFlag'] && voteType == 'redFlag') {
            redFlags--;
            transaction.delete(userVoteRef);
            _flagImage = 'assets/grey-flag.png';
          } else {
            if (previousVote['greenFlag']) {
              greenFlags--;
            } else if (previousVote['redFlag']) {
              redFlags--;
            }

            if (voteType == 'greenFlag') {
              greenFlags++;
              _flagImage = 'assets/green-flag.png';
            } else {
              redFlags++;
              _flagImage = 'assets/red-flag.png';
            }

            transaction.set(userVoteRef, {
              'greenFlag': voteType == 'greenFlag',
              'redFlag': voteType == 'redFlag'
            });
          }
        } else {
          if (voteType == 'greenFlag') {
            greenFlags++;
            _flagImage = 'assets/green-flag.png';
          } else {
            redFlags++;
            _flagImage = 'assets/red-flag.png';
          }

          transaction.set(userVoteRef, {
            'greenFlag': voteType == 'greenFlag',
            'redFlag': voteType == 'redFlag'
          });
        }

        transaction.update(productRef, {
          'greenFlags': greenFlags,
          'redFlags': redFlags,
        });

        // Update the local product state
        setState(() {
          _product = _product.copyWith(greenFlags: greenFlags, redFlags: redFlags);
        });
      });

      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Vote recorded successfully')),
      );
    } catch (error) {
      print('Error recording vote: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to record vote. Please try again.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: FutureBuilder<StoreModel>(
            future: _storeFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                print('Error: ${snapshot.error}');
                return Center(child: Text('Error: ${snapshot.error}'));
              }
              if (!snapshot.hasData) {
                return Center(child: Text('No store data available'));
              }
              final store = snapshot.data!;
              return Stack(children: [
                SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 100,
                        padding: EdgeInsets.symmetric(horizontal: 16.0),
                        child: Row(
                          children: [
                            Row(
                              children: [
                                Text(
                                  'Product'.toUpperCase(),
                                  style: TextStyle(
                                    color: hexToColor('#1E1E1E'),
                                    fontSize: 24.0,
                                    letterSpacing: 1.5,
                                  ),
                                ),
                                Text(
                                  ' •',
                                  style: TextStyle(
                                    fontSize: 28.0,
                                    color: hexToColor('#FF0000'),
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
                      Column(
                        children: [
                          Container(
                            height: 300,
                            child: ListView.builder(
                              controller: imagesController,
                              scrollDirection: Axis.horizontal,
                              itemCount: widget.product.imageUrls.length,
                              itemBuilder: (context, index) {
                                return Container(
                                  margin: EdgeInsets.symmetric(horizontal: 8),
                                  width: 300,
                                  height: 300,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: Image.network(
                                      widget.product.imageUrls[index],
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                          SizedBox(height: 10),
                          Container(
                            height: 20,
                            child: SmoothPageIndicator(
                              controller: imagesController,
                              count: widget.product.imageUrls.length,
                              onDotClicked: (index) {
                                imagesController.animateToPage(
                                  index,
                                  duration: Duration(milliseconds: 500),
                                  curve: Curves.ease,
                                );
                              },
                              effect: ScrollingDotsEffect(
                                dotColor: hexToColor('#BEBEBE'),
                                activeDotColor: hexToColor('#343434'),
                                dotHeight: 8,
                                dotWidth: 8,
                                spacing: 10,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: (){
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => StoreProfileScreen(store: store),
                                ),
                              );
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(left: 16.0),
                              child: Row(
                                children: [
                                  Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Image.network(
                                        store.logoUrl,
                                        width: 30,
                                        height: 30,
                                      )),
                                  SizedBox(width: 8),
                                  Text(
                                    store.name,
                                    style: TextStyle(
                                      color: hexToColor('#9C9C9C'),
                                      fontSize: 14,
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: Row(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    showModalBottomSheet(
                                      backgroundColor: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(12),
                                          topRight: Radius.circular(12),
                                        ),
                                      ),
                                      context: context,
                                      builder: (context) =>
                                          _buildMoreBottomSheet(),
                                    );
                                  },
                                  child: CircleAvatar(
                                    backgroundColor: hexToColor('#F5F5F5'),
                                    child: Icon(
                                      Icons.more_horiz,
                                      color: hexToColor('#BEBEBE'),
                                      size: 20,
                                    ),
                                  ),
                                ),
                                SizedBox(width: 8),
                                GestureDetector(
                                  onTap: () {
                                    showModalBottomSheet(
                                      backgroundColor: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(12),
                                          topRight: Radius.circular(12),
                                        ),
                                      ),
                                      context: context,
                                      builder: (context) =>
                                          _buildRatingBottomSheet(),
                                    );
                                  },
                                  child: CircleAvatar(
                                    backgroundColor: hexToColor('#F5F5F5'),
                                    child: Image.asset(
                                      _flagImage,
                                      width: 18,
                                      height: 18,
                                    ),
                                  ),
                                ),
                                SizedBox(width: 8),
                                GestureDetector(
                                  onTap: () async {
                                    await Share.share(
                                      'Check out this product from ${store.name} ! -> https://tnennt.store ',
                                    );
                                  },
                                  child: CircleAvatar(
                                    backgroundColor: hexToColor('#F5F5F5'),
                                    child: Icon(
                                      Icons.ios_share_outlined,
                                      color: hexToColor('#BEBEBE'),
                                      size: 20,
                                    ),
                                  ),
                                ),
                                SizedBox(width: 8),
                                GestureDetector(
                                  onTap: _toggleWishlist,
                                  child: CircleAvatar(
                                    backgroundColor: hexToColor('#F5F5F5'),
                                    child: Icon(
                                      _isInWishlist
                                          ? Icons.favorite
                                          : Icons.favorite_border,
                                      color: _isInWishlist
                                          ? Colors.red
                                          : Colors.grey,
                                      size: 20,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 30),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.product.name,
                              style: TextStyle(
                                color: hexToColor('#343434'),
                                fontSize: 20,
                              ),
                            ),
                            SizedBox(height: 20),
                            _buildVariationSelector(),
                            SizedBox(height: 20),
                            Container(
                              padding: EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: hexToColor('#F5F5F5'),
                                borderRadius: BorderRadius.circular(18),
                              ),
                              child: Row(
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Text(
                                            '₹${_selectedVariant.price.toStringAsFixed(2)}',
                                            style: TextStyle(
                                              color: hexToColor('#343434'),
                                              fontSize: 28,
                                            ),
                                          ),
                                          SizedBox(width: 10),
                                          Text(
                                            '${_selectedVariant.discount}% Off',
                                            style: TextStyle(
                                              color: hexToColor('#FF0000'),
                                              fontSize: 16,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Text(
                                        'M.R.P ₹${_selectedVariant.mrp.toStringAsFixed(2)}',
                                        style: TextStyle(
                                          color: hexToColor('#B9B9B9'),
                                          fontSize: 16,
                                          decoration:
                                              TextDecoration.lineThrough,
                                          decorationColor:
                                              hexToColor('#B9B9B9'),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Spacer(),
                                  GestureDetector(
                                    onTap: () async {
                                      String userId = FirebaseAuth.instance.currentUser?.uid ?? '';
                                      if (userId.isEmpty) {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(content: Text('Please log in to add items to cart')),
                                        );
                                        return;
                                      }

                                      DocumentReference userRef = FirebaseFirestore.instance
                                          .collection('Users')
                                          .doc(userId);

                                      try {
                                        await FirebaseFirestore.instance.runTransaction((transaction) async {
                                          DocumentSnapshot snapshot = await transaction.get(userRef);
                                          if (!snapshot.exists) {
                                            throw Exception("User does not exist!");
                                          }

                                          Map<String, dynamic> userData = snapshot.data() as Map<String, dynamic>;
                                          List<dynamic> cartList = userData['cart'] ?? [];

                                          Map<String, dynamic> cartItem = {
                                            'productId': widget.product.productId,
                                            'variation': _selectedVariation,
                                            'quantity': 1, // Default quantity
                                          };

                                          int existingIndex = cartList.indexWhere((item) =>
                                          item['productId'] == widget.product.productId &&
                                              item['variation'] == _selectedVariation
                                          );

                                          if (existingIndex != -1) {
                                            cartList[existingIndex]['quantity'] += 1;
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              SnackBar(content: Text('Item already in cart')),
                                            );
                                          } else {
                                            cartList.add(cartItem);
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              SnackBar(content: Text('Item added to cart')),
                                            );
                                          }

                                          transaction.update(userRef, {'cart': cartList});
                                        });
                                      } catch (e) {
                                        print('Error updating cart: $e');
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(content: Text('Failed to update cart. Please try again.')),
                                        );
                                      }
                                    },
                                    child: Container(
                                      padding: EdgeInsets.all(16),
                                      decoration: BoxDecoration(
                                        color: Theme.of(context).primaryColor,
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Icon(Icons.add_shopping_cart, color: Colors.white, size: 25),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 40),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  'Description',
                                  style: TextStyle(
                                    color: hexToColor('#1E1E1E'),
                                    fontSize: 20.0,
                                  ),
                                ),
                                Text(
                                  ' •',
                                  style: TextStyle(
                                    fontSize: 20.0,
                                    color: hexToColor('#FF0000'),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 10),
                            Text(
                              widget.product.description,
                              style: TextStyle(
                                color: hexToColor('#9C9C9C'),
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 40),
                      // Related Products
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 16.0),
                            child: Row(
                              children: [
                                Text(
                                  'Related Products',
                                  style: TextStyle(
                                    color: hexToColor('#1E1E1E'),
                                    fontSize: 20.0,
                                  ),
                                ),
                                Text(
                                  ' •',
                                  style: TextStyle(
                                    fontSize: 20.0,
                                    color: hexToColor('#FF0000'),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 10),
                          Container(
                            margin: EdgeInsets.only(left: 8.0),
                            height: 200,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: relatedProducts.length,
                              itemBuilder: (context, index) {
                                return WishlistProductTile(
                                  product: relatedProducts[index],
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 40),
                      // Reviews
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 16.0),
                            child: Row(
                              children: [
                                Text(
                                  'Reviews',
                                  style: TextStyle(
                                    color: hexToColor('#1E1E1E'),
                                    fontSize: 20.0,
                                  ),
                                ),
                                Text(
                                  ' •',
                                  style: TextStyle(
                                    fontSize: 20.0,
                                    color: hexToColor('#FF0000'),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 10),
                          Container(
                            margin: EdgeInsets.symmetric(horizontal: 16),
                            padding: EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            decoration: BoxDecoration(
                              color: hexToColor('#F5F5F5'),
                              borderRadius: BorderRadius.circular(50),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Image.asset(
                                  'assets/black_tnennt_logo.png',
                                  width: 25,
                                  height: 25,
                                ),
                                SizedBox(width: 20),
                                Expanded(
                                  child: TextField(
                                    decoration: InputDecoration(
                                      constraints: BoxConstraints(
                                        maxHeight: 100,
                                      ),
                                      hintText: 'Add your review',
                                      hintStyle: TextStyle(
                                        color: hexToColor('#9C9C9C'),
                                        fontSize: 16,
                                        fontFamily: 'Gotham',
                                        fontWeight: FontWeight.w600,
                                      ),
                                      suffixIcon: Icon(
                                        Icons.send,
                                        color: Theme.of(context).primaryColor,
                                      ),
                                      border: InputBorder.none,
                                      focusedBorder: InputBorder.none,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            child: Row(
                              children: [

                              ],
                            ),
                          ),
                          SizedBox(height: 20),
                        ],
                      ),
                      SizedBox(height: 75),
                    ],
                  ),
                ),
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    color: Colors.white,
                    child: ElevatedButton(
                      onPressed: () {
                        navigateToCheckout();
                      },
                      child: Text(
                        'Buy Now',
                        style: TextStyle(fontSize: 18),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: hexToColor('#343434'),
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(vertical: 15,),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                ),
              ]);
            }),
      ),
    );
  }

  Widget _buildVariationSelector() {
    return Wrap(
      spacing: 8.0,
      runSpacing: 8.0,
      children: widget.product.variations.keys.map((variation) {
        return ChoiceChip(
          padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
          ),
          label: Text(variation,
          style: TextStyle(
            color: _selectedVariation == variation ? Colors.white : Colors.black,
          ),
          ),
          backgroundColor: Colors.white,
          selected: _selectedVariation == variation,
          showCheckmark: false,
          selectedColor: Theme.of(context).primaryColor,
          onSelected: (selected) {
            if (selected) {
              setState(() {
                _selectedVariation = variation;
                _selectedVariant = widget.product.variations[variation]!;
                _wishlistItem = {
                  'productId': widget.product.productId,
                  'variation': variation,
                };
                _checkWishlistStatus(); // Check wishlist status when variation changes
              });
            }
          },
        );
      }).toList(),
    );
  }


  _buildMoreBottomSheet() {
    return Container(
      height: 250,
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 100,
              height: 4,
              margin: const EdgeInsets.symmetric(vertical: 15),
              decoration: BoxDecoration(
                color: hexToColor('#CACACA'),
                borderRadius: BorderRadius.circular(5),
              ),
            ),
          ),
          SizedBox(height: 50),
          CircleAvatar(
            backgroundColor: hexToColor('#2B2B2B'),
            child: Icon(
              Icons.report_gmailerrorred,
              color: hexToColor('#BEBEBE'),
              size: 20,
            ),
          ),
          SizedBox(height: 20),
          Text(
            'Report',
            style: TextStyle(
              color: hexToColor('#9B9B9B'),
              fontSize: 16.0,
            ),
          ),
        ],
      ),
    );
  }

  _buildRatingBottomSheet() {
    return Container(
      height: 275,
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 100,
              height: 4,
              margin: const EdgeInsets.symmetric(vertical: 15),
              decoration: BoxDecoration(
                color: hexToColor('#CACACA'),
                borderRadius: BorderRadius.circular(5),
              ),
            ),
          ),
          SizedBox(height: 20),
          Row(
            children: [
              Text(
                'Add Your Rating',
                style: TextStyle(color: hexToColor('#343434'), fontSize: 16.0),
              ),
              Spacer(),
              CircleAvatar(
                radius: 15,
                backgroundColor: hexToColor('#F5F5F5'),
                child: Image.asset(
                  _flagImage,
                  width: 16,
                  height: 16,
                ),
              ),
              SizedBox(width: 4),
              Text(
                '${_product.greenFlags + _product.redFlags}',
                style: TextStyle(
                    color: Theme.of(context).primaryColor, fontSize: 16.0),
              ),
            ],
          ),
          SizedBox(height: 40),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                children: [
                  GestureDetector(
                    onTap: () async {
                      await handleVote('redFlag');
                      setState(() {}); // refresh UI
                    },
                    child: CircleAvatar(
                      radius: 30,
                      backgroundColor: hexToColor('#F5F5F5'),
                      child: Image.asset(
                        'assets/red-flag.png',
                        width: 30,
                        height: 30,
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    '${_product.redFlags}',
                    style:
                    TextStyle(color: hexToColor('#9C9C9C'), fontSize: 16.0),
                  ),
                ],
              ),
              SizedBox(width: 20),
              Column(
                children: [
                  GestureDetector(
                    onTap: () async {
                      await handleVote('greenFlag');
                  },
                    child: CircleAvatar(
                      radius: 30,
                      backgroundColor: hexToColor('#F5F5F5'),
                      child: Image.asset(
                        'assets/green-flag.png',
                        width: 30,
                        height: 30,
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    '${_product.greenFlags}',
                    style:
                    TextStyle(color: hexToColor('#9C9C9C'), fontSize: 16.0),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
