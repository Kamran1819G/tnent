import 'package:flutter/material.dart';

class UpdateTile extends StatelessWidget {
  final String name;
  final String image;

  UpdateTile({
    required this.name,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
              height: 125,
              width: 125,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey[200]!),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Image.asset(image, height: 48.0)),
          SizedBox(height: 8.0),
          Expanded(
              child: Text(name,
                  style:
                      TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0))),
        ],
      ),
    );
  }
}
