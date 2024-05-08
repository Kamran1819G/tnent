import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tnennt/helpers/color_utils.dart';
import 'package:tnennt/screens/users_screens/storeprofile_screen.dart';

class StoreTile extends StatelessWidget {
  final String storeName;
  final String storeLogo;

  StoreTile({
    required this.storeName,
    required this.storeLogo,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          CupertinoPageRoute(
            builder: (context) => StoreProfileScreen(
              storeName: storeName,
              storeLogo: storeLogo,
            ),
          ),
        );
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: 75,
            width: 75,
            decoration: BoxDecoration(
              border: Border.all(color: hexToColor('#B5B5B5')),
              borderRadius: BorderRadius.circular(18.0),
              image: DecorationImage(
                image: AssetImage(storeLogo),
                fit: BoxFit.fill,
              ),
            ),
          ),
          SizedBox(height: 8.0),
          Expanded(
            child: Text(
              storeName,
              style: TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: 12.0),
            ),
          ),
        ],
      ),
    );
  }
}
