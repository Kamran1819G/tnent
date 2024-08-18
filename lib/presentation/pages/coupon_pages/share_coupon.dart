import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:tnent/core/helpers/color_utils.dart';

class ShareCoupon extends StatefulWidget {
  final Uint8List imageBytes;

  const ShareCoupon({super.key, required this.imageBytes});

  @override
  State<ShareCoupon> createState() => _ShareCouponState();
}

class _ShareCouponState extends State<ShareCoupon> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                height: 100,
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  children: [
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                      decoration: BoxDecoration(
                        color: hexToColor('#272822'),
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset('assets/white_tnent_logo.png',
                                width: 20, height: 20),
                            SizedBox(width: 10),
                            Text(
                              'Tnent inc.',
                              style: TextStyle(
                                color: hexToColor('#E6E6E6'),
                                fontSize: 14.0,
                              ),
                            ),
                          ]),
                    ),
                    Spacer(),
                    Container(
                      margin: EdgeInsets.all(8.0),
                      child: CircleAvatar(
                        backgroundColor: Colors.grey[100],
                        child: IconButton(
                          icon: Icon(Icons.arrow_back_ios),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Your Coupon Has Been Generated !',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 24.0,
                ),
                maxLines: 2,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.15),
              Container(
                margin: EdgeInsets.all(20),
                child: Transform.rotate(
                  angle: pi / 2,
                  child: Image.memory(
                    widget.imageBytes,
                    fit: BoxFit.fill,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: GestureDetector(
        onTap: () async {
          final tempDir = await getTemporaryDirectory();
          final file = await File('${tempDir.path}/coupon.png').create();
          await file.writeAsBytes(widget.imageBytes);
          await Share.shareXFiles(
            [XFile(file.path)],
            text: 'Check out this coupon from Tnent inc. !',
            subject: 'Coupon from Tnent inc.',
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              margin: EdgeInsets.all(20),
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 1,
                    blurRadius: 7,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Share Coupon',
                    style: TextStyle(
                      fontSize: 16.0,
                    ),
                  ),
                  SizedBox(width: 10),
                  Icon(
                    Icons.share,
                    color: Colors.black,
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
