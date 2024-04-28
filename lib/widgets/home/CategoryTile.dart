import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tnennt/helpers/color_utils.dart';

class CategoryTile extends StatelessWidget {
  final String name;
  final String image;

  CategoryTile({
    required this.name,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        color: hexToColor('#F5F5F5'),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [

          Container(
            height: 200,
            child: Image.asset(image,
              fit: BoxFit.fill,
            ),
          ),
          SizedBox(height: 8.0),
          Text(
            name,
            style: TextStyle(
              color: hexToColor('#343434'),
              fontWeight: FontWeight.w900,
              fontSize: 14.0,
            ),
          ),
        ],
      ),
    );
  }
}