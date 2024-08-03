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
              Container(
                color: Colors.blueGrey,
                child: Center(
                  child: Text('Page 1'),
                ),
              ),
              Container(
                color: Colors.green,
                child: Center(
                  child: Text('Page 2'),
                ),
              ),
              Container(
                color: Colors.deepPurple,
                child: Center(
                  child: Text('Page 3'),
                ),
              ),
              Container(
                color: Colors.black,
                child: Center(
                  child: Text('Page 4', style: TextStyle(color: Colors.white)),
                ),
              ),
            ],
          ),
          onLastPage
              ? SizedBox()
              : Container(
                  alignment: Alignment(0, 0.7),
                  child: SmoothPageIndicator(
                    controller: _pageController,
                    count: 4,
                    effect: ExpandingDotsEffect(
                      dotColor: Colors.white,
                      activeDotColor: Colors.white,
                      dotHeight: 8,
                      dotWidth: 8,
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
          Container(
            alignment: Alignment(0, 0.85),
            child: onLastPage
                ? ElevatedButton(
                    onPressed: () async {
                      final prefs = await SharedPreferences.getInstance();
                      prefs.setBool('onboarding', true);

                      if (!mounted) return;
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => WidgetTree()));
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      // Set the button color to black
                      foregroundColor: Colors.black,
                      // Set the text color to white
                      padding:
                          EdgeInsets.symmetric(horizontal: 50, vertical: 16),
                      // Set the padding
                      textStyle: TextStyle(
                        fontSize: 16, // Set the text size
                        fontWeight: FontWeight.bold, // Set the text weight
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                            30), // Set the button corner radius
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('Get Started', style: TextStyle(fontSize: 25.sp)),
                        SizedBox(width: 40),
                        ShaderMask(
                          shaderCallback: (Rect bounds) {
                            return LinearGradient(
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                              colors: [Colors.white, Colors.black],
                              stops: [0.0, 1.0],
                            ).createShader(bounds);
                          },
                          child: Row(
                            children: List.generate(
                              arrowIconCount,
                              (index) =>
                                  Icon(Icons.arrow_forward_ios, size: 24.sp),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                : ElevatedButton(
                    onPressed: () {
                      _pageController.nextPage(
                        duration: Duration(milliseconds: 500),
                        curve: Curves.ease,
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      maximumSize: Size(300, 50),
                      backgroundColor: Colors.black,
                      // Set the button color to black
                      foregroundColor: Colors.white,
                      // Set the text color to white
                      padding:
                          EdgeInsets.symmetric(horizontal: 50, vertical: 16),
                      // Set the padding
                      textStyle: TextStyle(
                        fontSize: 16, // Set the text size
                        fontWeight: FontWeight.bold, // Set the text weight
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                            30), // Set the button corner radius
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('Get Started', style: TextStyle(fontSize: 25.sp)),
                        SizedBox(width: 40),
                        ShaderMask(
                          shaderCallback: (Rect bounds) {
                            return LinearGradient(
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                              colors: [Colors.black, Colors.white],
                              stops: [0.0, 1.0],
                            ).createShader(bounds);
                          },
                          child: Row(
                            children: List.generate(
                              arrowIconCount,
                              (index) =>
                                  Icon(Icons.arrow_forward_ios, size: 24.sp),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
