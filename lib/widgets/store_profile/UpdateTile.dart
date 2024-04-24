import 'package:flutter/material.dart';
import 'package:tnennt/helpers/color_utils.dart';

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
      padding: EdgeInsets.all(8.0),
      child: Column(
        children: [
          Container(
              height: 100,
              width: 100,
              decoration: BoxDecoration(
                border: Border.all(color: hexToColor('#B5B5B5'), width: 1.0),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Image.asset(image, height: 48.0)),
        ],
      ),
    );
  }
}
