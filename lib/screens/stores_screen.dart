import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../helpers/color_utils.dart';
import '../widgets/StoreTile.dart';

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
            SizedBox(
              height: MediaQuery.of(context).size.height - 160,
              child: Expanded(
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
            ),
          ],
        ),
      ),
    );
  }
}
