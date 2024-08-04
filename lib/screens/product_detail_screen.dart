import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:share_plus/share_plus.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:tnent/helpers/color_utils.dart';
import 'package:tnent/helpers/text_utils.dart';
import 'package:tnent/models/product_model.dart';
import 'package:tnent/models/store_model.dart';
import 'package:tnent/pages/catalog_pages/checkout_screen.dart';
import 'package:tnent/screens/users_screens/storeprofile_screen.dart';
import 'package:tnent/widgets/wishlist_product_tile.dart';
import 'package:tnent/pages/catalog_pages/cart_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

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

  final TextEditingController _reviewController = TextEditingController();
  List<Map<String, dynamic>> _reviews = [];

  @override
  void initState() {
    super.initState();
    _product = widget.product;
    _storeFuture = _fetchStore();
    _initializeSelectedVariation();
    _checkWishlistStatus();
    _checkUserVote();
    _loadReviews();
  }

  Future<void> _loadReviews() async {
    QuerySnapshot reviewsSnapshot = await FirebaseFirestore.instance
        .collection('Reviews')
        .where('productId', isEqualTo: widget.product.productId)
        .orderBy('timestamp', descending: true)
        .get();

    List<Map<String, dynamic>> reviews = [];

    for (var doc in reviewsSnapshot.docs) {
      Map<String, dynamic> reviewData = doc.data() as Map<String, dynamic>;
      String userId = reviewData['userId'];

      // Fetch user data from Users collection
      DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
          .collection('Users')
          .doc(userId)
          .get();

      if (userSnapshot.exists) {
        Map<String, dynamic> userData =
        userSnapshot.data() as Map<String, dynamic>;
        String firstName = userData['firstName'] ?? '';
        String lastName = userData['lastName'] ?? '';
        String photoURL = userData['photoURL'] ?? '';

        reviewData['userFullName'] = '$firstName $lastName'.trim();
        reviewData['photoURL'] = photoURL;
      } else {
        reviewData['userFullName'] = 'Anonymous';
        reviewData['photoURL'] = '';
      }

      reviews.add(reviewData);
    }

    setState(() {
      _reviews = reviews;
    });
  }

  Future<void> _addReview(String review) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please log in to add a review')),
      );
      return;
    }

    await FirebaseFirestore.instance.collection('Reviews').add({
      'productId': widget.product.productId,
      'storeId': widget.product.storeId,
      'content': review,
      'timestamp': FieldValue.serverTimestamp(),
      'userId': user.uid,
    });

    _reviewController.clear();
    await _loadReviews();
  }

  Widget _buildReviewsList() {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: _reviews.length,
      itemBuilder: (context, index) {
        final review = _reviews[index];
        return ListTile(
          leading: CircleAvatar(
            backgroundImage: review['photoURL'].isNotEmpty
                ? NetworkImage(review['photoURL'])
                : null,
            child: review['photoURL'].isEmpty ? Icon(Icons.person) : null,
          ),
          title: Text(
            review['userFullName'],
            overflow: TextOverflow.ellipsis,
          ),
          subtitle: Text(review['content']),
          trailing: Text(
            DateFormat('MMM d, yyyy').format(
              (review['timestamp'] as Timestamp).toDate(),
            ),
          ),
        );
      },
    );
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

  void _checkWishlistStatus() async {
    User? user = _auth.currentUser;
    if (user != null) {
      DocumentSnapshot userDoc =
      await _firestore.collection('Users').doc(user.uid).get();
      if (userDoc.exists) {
        List<dynamic> wishlist =
            (userDoc.data() as Map<String, dynamic>)['wishlist'] ?? [];
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
      DocumentReference userDocRef =
      _firestore.collection('Users').doc(user.uid);

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

    DocumentReference userVoteRef = _firestore
        .collection('Users')
        .doc(userId)
        .collection('votes')
        .doc(productId);
    DocumentReference productRef =
    _firestore.collection('products').doc(productId);

    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Vote recorded successfully')),
    );

    try {
      await _firestore.runTransaction((transaction) async {
        DocumentSnapshot voteDoc = await transaction.get(userVoteRef);
        DocumentSnapshot productDoc = await transaction.get(productRef);

        if (!productDoc.exists) {
          throw Exception('Product does not exist');
        }

        Map<String, dynamic> productData =
        productDoc.data() as Map<String, dynamic>;
        int greenFlags = productData['greenFlags'] ?? 0;
        int redFlags = productData['redFlags'] ?? 0;

        if (voteDoc.exists) {
          Map<String, dynamic> previousVote =
          voteDoc.data() as Map<String, dynamic>;

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
          _product =
              _product.copyWith(greenFlags: greenFlags, redFlags: redFlags);
        });
      });
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
                        height: 100.h,
                        margin: EdgeInsets.only(top: 20.h, bottom: 20.h),
                        padding: EdgeInsets.symmetric(horizontal: 24.w),
                        child: Row(
                          children: [
                            Row(
                              children: [
                                Text(
                                  'Product'.toUpperCase(),
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
                                    color: hexToColor('#FF0000'),
                                  ),
                                ),
                              ],
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
                      Column(
                        children: [
                          Container(
                            height: 495.h,
                            width: 620.w,
                            child: widget.product.imageUrls.length == 1
                                ? Center(
                              child: Container(
                                width: 445.w,
                                height: 490.h,
                                margin: EdgeInsets.symmetric(horizontal: 12.w),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8.r),
                                  child: Image.network(
                                    widget.product.imageUrls[0],
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            )
                                : ListView.builder(
                              controller: imagesController,
                              scrollDirection: Axis.horizontal,
                              itemCount: widget.product.imageUrls.length,
                              itemBuilder: (context, index) {
                                return Container(
                                  margin: EdgeInsets.symmetric(horizontal: 12.w),
                                  width: 445.w,
                                  height: 490.h,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(8.r),
                                    child: Image.network(
                                      widget.product.imageUrls[index],
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                          SizedBox(height: 30.h),
                          Container(
                            height: 30.h,
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
                      SizedBox(height: 30.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      StoreProfileScreen(store: store),
                                ),
                              );
                            },
                            child: Padding(
                              padding: EdgeInsets.only(left: 16.w),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(6.r),
                                      ),
                                      child: Image.network(
                                        store.logoUrl,
                                        width: 50.w,
                                        height: 50.h,
                                      )),
                                  SizedBox(width: 12.w),
                                  Text(
                                    store.name,
                                    style: TextStyle(
                                      color: hexToColor('#9C9C9C'),
                                      fontSize: 20.sp,
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.w600,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(right: 12.w),
                            child: Row(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    showModalBottomSheet(
                                      backgroundColor: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(16.r),
                                          topRight: Radius.circular(16.r),
                                        ),
                                      ),
                                      context: context,
                                      builder: (context) =>
                                          _buildMoreBottomSheet(),
                                    );
                                  },
                                  child: CircleAvatar(
                                    radius: 30.w,
                                    backgroundColor: hexToColor('#F5F5F5'),
                                    child: Icon(
                                      Icons.more_horiz,
                                      color: hexToColor('#BEBEBE'),
                                      size: 32.sp,
                                    ),
                                  ),
                                ),
                                SizedBox(width: 12.w),
                                GestureDetector(
                                  onTap: () {
                                    showModalBottomSheet(
                                      backgroundColor: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(16.r),
                                          topRight: Radius.circular(16.r),
                                        ),
                                      ),
                                      context: context,
                                      builder: (context) =>
                                          _buildRatingBottomSheet(),
                                    );
                                  },
                                  child: CircleAvatar(
                                    radius: 30.w,
                                    backgroundColor: hexToColor('#F5F5F5'),
                                    child: Image.asset(
                                      _flagImage,
                                      width: 24.w,
                                      height: 24.h,
                                    ),
                                  ),
                                ),
                                SizedBox(width: 12.w),
                                GestureDetector(
                                  onTap: () async {
                                    final String productUrl = 'https://tnent.com/product/${widget.product.productId}';
                                    final String shareMessage = 'Check out this product from ${store.name}! $productUrl';
                                    await Share.share(shareMessage);
                                  },
                                  child: CircleAvatar(
                                    radius: 30.w,
                                    backgroundColor: hexToColor('#F5F5F5'),
                                    child: Icon(
                                      Icons.ios_share_outlined,
                                      color: hexToColor('#BEBEBE'),
                                      size: 32.sp,
                                    ),
                                  ),
                                ),
                                SizedBox(width: 12.w),
                                GestureDetector(
                                  onTap: _toggleWishlist,
                                  child: CircleAvatar(
                                    radius: 30.w,
                                    backgroundColor: hexToColor('#F5F5F5'),
                                    child: Icon(
                                      _isInWishlist
                                          ? Icons.favorite
                                          : Icons.favorite_border,
                                      color: _isInWishlist
                                          ? Colors.red
                                          : Colors.grey,
                                      size: 32.sp,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 50.h),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 28.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.product.name,
                              style: TextStyle(
                                color: hexToColor('#343434'),
                                fontSize: 28.sp,
                              ),
                            ),
                            SizedBox(height: 30.h),
                            _buildVariationSelector(),
                            SizedBox(height: 30.h),
                            Container(
                              padding: EdgeInsets.all(18.w),
                              decoration: BoxDecoration(
                                color: hexToColor('#F5F5F5'),
                                borderRadius: BorderRadius.circular(28.r),
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
                                            '₹${_selectedVariant.price.toStringAsFixed(0)}',
                                            style: TextStyle(
                                              color: hexToColor('#343434'),
                                              fontSize: 50.sp,
                                            ),
                                          ),
                                          SizedBox(width: 10.w),
                                          if(_selectedVariant.discount > 0)
                                            Text(
                                              '${_selectedVariant.discount}% Off',
                                              style: TextStyle(
                                                color: hexToColor('#FF0000'),
                                                fontSize: 22.sp,
                                              ),
                                            ),
                                        ],
                                      ),
                                      Text(
                                        'M.R.P ₹${_selectedVariant.mrp.toStringAsFixed(2)}',
                                        style: TextStyle(
                                          color: hexToColor('#B9B9B9'),
                                          fontSize: 22.sp,
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
                                      if(_selectedVariant.stockQuantity > 0 && store.isActive) {
                                        String userId = FirebaseAuth
                                            .instance.currentUser?.uid ??
                                            '';
                                        if (userId.isEmpty) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                                content: Text(
                                                    'Please log in to add items to cart')),
                                          );
                                          return;
                                        }

                                        DocumentReference userRef =
                                        FirebaseFirestore.instance
                                            .collection('Users')
                                            .doc(userId);

                                        try {
                                          await FirebaseFirestore.instance
                                              .runTransaction(
                                                  (transaction) async {
                                                DocumentSnapshot snapshot =
                                                await transaction.get(userRef);
                                                if (!snapshot.exists) {
                                                  throw Exception(
                                                      "User does not exist!");
                                                }

                                                Map<String, dynamic> userData =
                                                snapshot.data()
                                                as Map<String, dynamic>;
                                                List<dynamic> cartList =
                                                    userData['cart'] ?? [];

                                                Map<String, dynamic> cartItem = {
                                                  'productId':
                                                  widget.product.productId,
                                                  'variation': _selectedVariation,
                                                  'quantity': 1,
                                                  // Default quantity
                                                };

                                                int existingIndex =
                                                cartList.indexWhere((item) =>
                                                item['productId'] ==
                                                    widget.product
                                                        .productId &&
                                                    item['variation'] ==
                                                        _selectedVariation);

                                                if (existingIndex != -1) {
                                                  cartList[existingIndex]
                                                  ['quantity'] += 1;
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(
                                                    SnackBar(
                                                        content: Text(
                                                            'Item already in cart')),
                                                  );
                                                } else {
                                                  cartList.add(cartItem);
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(
                                                    SnackBar(
                                                        content: Text(
                                                            'Item added to cart')),
                                                  );
                                                }

                                                transaction.update(
                                                    userRef, {'cart': cartList});
                                              });
                                        } catch (e) {
                                          print('Error updating cart: $e');
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                                content: Text(
                                                    'Failed to update cart. Please try again.')),
                                          );
                                        }
                                      }
                                      else{
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                              content: Text(
                                                  'Product is out of stock or store is inactive')),
                                        );
                                      }
                                    },
                                    child: Container(
                                      height: 95.h,
                                      width: 95.w,
                                      decoration: BoxDecoration(
                                        color: Theme.of(context).primaryColor,
                                        borderRadius: BorderRadius.circular(12.r),
                                      ),
                                      child: Icon(Icons.add_shopping_cart,
                                          color: Colors.white, size: 35.sp),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 50.h),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 28.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  'Description',
                                  style: TextStyle(
                                    color: hexToColor('#1E1E1E'),
                                    fontSize: 30.sp,
                                  ),
                                ),
                                Text(
                                  ' •',
                                  style: TextStyle(
                                    fontSize: 30.sp,
                                    color: hexToColor('#FF0000'),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 20.h),
                            Text(
                              widget.product.description,
                              style: TextStyle(
                                color: hexToColor('#9C9C9C'),
                                fontSize: 20.sp,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 50.h),
                      // Related Products
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 28.w),
                            child: Row(
                              children: [
                                Text(
                                  'Related Products',
                                  style: TextStyle(
                                    color: hexToColor('#1E1E1E'),
                                    fontSize: 30.sp,
                                  ),
                                ),
                                Text(
                                  ' •',
                                  style: TextStyle(
                                    fontSize: 30.sp,
                                    color: hexToColor('#FF0000'),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 20.h),
                          Container(
                            margin: EdgeInsets.only(left: 12.w),
                            height: 300.h,
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
                      SizedBox(height: 50.h),

                      // Reviews

                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 28.w),
                            child: Row(
                              children: [
                                Text(
                                  'Reviews',
                                  style: TextStyle(
                                    color: hexToColor('#1E1E1E'),
                                    fontSize: 30.sp,
                                  ),
                                ),
                                Text(
                                  ' •',
                                  style: TextStyle(
                                    fontSize: 30.sp,
                                    color: hexToColor('#FF0000'),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 20.h),
                          Container(
                            margin: EdgeInsets.symmetric(horizontal: 18.w),
                            padding: EdgeInsets.symmetric(
                                horizontal: 24.w, vertical: 12.h),
                            decoration: BoxDecoration(
                              color: hexToColor('#F5F5F5'),
                              borderRadius: BorderRadius.circular(50.r),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Image.asset(
                                  'assets/black_tnent_logo.png',
                                  width: 40.w,
                                  height: 40.h,
                                ),
                                SizedBox(width: 30.w),
                                Expanded(
                                  child: TextField(
                                    controller: _reviewController,
                                    style: TextStyle(
                                      color: hexToColor('#343434'),
                                      fontSize: 24.sp,
                                      fontFamily: 'Gotham',
                                      fontWeight: FontWeight.w600,
                                    ),
                                    decoration: InputDecoration(
                                      hintText: 'Add your review',
                                      hintStyle: TextStyle(
                                        color: hexToColor('#9C9C9C'),
                                        fontSize: 24.sp,
                                        fontFamily: 'Gotham',
                                        fontWeight: FontWeight.w600,
                                      ),
                                      border: InputBorder.none,
                                      focusedBorder: InputBorder.none,
                                    ),
                                  ),
                                ),
                                IconButton(
                                  icon: Icon(Icons.send,
                                      color: Theme.of(context).primaryColor),
                                  onPressed: () {
                                    if (_reviewController.text.isNotEmpty) {
                                      _addReview(_reviewController.text);
                                    }
                                  },
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 30.h),
                          _buildReviewsList(),
                        ],
                      ),
                      SizedBox(height: 100.h),
                    ],
                  ),
                ),
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: Container(
                    padding:
                    EdgeInsets.symmetric(horizontal: 22.w, vertical: 12.h),
                    color: Colors.white,
                    child: ElevatedButton(
                      onPressed: () {
                        Map<String, dynamic> item = {
                          'productId': widget.product.productId,
                          'productImage': widget.product.imageUrls.first,
                          'storeId': widget.product.storeId,
                          'productName': widget.product.name,
                          'variation': _selectedVariation,
                          'quantity': 1,
                          'variationDetails': _selectedVariant
                        };

                        if (_selectedVariant.stockQuantity > 0 && store.isActive) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CheckoutScreen(selectedItems: [item]),
                            ),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Product is out of stock or store is inactive')),
                          );
                        }
                      },
                      child: Text(
                        'Buy Now',
                        style: TextStyle(fontSize: 28.sp),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: hexToColor('#343434'),
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(
                          vertical: 22.h,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16.r),
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
    List<String> variations = widget.product.variations.keys.where((variation) => variation.toLowerCase() != 'default').toList();

    if (variations.isEmpty) {
      return SizedBox.shrink(); // Don't show any chips if only default variation exists
    }
    return Wrap(
      spacing: 8.0,
      runSpacing: 8.0,
      children: widget.product.variations.keys.map((variation) {
        return ChoiceChip(
          padding: EdgeInsets.symmetric(horizontal: 22.w, vertical: 0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.r),
          ),
          label: Text(
            variation,
            style: TextStyle(
              color:
              _selectedVariation == variation ? Colors.white : Colors.black,
              fontSize: 18.sp,
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
      height: 350.h,
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 150.w,
              height: 6.h,
              margin: EdgeInsets.symmetric(vertical: 18.h),
              decoration: BoxDecoration(
                color: hexToColor('#CACACA'),
                borderRadius: BorderRadius.circular(50.r),
              ),
            ),
          ),
          SizedBox(height: 75.h),
          CircleAvatar(
            backgroundColor: hexToColor('#2B2B2B'),
            child: Icon(
              Icons.report_gmailerrorred,
              color: hexToColor('#BEBEBE'),
              size: 28.sp,
            ),
          ),
          SizedBox(height: 30.h),
          Text(
            'Report',
            style: TextStyle(
              color: hexToColor('#9B9B9B'),
              fontSize: 23.sp,
            ),
          ),
        ],
      ),
    );
  }

  _buildRatingBottomSheet() {
    return Container(
      height: 450.h,
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 18.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 150.w,
              height: 8.h,
              margin: EdgeInsets.symmetric(vertical: 18.h),
              decoration: BoxDecoration(
                color: hexToColor('#CACACA'),
                borderRadius: BorderRadius.circular(50.r),
              ),
            ),
          ),
          SizedBox(height: 30.h),
          Row(
            children: [
              Text(
                'Add Your Rating',
                style: TextStyle(color: hexToColor('#343434'), fontSize: 24.sp),
              ),
              Spacer(),
              CircleAvatar(
                radius: 22.w,
                backgroundColor: hexToColor('#F5F5F5'),
                child: Image.asset(
                  _flagImage,
                  width: 20.w,
                  height: 20.h,
                ),
              ),
              SizedBox(width: 12.w),
              Text(
                '${_product.greenFlags + _product.redFlags}',
                style: TextStyle(
                    color: Theme.of(context).primaryColor, fontSize: 23.sp),
              ),
            ],
          ),
          SizedBox(height: 50.h),
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
                      radius: 50.w,
                      backgroundColor: hexToColor('#F5F5F5'),
                      child: Image.asset(
                        'assets/red-flag.png',
                        width: 50.w,
                        height: 50.h,
                      ),
                    ),
                  ),
                  SizedBox(height: 20.h),
                  Text(
                    '${_product.redFlags}',
                    style:
                    TextStyle(color: hexToColor('#9C9C9C'), fontSize: 24.sp),
                  ),
                ],
              ),
              SizedBox(width: 30.w),
              Column(
                children: [
                  GestureDetector(
                    onTap: () async {
                      await handleVote('greenFlag');
                    },
                    child: CircleAvatar(
                      radius: 50.w,
                      backgroundColor: hexToColor('#F5F5F5'),
                      child: Image.asset(
                        'assets/green-flag.png',
                        width: 50.w,
                        height: 50.h,
                      ),
                    ),
                  ),
                  SizedBox(height: 20.h),
                  Text(
                    '${_product.greenFlags}',
                    style:
                    TextStyle(color: hexToColor('#9C9C9C'), fontSize: 24.sp),
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