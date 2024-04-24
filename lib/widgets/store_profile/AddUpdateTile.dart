import 'package:flutter/material.dart';
import 'package:tnennt/helpers/color_utils.dart';

class AddUpdateTile extends StatelessWidget {
  const AddUpdateTile({super.key});

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
              color: hexToColor('#F3F3F3'),
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: Container(
              margin: EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                ),
                child: Icon(Icons.add, size: 34.0, color: hexToColor('#B5B5B5'))),
          ),
        ],
      ),
    );
  }
}

