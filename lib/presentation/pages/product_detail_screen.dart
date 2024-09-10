import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shimmer/shimmer.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:tnent/core/helpers/color_utils.dart';
import 'package:tnent/models/product_model.dart';
import 'package:tnent/models/store_model.dart';
import 'package:tnent/presentation/pages/catalog_pages/checkout_screen.dart';
import 'package:tnent/presentation/pages/related_products_service.dart';
import 'package:tnent/presentation/pages/users_screens/storeprofile_screen.dart';
import 'package:tnent/presentation/widgets/wishlist_product_tile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import '../../core/helpers/report_helper.dart';
import '../../core/helpers/snackbar_utils.dart';
import 'geofencing.dart';

class ProductDetailScreen extends StatefulWidget {
  ProductModel product;

  ProductDetailScreen({
    super.key,
    required this.product,
  });

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  PageController imagesController = PageController(viewportFraction: 1);
  late ProductModel _product;
  late String _selectedVariation;
  late ProductVariant _selectedVariant;
  bool _isInWishlist = false;
  late Map<String, dynamic> _wishlistItem;
  late Future<StoreModel> _storeFuture;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String _flagImage = 'assets/grey-flag.png';
  bool _isCurrentStoreOwner = false;
  List<ProductModel> relatedProducts = [];
  final TextEditingController _reviewController = TextEditingController();
  List<Map<String, dynamic>> _reviews = [];
  bool _isInAllowedArea = false;

  @override
  void initState() {
    super.initState();
    _product = widget.product;
    _storeFuture = _fetchStore();
    _initializeSelectedVariation();
    _checkWishlistStatus();
    _checkUserVote();
    _loadReviews();
    _prefetchImages();
    _loadRelatedProducts();
    _checkIfCurrentStoreOwner();
    _checkUserLocation();
  }

