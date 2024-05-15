import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tnennt/pages/catalog_pages/checkout_screen.dart';

import '../../helpers/color_utils.dart';

class WishlistScreen extends StatefulWidget {
  const WishlistScreen({super.key});

  @override
  State<WishlistScreen> createState() => _WishlistScreenState();
}

class _WishlistScreenState extends State<WishlistScreen> {
  bool selectedItems = false;

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
                        'Wishlist'.toUpperCase(),
                        style: TextStyle(
                          color: hexToColor('#1E1E1E'),
                          fontWeight: FontWeight.w900,
                          fontSize: 24.0,
                          letterSpacing: 1.5,
                        ),
                      ),
                      Text(
                        ' •',
                        style: TextStyle(
                          fontWeight: FontWeight.w900,
                          fontSize: 28.0,
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
                        icon:
                            Icon(Icons.arrow_back_ios_new, color: Colors.black),
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
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Total Amount',
                        style: TextStyle(
                          color: hexToColor('#343434'),
                          fontWeight: FontWeight.w900,
                          fontSize: 18.0,
                        ),
                      ),
                      Text(
                        '₹ 0.00',
                        style: TextStyle(
                          color: hexToColor('#A9A9A9'),
                          fontWeight: FontWeight.w900,
                          fontSize: 18.0,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            'Select Items',
                            style: TextStyle(
                              color: hexToColor('#343434'),
                              fontWeight: FontWeight.w900,
                              fontSize: 16.0,
                            ),
                          ),
                          Text(
                            'Rent All The Selected Products Together',
                            style: TextStyle(
                              color: hexToColor('#989898'),
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w500,
                              fontSize: 8.0,
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
                          }),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 16.0),
            Expanded(
              child: ListView.builder(
                itemCount: 5,
                itemBuilder: (context, index) {
                  return WishlistProductTile(
                    productImage: 'assets/product_image.png',
                    productName: 'Nikon Camera',
                    productPrice: 999,
                    selectedItem: selectedItems,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class WishlistProductTile extends StatefulWidget {
  String productImage;
  String productName;
  int productPrice;
  bool selectedItem;

  WishlistProductTile(
      {required this.productImage,
      required this.productName,
      required this.productPrice,
      this.selectedItem = false});

  @override
  State<WishlistProductTile> createState() => _WishlistProductTileState();
}

class _WishlistProductTileState extends State<WishlistProductTile> {
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
      padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 14.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Stack(
            children: [
              Container(
                height: 190,
                width: 150,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4.0),
                  image: DecorationImage(
                    image: AssetImage(widget.productImage),
                    fit: BoxFit.fill,
                  ),
                ),
              ),
              Positioned(
                right: 8.0,
                top: 8.0,
                child: GestureDetector(
                  onTap: () {
                    _toggleWishlist();
                  },
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
          SizedBox(width: 15.0),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                '${widget.productName}',
                style: TextStyle(
                  color: hexToColor('#343434'),
                  fontWeight: FontWeight.w900,
                  fontSize: 20.0,
                ),
              ),
              SizedBox(height: 65.0),
              Text(
                '₹${widget.productPrice}',
                style: TextStyle(
                  color: hexToColor('#343434'),
                  fontWeight: FontWeight.w900,
                  fontSize: 20.0,
                ),
              ),
              SizedBox(height: 25.0),
              Row(
                children: [
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                    decoration: BoxDecoration(
                      border: Border.all(color: hexToColor('#343434')),
                      borderRadius: BorderRadius.circular(100.0),
                    ),
                    child: Text(
                      'Remove',
                      style: TextStyle(
                        color: hexToColor('#737373'),
                        fontWeight: FontWeight.w900,
                        fontSize: 12.0,
                      ),
                    ),
                  ),
                  SizedBox(width: 4.0),
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
                      padding:
                          EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                      decoration: BoxDecoration(
                        color: hexToColor('#343434'),
                        borderRadius: BorderRadius.circular(100.0),
                      ),
                      child: Text(
                        'Buy Now',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w900,
                          fontSize: 12.0,
                        ),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
          SizedBox(width: 15.0),
          if (widget.selectedItem)
            Checkbox(
                activeColor: Colors.white,
                checkColor: Theme.of(context).primaryColor,
                value: _isSelected,
                onChanged: (value) {
                  setState(() {
                    _isSelected = value!;
                  });
                }),
        ],
      ),
    );
  }
}
