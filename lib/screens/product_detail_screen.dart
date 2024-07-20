import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:share_plus/share_plus.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:tnennt/helpers/color_utils.dart';
import 'package:tnennt/models/product_model.dart';
import 'package:tnennt/models/store_model.dart';
import 'package:tnennt/pages/catalog_pages/checkout_screen.dart';
import 'package:tnennt/widgets/product_tile.dart';
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
  String _selectedProductSize = 'S';
  bool _isInWishlist = false;
  late Future<StoreModel> _storeFuture;

  List<dynamic> relatedProducts = List.generate(5, (index) {
    return ProductModel(
      id: '1',
      storeId: '1',
      name: 'Product Name',
      description: 'Product Description',
      productCategory: 'Product Category',
      storeCategory: 'Store Category',
      imageUrls: ['https://via.placeholder.com/150'],
      badReviews: 0,
      goodReviews: 0,
      isAvailable: true,
      variantOptions: {},
      variants: List.generate(3, (index) {
        return ProductVariant(
          id: '1',
          price: 100,
          mrp: 120,
          discount: 20,
          stockQuantity: 100,
        );
      }), createdAt: Timestamp.now(),
    );
  });


  @override
  void initState() {
    super.initState();
    _storeFuture = _fetchStore();
  }

  Future<StoreModel> _fetchStore() async {
    DocumentSnapshot storeDoc = await FirebaseFirestore.instance
        .collection('Stores')
        .doc(widget.product.storeId)
        .get();
    return StoreModel.fromFirestore(storeDoc);
  }

  void _toggleWishlist() {
    setState(() {
      _isInWishlist = !_isInWishlist;
    });

    // Send wishlist request to the server
    if (_isInWishlist) {
      // Code to send wishlist request to the server
      print('Adding to wishlist...');
    } else {
      // Code to remove from wishlist request to the server
      print('Removing from wishlist...');
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
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: Image.network(
                                      widget.product.imageUrls[index],
                                      width: 200,
                                      height: 300,
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
                          Padding(
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
                                      'assets/grey-flag.png',
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
                            Container(
                              child: GridView.count(
                                physics: NeverScrollableScrollPhysics(),
                                crossAxisCount: 4,
                                crossAxisSpacing: 10,
                                mainAxisSpacing: 10,
                                childAspectRatio: 2.5 / 1.0,
                                shrinkWrap: true,
                                children: [
                                  _buildSizeWidget('XS'),
                                  _buildSizeWidget('S'),
                                  _buildSizeWidget('M'),
                                  _buildSizeWidget('L'),
                                  _buildSizeWidget('XL'),
                                  _buildSizeWidget('XXL'),
                                ],
                              ),
                            ),
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
                                            '\$${widget.product.variants[0].price}',
                                            style: TextStyle(
                                              color: hexToColor('#343434'),
                                              fontSize: 28,
                                            ),
                                          ),
                                          SizedBox(width: 10),
                                          Text(
                                            '${widget.product.variants[0].discount}% Discount',
                                            style: TextStyle(
                                              color: hexToColor('#FF0000'),
                                              fontSize: 16,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Text(
                                        'M.R.P \$${widget.product.variants[0].mrp}',
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
                                  Container(
                                    padding: EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      color: Theme.of(context).primaryColor,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: GestureDetector(
                                      onTap: () async {
                                        // Add the product to the cart
                                        String userId = FirebaseAuth
                                                .instance.currentUser?.uid ??
                                            '';
                                        DocumentReference userRef =
                                            FirebaseFirestore.instance
                                                .collection('Users')
                                                .doc(userId);

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
                                          List<dynamic> cartList = [];

                                          if (userData.containsKey('mycart')) {
                                            String cartJson =
                                                userData['mycart'] ?? '[]';
                                            cartList = json.decode(cartJson);
                                          }

                                          // Check if the product is already in the cart
                                          int existingIndex =
                                              cartList.indexWhere((item) =>
                                                  item['productID'] ==
                                                  widget.product.name);

                                          if (existingIndex != -1) {
                                            // If the product is already in the cart, increase the quantity
                                            cartList[existingIndex]
                                                ['quantity'] += 1;
                                          } else {
                                            // If the product is not in the cart, add it with all necessary information
                                            cartList.add({
                                              'productID': widget.product.id,
                                              'productName':
                                                  widget.product.name,
                                              'productPrice': widget
                                                  .product.variants[0].price,
                                              'discount': widget
                                                  .product.variants[0].discount,
                                              'variation': _selectedProductSize,
                                              'quantity': 1,
                                              // You might want to add the first image from the images list
                                              'image':
                                                  widget.product.imageUrls[0],
                                            });
                                          }

                                          transaction.update(userRef, {
                                            'mycart': json.encode(cartList)
                                          });
                                        });

                                        // Navigate to the cart screen
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  CartScreen()),
                                        );
                                      },
                                      child: Icon(Icons.add_shopping_cart,
                                          color: Colors.white, size: 25),
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
                                return ProductTile(
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
                          SizedBox(height: 20),
                        ],
                      ),
                      SizedBox(height: 75),
                    ],
                  ),
                ),
                /*Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  color: Colors.white,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CheckoutScreen(),
                        ),
                      );
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
              ),*/
              ]);
            }),
      ),
    );
  }

  _buildSizeWidget(String size) {
    bool isSelected = size == _selectedProductSize;
    return GestureDetector(
        onTap: () {
          setState(() {
            _selectedProductSize = isSelected ? '' : size;
          });
        },
        child: Container(
          decoration: BoxDecoration(
            color: isSelected ? Theme.of(context).primaryColor : Colors.white,
            borderRadius: BorderRadius.circular(2),
            border: Border.all(
              color: isSelected
                  ? Theme.of(context).primaryColor
                  : hexToColor('#848484'),
              width: 1,
            ),
          ),
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Text(
              size,
              style: TextStyle(
                color: isSelected ? Colors.white : hexToColor('#222230'),
                fontFamily: 'Gotham',
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ));
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
                child: Icon(
                  Icons.flag_rounded,
                  color: Theme.of(context).primaryColor,
                  size: 16,
                ),
              ),
              SizedBox(width: 4),
              Text(
                '900',
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
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: hexToColor('#F5F5F5'),
                    child: Image.asset(
                      'assets/red-flag.png',
                      width: 30,
                      height: 30,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    '100',
                    style:
                        TextStyle(color: hexToColor('#9C9C9C'), fontSize: 16.0),
                  ),
                ],
              ),
              SizedBox(width: 20),
              Column(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: hexToColor('#F5F5F5'),
                    child: Image.asset(
                      'assets/green-flag.png',
                      width: 30,
                      height: 30,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    '800',
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
