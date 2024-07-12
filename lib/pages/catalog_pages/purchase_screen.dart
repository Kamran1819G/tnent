import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tnennt/pages/catalog_pages/track_order_screen.dart';
import '../../helpers/color_utils.dart';
import 'detail_screen.dart';

class PurchaseScreen extends StatefulWidget {
  const PurchaseScreen({super.key});

  @override
  State<PurchaseScreen> createState() => _PurchaseScreenState();
}

class _PurchaseScreenState extends State<PurchaseScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
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
                      'Purchase'.toUpperCase(),
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Total Amount',
                  style: TextStyle(
                    color: hexToColor('#343434'),
                    fontSize: 18.0,
                  ),
                ),
                Text(
                  '₹ 0',
                  style: TextStyle(
                    color: hexToColor('#A9A9A9'),
                    fontSize: 18.0,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 16.0),
          Expanded(
            child: ListView.builder(
              itemCount: 5,
              itemBuilder: (context, index) {
                return PurchaseProductTile(
                  productImage: 'assets/product_image.png',
                  productName: 'Nikon Camera',
                  productPrice: 999,
                );
              },
            ),
          ),
        ],
      )),
    );
  }
}

class PurchaseProductTile extends StatefulWidget {
  String productImage;
  String productName;
  int productPrice;

  PurchaseProductTile({
    required this.productImage,
    required this.productName,
    required this.productPrice,
  });

  @override
  State<PurchaseProductTile> createState() => _PurchaseProductTileState();
}

class _PurchaseProductTileState extends State<PurchaseProductTile> {
  bool _isInWishlist = true;

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
                  fontSize: 20.0,
                ),
              ),
              SizedBox(height: 65.0),
              Text(
                '₹${widget.productPrice}',
                style: TextStyle(
                  color: hexToColor('#343434'),
                  fontSize: 20.0,
                ),
              ),
              SizedBox(height: 25.0),
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DetailScreen(
                            productImage: widget.productImage,
                            productName: widget.productName,
                            productPrice: widget.productPrice,
                          ),
                        ),
                      );
                    },
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                      decoration: BoxDecoration(
                        border: Border.all(color: hexToColor('#343434')),
                        borderRadius: BorderRadius.circular(100.0),
                      ),
                      child: Text(
                        'Details',
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
                          builder: (context) => TrackOrderScreen(
                            productImage: widget.productImage,
                            productName: widget.productName,
                            productPrice: widget.productPrice,
                          ),
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
                        'Track Order',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12.0,
                        ),
                      ),
                    ),
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