  Future<void> _checkUserLocation() async {
    bool isAllowed = await GeofencingService.isUserInAllowedArea();
    setState(() {
      _isInAllowedArea = isAllowed;
    });
    if (!isAllowed) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showNotAvailableSnackBar();
      });
    }
  }

  void _showNotAvailableSnackBar() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'service not available in your location',
          style: TextStyle(color: Colors.white, fontSize: 16.sp),
        ),
        backgroundColor: Colors.red,
        duration: Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).size.height - 100,
          right: 20,
          left: 20,
        ),
      ),
    );
  }


  Future<void> _checkIfCurrentStoreOwner() async {
    User? user = _auth.currentUser;
    if (user != null) {
      DocumentSnapshot userDoc =
          await _firestore.collection('Users').doc(user.uid).get();
      if (userDoc.exists) {
        Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;
        String? userStoreId = userData['storeId'] as String?;
        setState(() {
          _isCurrentStoreOwner =
              userStoreId != null && userStoreId == widget.product.storeId;
        });
      }
    }
  }

  Future<void> _prefetchImages() async {
    for (String url in widget.product.imageUrls) {
      await DefaultCacheManager().downloadFile(url);
    }
  }

  Future<void> _loadRelatedProducts() async {
    List<ProductModel> fetchedRelatedProducts =
        await RelatedProductsService.fetchRelatedProducts(widget.product);

    if (fetchedRelatedProducts.isEmpty) {
      // If no related products, fetch random products
      fetchedRelatedProducts = await RelatedProductsService.fetchRandomProducts(
          5); // Fetch 5 random products
    }

    setState(() {
      relatedProducts = fetchedRelatedProducts;
    });
  }

  static Future<List<ProductModel>> fetchRandomProducts(int count) async {
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('products')
          .where('isActive', isEqualTo: true)
          .limit(count)
          .get();

      return snapshot.docs
          .map((doc) => ProductModel.fromFirestore(doc))
          .toList();
    } catch (e) {
      print('Error fetching random products: $e');
      return [];
    }
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
        const SnackBar(content: Text('Please log in to add a review')),
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
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _reviews.length,
      itemBuilder: (context, index) {
        final review = _reviews[index];
        return ListTile(
          leading: CircleAvatar(
            backgroundImage: review['photoURL'].isNotEmpty
                ? NetworkImage(review['photoURL'])
                : null,
            child: review['photoURL'].isEmpty ? const Icon(Icons.person) : null,
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
        const SnackBar(content: Text('Please log in to vote')),
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
      const SnackBar(content: Text('Vote recorded successfully')),
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
        const SnackBar(
            content: Text('Failed to record vote. Please try again.')),
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
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                print('Error: ${snapshot.error}');
                return Center(child: Text('Error: ${snapshot.error}'));
              }
              if (!snapshot.hasData) {
                return const Center(child: Text('No store data available'));
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
                            const Spacer(),
                            IconButton(
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(
                                  Colors.grey[100],
                                ),
                                shape: MaterialStateProperty.all(
                                  const CircleBorder(),
                                ),
                              ),
                              icon: const Icon(Icons.arrow_back_ios_new,
                                  color: Colors.black),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            height: 495.h,
                            width: 1.sw,
                            child: PageView.builder(
                              controller: imagesController,
                              scrollDirection: Axis.horizontal,
                              itemCount: widget.product.imageUrls.length,
                              itemBuilder: (context, index) {
                                return Container(
                                  height: 490.h,
                                  width: 1.sw,
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 12.w),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(8.r),
                                    child: CachedNetworkImage(
                                      imageUrl: widget.product.imageUrls[index],
                                      cacheManager: DefaultCacheManager(),
                                      placeholder: (context, url) =>
                                          Shimmer.fromColors(
                                        baseColor: hexToColor('#E0E0E0'),
                                        highlightColor: hexToColor('#F5F5F5'),
                                        child: Container(color: Colors.white),
                                      ),
                                      errorWidget: (context, url, error) =>
                                          Icon(Icons.error),
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
                                  duration: const Duration(milliseconds: 500),
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
                                      fit: BoxFit.cover,
                                    ),
                                  ),
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
                                // Share button - available for all users
                                GestureDetector(
                                  onTap: () async {
                                    final String productUrl =
                                        'https://tnentstore.com/?productId=${widget.product.productId}';
                                    final String shareMessage =
                                        'Check out this product from ${store.name}! $productUrl';
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
                                // Conditional buttons for non-store owners
                                if (!_isCurrentStoreOwner) ...[
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
                                          if (_selectedVariant.discount > 0)
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
                                              _selectedVariant.discount > 0
                                                  ? TextDecoration.lineThrough
                                                  : TextDecoration.none,
                                          decorationColor:
                                              hexToColor('#B9B9B9'),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const Spacer(),
                                  GestureDetector(
                                    onTap: () async {
                                      if(!_isInAllowedArea)
                                        {
                                          _showNotAvailableSnackBar();
                                        return;
                                        }

                                      if (_selectedVariant.stockQuantity <= 0 || !store.isActive) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                              content: Text(
                                                  'Product is out of stock or store is inactive')),
                                        );
                                        return;
                                      }

                                      if (_selectedVariant.stockQuantity > 0 &&
                                          store.isActive) {
                                        String userId = FirebaseAuth
                                                .instance.currentUser?.uid ??
                                            '';
                                        if (userId.isEmpty) {
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            const SnackBar(content: Text('Please log in to add items to cart'))
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
                                              showSnackBar(context,
                                                  'Item already in cart');
                                            } else {
                                              cartList.add(cartItem);
                                              showSnackBar(context,
                                                  'Item added to cart');
                                            }

                                            transaction.update(
                                                userRef, {'cart': cartList});
                                          });
                                        } catch (e) {
                                          print('Error updating cart: $e');
                                          showSnackBar(context,
                                              'Failed to update cart. Please try again.');
                                        }
                                      }
                                    },
                                    child: Container(
                                      height: 95.h,
                                      width: 95.w,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black.withOpacity(
                                                0.1), // Shadow color with some transparency
                                            spreadRadius:
                                                4, // Set to 0 for no spread
                                            blurRadius:
                                                6, // Blur radius of the shadow
                                            offset: const Offset(0,
                                                3), // Only offset in the Y direction for bottom shadow
                                          ),
                                        ],
                                        borderRadius:
                                            BorderRadius.circular(12.r),
                                      ),
                                      child: Icon(
                                          Icons.add_shopping_cart,
                                          color: Colors.black,
                                          size: 35.sp
                                      ),
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
                            height: 340.h,
                            padding: const EdgeInsets.only(left: 8.0),
                            child: relatedProducts.isEmpty
                                ? ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: 5, // Show 3 placeholder items
                                    itemBuilder: (context, index) {
                                      return Shimmer.fromColors(
                                        baseColor: hexToColor('#E0E0E0'),
                                        highlightColor: hexToColor('#F5F5F5'),
                                        child: Container(
                                          width: 200.w,
                                          margin: EdgeInsets.only(right: 12.w),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(12.r),
                                          ),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                height: 150.h,
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.only(
                                                    topLeft:
                                                        Radius.circular(12.r),
                                                    topRight:
                                                        Radius.circular(12.r),
                                                  ),
                                                ),
                                              ),
                                              SizedBox(height: 10.h),
                                              Container(
                                                margin: EdgeInsets.symmetric(
                                                    horizontal: 10.w),
                                                height: 20.h,
                                                width: 150.w,
                                                color: Colors.white,
                                              ),
                                              SizedBox(height: 5.h),
                                              Container(
                                                margin: EdgeInsets.symmetric(
                                                    horizontal: 10.w),
                                                height: 15.h,
                                                width: 100.w,
                                                color: Colors.white,
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  )
                                : ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: relatedProducts.length,
                                    itemBuilder: (context, index) {
                                      return WishlistProductTile(
                                        product: relatedProducts[index],
                                      );
                                    },
                                  ),
                          ),
                          SizedBox(height: 20.h),
                        ],
                      ),
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
                      onPressed: (_isInAllowedArea &&
                          _selectedVariant.stockQuantity > 0 &&
                          store.isActive)
                          ? () {
                        Map<String, dynamic> item = {
                          'productId': widget.product.productId,
                          'productImage': widget.product.imageUrls.first,
                          'storeId': widget.product.storeId,
                          'productName': widget.product.name,
                          'variation': _selectedVariation,
                          'quantity': 1,
                          'variationDetails': _selectedVariant
                        };

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  CheckoutScreen(selectedItems: [item]),
                            ),
                          );
                        }
                        : ()
                      {
                          if(!_isInAllowedArea) {
                            _showNotAvailableSnackBar();
                          }
                          else if (_selectedVariant.stockQuantity <= 0 ||!store.isActive) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text(
                                    'Product is out of stock or store is inactive')),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: hexToColor('#343434'),
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(
                          vertical: 22.h,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(60.r),
                        ),
                      ),
                      child: Text(
                        'Buy Now',
                        style: TextStyle(fontSize: 28.sp),
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
    List<String> variations = widget.product.variations.keys
        .where((variation) => variation.toLowerCase() != 'default')
        .toList();

    if (variations.isEmpty) {
      return const SizedBox
          .shrink(); // Don't show any chips if only default variation exists
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
          onSelected: _isInAllowedArea
            ? (selected) {
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
          }
          : null,
        );
      }).toList(),
    );
  }

  _buildMoreBottomSheet() {
    return Container(
      height: 250,
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: _reportProduct,
            child: CircleAvatar(
              backgroundColor: hexToColor('#2B2B2B'),
              child: Icon(
                Icons.report_gmailerrorred,
                color: hexToColor('#BEBEBE'),
                size: 20,
              ),
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

  Future<void> _reportProduct() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      showSnackBar(context, 'You must be logged in to report a product.');
      return;
    }

    final reportReason = await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return const ReportHelperWidget();
      },
    );

    if (reportReason == null) {
      return;
    }
    try {
      await ProductModel.reportProduct(
        widget.product.productId,
        widget.product.storeId,
        reportReason,
        user.uid,
      );
    } catch (e) {
      showSnackBar(context, 'Error reporting product: $e');
    }
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
              const Spacer(),
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
          if (!_isCurrentStoreOwner) ...[
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
                      style: TextStyle(
                          color: hexToColor('#9C9C9C'), fontSize: 24.sp),
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
                      style: TextStyle(
                          color: hexToColor('#9C9C9C'), fontSize: 24.sp),
                    ),
                  ],
                ),
              ],
            ),
          ] else ...[
            Center(
              child: Text(
                'Rating options are not available for store owners.',
                style: TextStyle(color: hexToColor('#9C9C9C'), fontSize: 20.sp),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
