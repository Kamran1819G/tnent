import 'dart:ui' as ui;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dash/flutter_dash.dart';
import 'package:tnennt/helpers/color_utils.dart';
import 'package:tnennt/pages/gallery_pages/deliver_anything_anywhere.dart';
import 'package:tnennt/pages/delivery_service_pages/deliver_product.dart';
import 'package:tnennt/pages/gallery_pages/store_registration.dart';
import 'package:tnennt/pages/gallery_pages/the_middlemen.dart';
import 'package:tnennt/screens/store_owner_screens/my_store_profile_screen.dart';

class Gallery extends StatefulWidget {
  const Gallery({super.key});

  @override
  State<Gallery> createState() => _GalleryState();
}

class _GalleryState extends State<Gallery> {
  bool isStoreRegistered = true;
  bool isAccepting = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: hexToColor('#F1F0EC'),
      padding: EdgeInsets.symmetric(horizontal: 10.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Container(
              height: 100,
              padding: EdgeInsets.symmetric(horizontal: 2.0),
              child: Row(
                children: [
                  Row(
                    children: [
                      Text(
                        'Gallery'.toUpperCase(),
                        style: TextStyle(
                          color: hexToColor('#1E1E1E'),
                          fontSize: 24.0,
                          letterSpacing: 1.5,
                        ),
                      ),
                      Text(
                        ' •',
                        style: TextStyle(
                          fontSize: 28.0,
                          color: Colors.green,
                        ),
                      ),
                    ],
                  ),
                  Spacer(),
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 14.0, vertical: 10.0),
                    decoration: BoxDecoration(
                      color: hexToColor("#131312"),
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    child: Text(
                      'Contact Us',
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w600,
                        fontSize: 12.0,
                      ),
                    ),
                  )
                ],
              ),
            ),
            if (isStoreRegistered)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 2.0),
                      child: Text(
                        'Store',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16.0,
                        ),
                      ),
                    ),
                    SizedBox(height: 10.0),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => MyStoreProfileScreen()));
                      },
                      child: Container(
                        height: 100,
                        decoration: BoxDecoration(
                          color: hexToColor('#2D332F'),
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Container(
                                  height: 70,
                                  width: 70,
                                  margin: EdgeInsets.symmetric(horizontal: 15.0),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15.0),
                                    image: DecorationImage(
                                      image:
                                          AssetImage('assets/jain_brothers.png'),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          child: RichText(
                                            text: TextSpan(
                                              text: 'Jain Brothers',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontFamily: 'Gotham Black',
                                                fontSize: 20.0,
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: 8.0),
                                        Container(
                                          width: 8,
                                          height: 8,
                                          margin:
                                              EdgeInsets.symmetric(vertical: 10),
                                          decoration: BoxDecoration(
                                            color: Colors.green,
                                            borderRadius:
                                                BorderRadius.circular(5),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Image.asset(
                                          'assets/icons/blue_globe.png',
                                          height: 10.0,
                                          width: 10.0,
                                        ),
                                        SizedBox(width: 5.0),
                                        Text(
                                          'jainbrothers.tnennt.store',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 10.0,
                                            fontFamily: 'Poppins',
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ],
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(right: 15.0, top: 25),
                              child: Switch(
                                value: isAccepting,
                                activeColor: hexToColor('#41FA00'),
                                trackOutlineColor: WidgetStateColor.resolveWith(
                                  (states) => Colors.grey,
                                ),
                                trackOutlineWidth:
                                    WidgetStateProperty.resolveWith(
                                  (states) => 1.0,
                                ),
                                activeTrackColor: Colors.transparent,
                                inactiveTrackColor: Colors.transparent,
                                onChanged: (value) {
                                  setState(() {
                                    isAccepting = !isAccepting;
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            SizedBox(height: 20.0),
            if (!isStoreRegistered)
              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => StoreRegistration()));
                },
                child: Image.asset("assets/digital_store_banner.png"),
              ),
            if (!isStoreRegistered) SizedBox(height: 20.0),
            MaterialButton(
              onPressed: () {
                setState(() {
                  isStoreRegistered = !isStoreRegistered;
                });
              },
              child: Text('Change isStoreRegistered'),
            ),
            SizedBox(height: 20.0),
            GestureDetector(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => TheMiddlemen()));
                },
                child: Image.asset("assets/the_middleman_banner.png")),
            SizedBox(height: 20.0),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Dash(
                direction: Axis.horizontal,
                length: (MediaQuery.of(context).size.width / 3),
                dashLength: 8,
                dashColor: Colors.grey,
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                decoration: BoxDecoration(
                  color: Colors.grey[900],
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Text(
                  'Coming Soon',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12.0,
                  ),
                ),
              ),
              Dash(
                direction: Axis.horizontal,
                length: (MediaQuery.of(context).size.width / 3),
                dashLength: 8,
                dashColor: Colors.grey,
              ),
            ]),
            SizedBox(height: 20.0),
            GestureDetector(
              onTap: () {
               /* Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => DeliverAnythingAnywhere()));*/
              },
              child: ClipRRect(
                borderRadius: BorderRadius.circular(22.0),
                child: ColorFiltered(
                    colorFilter: ColorFilter.mode(
                        Colors.black.withOpacity(0.45), BlendMode.darken),
                    child: Image.asset("assets/deliver_anything_banner.png",),
                ),
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.2),
          ],
        ),
      ),
    );
  }
}
