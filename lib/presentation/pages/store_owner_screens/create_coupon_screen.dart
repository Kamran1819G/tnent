import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_dash/flutter_dash.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tnent/core/helpers/color_utils.dart';
import 'package:tnent/presentation/pages/coupon_pages/fixed_price_coupon.dart';
import 'package:tnent/presentation/pages/coupon_pages/my_coupons.dart';
import 'package:tnent/presentation/pages/coupon_pages/percentage_coupon.dart';
import 'package:tnent/presentation/pages/coming_soon.dart';

class CreateCouponScreen extends StatefulWidget {
  const CreateCouponScreen({super.key});

  @override
  State<CreateCouponScreen> createState() => _CreateCouponScreenState();
}

class _CreateCouponScreenState extends State<CreateCouponScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Container(
              height: 100.h,
              margin: EdgeInsets.only(top: 16.h),
              padding: EdgeInsets.symmetric(horizontal: 16.h),
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: 16.0.w, vertical: 12.0.h),
                    decoration: BoxDecoration(
                      color: hexToColor('#272822'),
                      borderRadius: BorderRadius.circular(50.r),
                    ),
                    child: Row(
                      children: [
                        Image.asset('assets/white_tnent_logo.png',
                            width: 30.w, height: 30.w),
                        SizedBox(width: 16.w),
                        Text(
                          'Tnent inc.',
                          style: TextStyle(
                              color: hexToColor('#E6E6E6'), fontSize: 16.sp),
                        ),
                      ],
                    ),
                  ),
                  Spacer(),
                  IconButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                        Colors.grey[100],
                      ),
                      shape: MaterialStateProperty.all(
                        CircleBorder(),
                      ),
                    ),
                    icon: Icon(Icons.arrow_back_ios_new, color: Colors.black),
                    onPressed: () {
                      Navigator.pop(context);
                    },
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
            Container(
              height: 500.h,
              width: 580.w,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/coming_soon.png'),
                  fit: BoxFit.fill,
                ),
              ),
            ),
            /*GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FixedPriceCoupon(),
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
                    builder: (context) => PercentageCoupon(),
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
            ),*/
          ],
        ),
      ),
    );
  }
}
