import 'package:flutter/material.dart';
import 'package:tnennt/screens/product_detail_screen.dart';
import '../helpers/color_utils.dart';

class ProductTile extends StatefulWidget {
  final String name;
  final String image;
  final double price;

  ProductTile({
    required this.name,
    required this.image,
    required this.price,
  });

  @override
  _ProductTileState createState() => _ProductTileState();
}

class _ProductTileState extends State<ProductTile> {
  bool _isInWishlist = false;

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
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetailScreen(
              images: [
                Image.asset(widget.image),
                Image.asset(widget.image),
                Image.asset(widget.image),
              ],
              productName: widget.name,
              productDescription: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. eiusmod tempor incididunt ut labore et do.',
              productPrice: widget.price,
              storeName: 'Jain Brothers',
              storeLogo: 'assets/jain_brothers.png',
              Discount: 10,
            ),
          ),
        );
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 8.0),

        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6.0),
          color: hexToColor('#F5F5F5'),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Container(
                  height: 150,
                  width: 150,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                    image: DecorationImage(
                      image: AssetImage(widget.image),
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
                        size: 18.0,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 8.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    widget.name,
                    style: TextStyle(
                        color: hexToColor('#343434'),
                        fontWeight: FontWeight.w900,
                        fontSize: 10.0),
                  ),
                  SizedBox(height: 8.0),
                  Text(
                    '\$${widget.price.toString()}',
                    style: TextStyle(
                        color: hexToColor('#343434'),
                        fontWeight: FontWeight.w900,
                        fontSize: 10.0),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
