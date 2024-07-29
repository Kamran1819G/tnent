import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_dash/flutter_dash.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tnennt/helpers/color_utils.dart';
import 'package:tnennt/pages/coupon_pages/fixed_price_coupon.dart';
import 'package:tnennt/pages/coupon_pages/my_coupons.dart';
import 'package:tnennt/pages/coupon_pages/percentage_coupon.dart';
import 'package:tnennt/screens/coming_soon.dart';

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
                  margin: EdgeInsets.all(20.w),
                  width: 450.w,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Create Your Store Coupon',
                        style: TextStyle(
                          color: hexToColor('#272822'),
                          fontSize: 52.sp,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 20.h),
                      Text(
                        'Create Discount Coupons For Your Store And Products Easily And Instantly',
                        style: TextStyle(
                          color: hexToColor('#5E5E5E'),
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w400,
                          fontSize: 15.sp,
                        ),
                        maxLines: 3,
                      ),
                    ],
                  ),
                ),
                Container(
                  height: 310.h,
                  child: ClipRRect(
                    child: Image.asset(
                      'assets/sample_coupon.png',
                      fit: BoxFit.fill,
                    ),
                  ),
                )
              ],
            ),
            SizedBox(height: 30.h),
            Dash(
              direction: Axis.horizontal,
              length: 600.w,
              dashLength: 6,
              dashColor: hexToColor('#2B2B2B'),
            ),
            SizedBox(height: 100.h),
            GestureDetector(
              onTap: () {
                // FixedPriceCoupon();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ComingSoon(),
                  ),
                );
              },
              child: Container(
                height: 235.h,
                width: 580.w,
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.circular(34.r),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        Text(
                          'Fixed Price Discount',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 35.sp,
                          ),
                        ),
                        Text(
                          ' •',
                          style: TextStyle(
                            fontSize: 35.sp,
                            color: hexToColor('#FF0000'),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 30.h),
                    Text(
                      'Create fixed amount discount coupons for your customers ',
                      style: TextStyle(
                        color: hexToColor('#D0D0D0'),
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w400,
                        fontSize: 18.sp,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 30.h),
            GestureDetector(
              onTap: () {
                // PercentageCoupon();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ComingSoon(),
                  ),
                );
              },
              child: Container(
                height: 235.h,
                width: 580.w,
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.circular(34.r),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        Text(
                          'Percentage Discount',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 35.sp,
                          ),
                        ),
                        Text(
                          ' •',
                          style: TextStyle(
                            fontSize: 35.sp,
                            color: hexToColor('#34A853'),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 30.h),
                    Text(
                      'Create percentage based discount coupons for your customers',
                      style: TextStyle(
                        color: hexToColor('#D0D0D0'),
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w400,
                        fontSize: 18.sp,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 100.h),
            Center(
              child: GestureDetector(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return ComingSoon();
                  }));
                },
                child: Container(
                  height: 95.h,
                  width: 470.w,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: hexToColor('#2D332F'),
                    borderRadius: BorderRadius.circular(50.r),
                  ),
                  child: Text(
                    'My Coupons',
                    style: TextStyle(
                      fontSize: 24.sp,
                      fontFamily: 'Gotham',
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
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
