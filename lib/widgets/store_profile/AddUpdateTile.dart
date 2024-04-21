import 'package:flutter/material.dart';

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
              border: Border.all(color: Colors.grey[200]!, width: 3.0, style: BorderStyle.solid),
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: Icon(Icons.add, size: 34.0, color: Colors.grey[700]),
          ),
        ],
      ),
    );
  }
}

