import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:tnent/helpers/color_utils.dart';
import 'package:tnent/widget_tree.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  PageController _pageController = PageController();
  bool onLastPage = false;
  int arrowIconCount = 1;
  int currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          PageView(
            controller: _pageController,
            onPageChanged: (int page) {
              setState(() {
                onLastPage = page == 3;
                currentPage = page;
                arrowIconCount = page + 1;
              });
            },
            children: <Widget>[
              _buildAppFeaturePage(
                  'Lorem Ipsum',
                  'Lorem ipsum lorem ipsum lorem ipsum lorem ipsum lorem',
                  'assets/discount_shopping.png'),
              _buildAppFeaturePage(
                  'Lorem Ipsum',
                  'Lorem ipsum lorem ipsum lorem ipsum lorem ipsum lorem',
                  'assets/instant_shipping.png'),
              _buildAppFeaturePage(
                  'Lorem Ipsum',
                  'Lorem ipsum lorem ipsum lorem ipsum lorem ipsum lorem',
                  'assets/middleman_delivery.png'),
              _buildAppFeaturePage(
                  'Create Your Own e-Store',
                  'Make your own digital store and start selling online',
                  'assets/create_your_own_e-store.png'),
            ],
          ),
          onLastPage
              ? SizedBox()
              : Container(
                  alignment: Alignment(0, 0.75),
                  child: SmoothPageIndicator(
                    controller: _pageController,
                    count: 4,
                    effect: ExpandingDotsEffect(
                      dotColor: hexToColor('#7C7C7C'),
                      activeDotColor: hexToColor('#7C7C7C'),
                      dotHeight: 12.h,
                      dotWidth: 12.w,
                      spacing: 10,
                      expansionFactor: 5,
                    ),
                  ),
                ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            alignment: Alignment(0, -0.9),
            child: Row(
              children: [
                Container(
                  height: 55.h,
                  width: 150.w,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: hexToColor('#272822'),
                    borderRadius: BorderRadius.circular(50.r),
                  ),
                  child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset('assets/white_tnent_logo.png',
                            width: 24.w, height: 24.h),
                        SizedBox(width: 8.w),
                        Text(
                          'Tnent.',
                          style: TextStyle(
                            color: hexToColor('#E6E6E6'),
                            fontSize: 16.sp,
                          ),
                        ),
                      ]),
                ),
                Spacer(),
                Container(
                  height: 35.h,
                  width: 66.w,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(50.r),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        '${currentPage.toInt() + 1}/',
                        // Current page number
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w600,
                          color: hexToColor('#272822'),
                        ),
                      ),
                      Text(
                        '4', // Total number of pages
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w600,
                          color: hexToColor('#272822'),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment(0, 0.95),
            child: GestureDetector(
              onTap: () async {
                if (onLastPage) {
                  final prefs = await SharedPreferences.getInstance();
                  prefs.setBool('onboarding', true);

                  if (!mounted) return;
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => WidgetTree()));
                } else {
                  _pageController.nextPage(
                    duration: Duration(milliseconds: 500),
                    curve: Curves.ease,
                  );
                }
              },
              child: Container(
                width: 500.w,
                height: 100.h,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: hexToColor('#272727'),
                  borderRadius: BorderRadius.circular(50.r),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Get Started',
                      style: TextStyle(
                          fontSize: 25.sp,
                          color: Colors.white,
                          fontFamily: 'Gotham',
                          fontWeight: FontWeight.w500),
                    ),
                    SizedBox(width: 40.w),
                    Row(
                      children: List.generate(
                        arrowIconCount,
                        (index) => Icon(
                          Icons.arrow_forward_ios,
                          size: 25.sp,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppFeaturePage(String title, String subtitle, String imagePath) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          imagePath,
          width: 600.w,
          height: 600.h,
          fit: BoxFit.contain,
        ),
        SizedBox(height: 50.h),
        Text(
          title,
          style: TextStyle(color: hexToColor('#1E1E1E'), fontSize: 35.sp),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 20.h),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 26.w),
          child: Text(
            subtitle,
            style: TextStyle(
              color: hexToColor('#858585'),
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w500,
              fontSize: 23.sp,
            ),
            maxLines: 2,
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
