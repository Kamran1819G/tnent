import 'package:flutter/material.dart';

class CategoryTile extends StatelessWidget {
  final String name;
  final String image;

  CategoryTile({
    required this.name,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      child: Container(
        color: Colors.grey[100],
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(image, height: 48.0),
            SizedBox(height: 8.0),
            Text(name, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0)),
          ],
        ),
      ),
    );
  }
}