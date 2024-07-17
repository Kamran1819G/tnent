import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_dash/flutter_dash.dart';
import 'package:tnennt/helpers/color_utils.dart';
import 'package:tnennt/pages/coupon_pages/fixed_price_coupon.dart';
import 'package:tnennt/pages/coupon_pages/my_coupons.dart';
import 'package:tnennt/pages/coupon_pages/percentage_coupon.dart';

class CreateCouponScreen extends StatefulWidget {
  const CreateCouponScreen({super.key});

  @override
  State<CreateCouponScreen> createState() => _CreateCouponScreenState();
}

class _CreateCouponScreenState extends State<CreateCouponScreen> {
  int currentPage = 0;
  PageController _pageController = PageController();

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
                          Image.asset('assets/white_tnennt_logo.png',
                              width: 20, height: 20),
                          SizedBox(width: 10),
                          Text(
                            'Tnennt inc.',
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
                        icon:
                            Icon(Icons.arrow_back_ios_new, color: Colors.black),
                        onPressed: () {
                          if (currentPage == 0) {
                            Navigator.pop(context);
                          } else {
                            _pageController.previousPage(
                              duration: Duration(milliseconds: 500),
                              curve: Curves.easeInOut,
                            );
                            currentPage--;
                          }
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  margin: EdgeInsets.all(16.0),
                  width: MediaQuery.of(context).size.width * 0.6,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Create Your Store Coupon',
                        style: TextStyle(
                          color: hexToColor('#272822'),
                          fontSize: 28.0,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Create Discount Coupons For Your Store And Products Easily And Instantly',
                        style: TextStyle(
                          color: hexToColor('#5E5E5E'),
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w400,
                          fontSize: 12.0,
                        ),
                        maxLines: 3,
                      ),
                    ],
                  ),
                ),
                Container(
                  height: 200,
                  child: ClipRRect(
                    child: Image.asset(
                      'assets/sample_coupon.png',
                      fit: BoxFit.fill,
                    ),
                  ),
                )
              ],
            ),
            SizedBox(height: 20),
            Dash(
              direction: Axis.horizontal,
              length: MediaQuery.of(context).size.width * 0.9,
              dashLength: 6,
              dashColor: hexToColor('#2B2B2B'),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.075),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FixedPriceCoupon(),
                  ),
                );
              },
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 16.0),
                padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 30.0),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Text(
                          'Fixed Price Discount',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 22.0,
                          ),
                        ),
                        Text(
                          ' •',
                          style: TextStyle(
                            fontSize: 18.0,
                            color: hexToColor('#FF0000'),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    Text(
                      'Create fixed amount discount coupons for your customers ',
                      style: TextStyle(
                        color: hexToColor('#D0D0D0'),
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w400,
                        fontSize: 12.0,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PercentageCoupon(),
                  ),
                );
              },
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 16.0),
                padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 30.0),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Text(
                          'Percentage Discount',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 22.0,
                          ),
                        ),
                        Text(
                          ' •',
                          style: TextStyle(
                            fontSize: 18.0,
                            color: hexToColor('#34A853'),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    Text(
                      'Create percentage based discount coupons for your customers',
                      style: TextStyle(
                        color: hexToColor('#D0D0D0'),
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w400,
                        fontSize: 12.0,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 50),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return MyCoupons();
                  }));
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: hexToColor('#323232'),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50.0),
                  ),
                  padding:
                      EdgeInsets.symmetric(horizontal: 80.0, vertical: 20.0),
                ),
                child: Text(
                  'My Coupons',
                  style: TextStyle(
                    fontSize: 16.0,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
