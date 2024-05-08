import 'package:flutter/material.dart';
import 'package:tnennt/helpers/color_utils.dart';

class ExploreResultTile extends StatefulWidget {
  final String name;
  final String image;
  final double price;

  ExploreResultTile({
    required this.name,
    required this.image,
    required this.price,
  });

  @override
  _ExploreResultTileState createState() => _ExploreResultTileState();
}

class _ExploreResultTileState extends State<ExploreResultTile> {
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
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        color: hexToColor('#F5F5F5'),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              Container(
                child: Image.asset(widget.image, fit: BoxFit.fill),
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
          SizedBox(height: 8.0),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.name,
                  style: TextStyle(
                      color: hexToColor('#343434'),
                      fontWeight: FontWeight.w900,
                      fontSize: 12.0),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 4.0),
                Text(
                  '\$${widget.price.toString()}',
                  style: TextStyle(
                      color: hexToColor('#343434'),
                      fontWeight: FontWeight.w900,
                      fontSize: 12.0),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
