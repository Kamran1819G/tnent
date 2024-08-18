import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tnent/core/helpers/color_utils.dart';

class MyCoupons extends StatefulWidget {
  const MyCoupons({super.key});

  @override
  State<MyCoupons> createState() => _MyCouponsState();
}

class _MyCouponsState extends State<MyCoupons> {
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
                        'My Coupons'.toUpperCase(),
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
                        icon:
                            Icon(Icons.arrow_back_ios_new, color: Colors.black),
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
              child: ListView.separated(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                itemCount: 2,
                separatorBuilder: (context, index) => SizedBox(height: 16.0),
                itemBuilder: (context, index) {
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset('assets/sample_coupon_horiz.png',
                          width: MediaQuery.of(context).size.width * 0.8),
                      SizedBox(width: 16.0),
                      Icon(CupertinoIcons.delete, color: hexToColor('#FF0000')),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
