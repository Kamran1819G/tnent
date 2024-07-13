import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:tnennt/pages/catalog_pages/purchase_screen.dart';
import 'package:tnennt/pages/catalog_pages/wishlist_screen.dart';
import 'package:tnennt/screens/notification_screen.dart';
import 'package:tnennt/screens/users_screens/myprofile_screen.dart';

import '../../helpers/color_utils.dart';

class Catalog extends StatefulWidget {
  const Catalog({super.key});

  @override
  State<Catalog> createState() => _CatalogState();
}

class _CatalogState extends State<Catalog> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          height: 100,
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            children: [
              Row(
                children: [
                  Text(
                    'Catalog'.toUpperCase(),
                    style: TextStyle(
                      color: hexToColor('#1E1E1E'),
                      fontWeight: FontWeight.w400,
                      fontSize: 24.0,
                      letterSpacing: 1.5,
                    ),
                  ),
                  Text(
                    ' •',
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 28.0,
                      color: hexToColor('#FAD524'),
                    ),
                  ),
                ],
              ),
              Spacer(),
              Row(
                children: [
                  GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => NotificationScreen()));
                      },
                      child: Image.asset(
                        'assets/icons/new_notification_box.png',
                        height: 24,
                        width: 24,
                        fit: BoxFit.cover,
                        colorBlendMode: BlendMode.overlay,
                      )),
                  SizedBox(width: 20),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => MyProfileScreen()));
                    },
                    child: CircleAvatar(
                      radius: 30.0,
                      backgroundColor: Theme.of(context).primaryColor,
                      child:
                      Icon(Icons.person, color: Colors.white, size: 30.0),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
        Container(
          height: MediaQuery.of(context).size.height * 0.275,
          margin: EdgeInsets.symmetric(horizontal: 18.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.shade300,
                blurRadius: 10,
                spreadRadius: 5,
                offset: Offset(0, 0),
              ),
            ],
          ),
        ),
        SizedBox(height: 20.0),
        Container(
          height: MediaQuery.of(context).size.height * 0.5,
          padding: EdgeInsets.symmetric(horizontal: 8.0),
          child: GridView.count(
            crossAxisCount: 2,
            physics: NeverScrollableScrollPhysics(),
            childAspectRatio: 1.05,
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => WishlistScreen()),
                  );
                },
                child: Container(
                  margin: EdgeInsets.all(10),
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: hexToColor('#FFFCE4'),
                    image: DecorationImage(
                      image: AssetImage('assets/catalog_container_graphic.png'),
                      fit: BoxFit.cover,
                    ),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Wishlist',
                        style: TextStyle(
                          color: hexToColor('#1E1E1E'),
                          fontWeight: FontWeight.w400,
                          fontSize: 20.0,
                        ),
                      ),
                      Text(
                        'See all your saved products here',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w600,
                          fontSize: 10.0,
                          color: hexToColor('#585858'),
                        ),
                      ),
                      SizedBox(height: 20.0),
                      Row(
                        children: [
                          Spacer(),
                          Image.asset('assets/icons/wishlist.png',
                              height: 40, width: 40, fit: BoxFit.cover),
                        ],
                      )
                    ],
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => PurchaseScreen()),
                  );
                },
                child: Container(
                  margin: EdgeInsets.all(10.0),
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: hexToColor('#FFDFDF'),
                    image: DecorationImage(
                      image: AssetImage('assets/catalog_container_graphic.png'),
                      fit: BoxFit.cover,
                    ),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'My Purchases',
                        style: TextStyle(
                          color: hexToColor('#1E1E1E'),
                          fontWeight: FontWeight.w400,
                          fontSize: 20.0,
                        ),
                      ),
                      Text(
                        'See all your currently purchased items',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w600,
                          fontSize: 10.0,
                          color: hexToColor('#585858'),
                        ),
                      ),
                      SizedBox(height: 20.0),
                      Row(
                        children: [
                          Spacer(),
                          Image.asset('assets/icons/my_purchases.png',
                              height: 40, width: 40, fit: BoxFit.cover),
                        ],
                      )
                    ],
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.all(10.0),
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: hexToColor('#EAE6F6'),
                  image: DecorationImage(
                    image: AssetImage('assets/catalog_container_graphic.png'),
                    fit: BoxFit.cover,
                  ),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Premium',
                      style: TextStyle(
                        color: hexToColor('#1E1E1E'),
                        fontWeight: FontWeight.w400,
                        fontSize: 20.0,
                      ),
                    ),
                    Text(
                      'Unlock features with our premium services',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w600,
                        fontSize: 10.0,
                        color: hexToColor('#585858'),
                      ),
                    ),
                    SizedBox(height: 20.0),
                    Row(
                      children: [
                        Spacer(),
                        Image.asset('assets/icons/premium.png',
                            height: 40, width: 40, fit: BoxFit.cover),
                      ],
                    )
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.all(10.0),
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: hexToColor('#E2FDD9'),
                  image: DecorationImage(
                    image: AssetImage('assets/catalog_container_graphic.png'),
                    fit: BoxFit.cover,
                  ),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Coming Soon...',
                      style: TextStyle(
                        color: hexToColor('#1E1E1E'),
                        fontWeight: FontWeight.w400,
                        fontSize: 20.0,
                      ),
                    ),
                    Text(
                      'Let Team Tnennt. Cook ',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w600,
                        fontSize: 10.0,
                        color: hexToColor('#585858'),
                      ),
                    ),
                    SizedBox(height: 20.0),
                    Row(
                      children: [
                        Spacer(),
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 100.0),
      ],
    );
  }
}
