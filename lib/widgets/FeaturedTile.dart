import 'package:flutter/material.dart';

class FeaturedTile extends StatelessWidget {
  final String name;
  final String image;
  final double price;

  FeaturedTile({
    required this.name,
    required this.image,
    required this.price,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[200]!),
        borderRadius: BorderRadius.circular(8.0),
        color: Colors.grey[200],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
              height: 145,
              width: 145,
              child: Image.asset(image, height: 48.0)),
          SizedBox(height: 8.0),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(name,
                  style:
                  TextStyle(fontWeight: FontWeight.bold, fontSize: 14.0)),
              SizedBox(height: 4.0),
              Text('\$${price.toString()}', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.0)),
            ],
          ),
        ],
      ),
    );
  }
}
