import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../helpers/color_utils.dart';
import 'users_screens/storeprofile_screen.dart';

class StoresScreen extends StatefulWidget {
  const StoresScreen({super.key});

  @override
  State<StoresScreen> createState() => _StoresScreenState();
}

class _StoresScreenState extends State<StoresScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Container(
              height: 100,
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  Row(
                    children: [
                      Text(
                        'Stores'.toUpperCase(),
                        style: TextStyle(
                          color: hexToColor('#1E1E1E'),
                          fontWeight: FontWeight.w900,
                          fontSize: 28.0,
                          letterSpacing: 1.5,
                        ),
                      ),
                      Text(
                        ' •',
                        style: TextStyle(
                          fontWeight: FontWeight.w900,
                          fontSize: 28.0,
                          color: hexToColor('#FF0000'),
                        ),
                      ),
                    ],
                  ),
                  Spacer(),
                  Container(
                    margin: EdgeInsets.all(8.0),
                    child: CircleAvatar(
                      backgroundColor: Colors.grey[100],
                      child: IconButton(
                        icon: Icon(Icons.arrow_back_ios_new,
                            color: Colors.black),
                        onPressed: () {
                            Navigator.pop(context);
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: GridView.count(
                crossAxisCount: 4,
                mainAxisSpacing: 20.0,
                children: [
                  StoreTile(
                    storeName: 'Sanachari',
                    storeLogo: 'assets/sahachari_image.png',
                  ),
                  StoreTile(
                    storeName: 'Jain Brothers',
                    storeLogo: 'assets/jain_brothers.png',
                  ),
                  StoreTile(
                    storeName: 'Sanachari',
                    storeLogo: 'assets/sahachari_image.png',
                  ),
                  StoreTile(
                    storeName: 'Jain Brothers',
                    storeLogo: 'assets/jain_brothers.png',
                  ),
                  StoreTile(
                    storeName: 'Sanachari',
                    storeLogo: 'assets/sahachari_image.png',
                  ),
                  StoreTile(
                    storeName: 'Jain Brothers',
                    storeLogo: 'assets/jain_brothers.png',
                  ),
                  StoreTile(
                    storeName: 'Sanachari',
                    storeLogo: 'assets/sahachari_image.png',
                  ),
                  StoreTile(
                    storeName: 'Jain Brothers',
                    storeLogo: 'assets/jain_brothers.png',
                  ),
                  StoreTile(
                    storeName: 'Sanachari',
                    storeLogo: 'assets/sahachari_image.png',
                  ),
                  StoreTile(
                    storeName: 'Jain Brothers',
                    storeLogo: 'assets/jain_brothers.png',
                  ),
                  StoreTile(
                    storeName: 'Sanachari',
                    storeLogo: 'assets/sahachari_image.png',
                  ),
                  StoreTile(
                    storeName: 'Jain Brothers',
                    storeLogo: 'assets/jain_brothers.png',
                  ),
                  StoreTile(
                    storeName: 'Sanachari',
                    storeLogo: 'assets/sahachari_image.png',
                  ),
                  StoreTile(
                    storeName: 'Jain Brothers',
                    storeLogo: 'assets/jain_brothers.png',
                  ),
                  StoreTile(
                    storeName: 'Sanachari',
                    storeLogo: 'assets/sahachari_image.png',
                  ),
                  StoreTile(
                    storeName: 'Jain Brothers',
                    storeLogo: 'assets/jain_brothers.png',
                  ),StoreTile(
                    storeName: 'Sanachari',
                    storeLogo: 'assets/sahachari_image.png',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

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
          MaterialPageRoute(
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