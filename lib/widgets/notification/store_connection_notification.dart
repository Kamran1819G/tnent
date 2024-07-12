import 'package:flutter/material.dart';
import 'package:tnennt/helpers/color_utils.dart';

class StoreConnectionNotification extends StatelessWidget {
  final String name;
  final String image;
  final String time;

  StoreConnectionNotification({
    required this.name,
    required this.image,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        radius: 25.0,
        child: Image.asset(image),
      ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            time,
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w900,
              fontFamily: 'Poppins',
              fontSize: 10.0,
            ),
          ),
          SizedBox(height: 4.0),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                name,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 14.0,
                ),
              ),
              SizedBox(width: 8.0),
              Text(
                'connected to your store',
                style: TextStyle(
                  color: hexToColor('#343434'),
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w500,
                  fontSize: 12.0,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
