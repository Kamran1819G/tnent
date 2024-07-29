import 'dart:ui' as ui;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dash/flutter_dash.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tnennt/helpers/color_utils.dart';
import 'package:tnennt/models/store_model.dart';
import 'package:tnennt/pages/gallery_pages/deliver_anything_anywhere.dart';
import 'package:tnennt/pages/delivery_service_pages/deliver_product.dart';
import 'package:tnennt/pages/gallery_pages/store_registration.dart';
import 'package:tnennt/pages/gallery_pages/the_middlemen.dart';
import 'package:tnennt/screens/store_owner_screens/my_store_profile_screen.dart';
import 'package:tnennt/screens/webview_screen.dart';

class Gallery extends StatefulWidget {

  const Gallery({Key? key}) : super(key: key);

  @override
  State<Gallery> createState() => _GalleryState();
}

class _GalleryState extends State<Gallery> {
  bool isStoreRegistered = false;
  bool isActive = true;
  late StoreModel store;

  @override
  void initState() {
    super.initState();
    initialize();
  }

  void initialize() async {
    await _checkStoreRegistration();
  }


  Future<void> _checkStoreRegistration() async {
    final user = FirebaseAuth.instance.currentUser;
    print(user?.uid);
    if (user != null) {
      final storeId = await FirebaseFirestore.instance
          .collection('Users')
          .doc(user.uid)
          .get()
          .then((doc) => doc.get('storeId'));
      if (storeId.isNotEmpty) {
        final storeDoc = await FirebaseFirestore.instance
            .collection('Stores')
            .doc(storeId)
            .get();
        setState(() {
          isStoreRegistered = storeDoc.exists;
          store = StoreModel.fromFirestore(storeDoc);
          isActive = store.isActive;
        });
      }
    }
  }

  Future<void> _updateStoreStatus(bool isActive) async {
    await FirebaseFirestore.instance
        .collection('Stores')
        .doc(store.storeId)
        .update({'isActive': isActive});
  }

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
              height: 100.h,
              margin: EdgeInsets.only(top: 20.h),
              padding: EdgeInsets.symmetric(horizontal: 2.0),
              child: Row(
                children: [
                  Row(
                    children: [
                      Text(
                        'Gallery'.toUpperCase(),
                        style: TextStyle(
                          color: hexToColor('#1E1E1E'),
                          fontSize: 35.sp,
                          letterSpacing: 1.5,
                        ),
                      ),
                      Text(
                        ' •',
                        style: TextStyle(
                          fontSize: 35.sp,
                          color: Colors.green,
                        ),
                      ),
                    ],
                  ),
                  Spacer(),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => WebViewScreen(url: 'https://tnennt-updated.vercel.app/contact', title: 'Contact Us')));
                    },
                    child: Container(
                      height: 55.h,
                      width: 155.w,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: hexToColor("#131312"),
                        borderRadius: BorderRadius.circular(28.r),
                      ),
                      child: Text(
                        'Contact Us',
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w600,
                          fontSize: 16.sp,
                        ),
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
                                builder: (context) => MyStoreProfileScreen(
                                      store: store,
                                    )));
                      },
                      child: Container(
                        height: 180.h,
                        width: 604.w,
                        decoration: BoxDecoration(
                          color: hexToColor('#2D332F'),
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Row(
                              children: [
                                Container(
                                  height: 135.h,
                                  width: 135.w,
                                  margin:
                                      EdgeInsets.symmetric(horizontal: 15.0),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(18.r),
                                    image: DecorationImage(
                                      image: NetworkImage(store.logoUrl),
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
                                        SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.475,
                                          child: RichText(
                                            text: TextSpan(children: [
                                              TextSpan(
                                                text: store.name,
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontFamily: 'Gotham Black',
                                                  fontSize: 32.sp,
                                                ),
                                              ),
                                              TextSpan(
                                                text: ' •',
                                                style: TextStyle(
                                                  fontFamily: 'Gotham Black',
                                                  fontSize: 32.sp,
                                                  color: hexToColor('#42FF00'),
                                                ),
                                              ),
                                            ]),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 8.h),
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
                                          store.website,
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
                            Switch(
                              value: isActive,
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
                                  isActive = value;
                                });
                                _updateStoreStatus(value);
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            SizedBox(height: 20.0),
            if (!isStoreRegistered) ...[
              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => StoreRegistration()));
                },
                child: Image.asset("assets/digital_store_banner.png"),
              ),
              SizedBox(height: 20.0),
            ],
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
                  child: Image.asset(
                    "assets/deliver_anything_banner.png",
                  ),
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
