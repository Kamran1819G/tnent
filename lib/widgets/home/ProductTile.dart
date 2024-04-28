import 'package:flutter/material.dart';
import 'package:tnennt/helpers/color_utils.dart';

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
  bool _isLiked = false;

  void _toggleLike() {
    setState(() {
      _isLiked = !_isLiked;
    });

    // Send like request to the server
    if (_isLiked) {
      // Code to send like request to the server
      print('Sending like request to the server');
    } else {
      // Code to send unlike request to the server
      print('Sending unlike request to the server');
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
                height: 145,
                child: Image.asset(widget.image, height: 48.0),
              ),
              Positioned(
                right: 8.0,
                top: 8.0,
                child: GestureDetector(
                  onTap: _toggleLike,
                  child: Container(
                    padding: EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(100.0),
                    ),
                    child: Icon(
                      _isLiked ? Icons.favorite : Icons.favorite_border,
                      color: Colors.red,
                      size: 14.0,
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 8.0),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.name,
                style: TextStyle(
                    color: hexToColor('#343434'),
                    fontWeight: FontWeight.w900,
                    fontSize: 12.0),
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
        ],
      ),
    );
  }
}
