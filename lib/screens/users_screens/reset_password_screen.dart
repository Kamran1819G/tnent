import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tnent/services/firebase/firebase_auth_service.dart';
import 'package:tnent/screens/signin_screen.dart';

import '../../helpers/color_utils.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  PageController _pageController = PageController();
  TextEditingController _emailController = TextEditingController();
  int _currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: PageView(
          controller: _pageController,
          physics: NeverScrollableScrollPhysics(),
          onPageChanged: (int page) {
            setState(() {
              _currentPage = page;
            });
          },
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
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
                                  color: hexToColor('#E6E6E6'),
                                  fontSize: 16.sp),
                            ),
                          ],
                        ),
                      ),
                      Spacer(),
                      IconButton(
                        style: ButtonStyle(
                          backgroundColor: WidgetStateProperty.all(
                            Colors.grey[100],
                          ),
                          shape: WidgetStateProperty.all(
                            CircleBorder(),
                          ),
                        ),
                        icon:
                            Icon(Icons.arrow_back_ios_new, color: Colors.black),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 200.h),
                Container(
                  width: 485.w,
                  padding: EdgeInsets.only(left: 26.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Reset password',
                        style: TextStyle(
                            fontWeight: FontWeight.w500, fontSize: 40.sp),
                      ),
                      Text(
                        'Enter the email associated with your account and we’ll send an email with instruction to reset your paswword',
                        style: TextStyle(
                          color: hexToColor('#636363'),
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w500,
                          fontSize: 27.sp,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 50.h),
                Container(
                  margin: EdgeInsets.only(left: 32.w),
                  width: 520.w,
                  child: TextField(
                    controller: _emailController,
                    style: TextStyle(
                      fontFamily: 'Gotham',
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                    ),
                    decoration: InputDecoration(
                      label: Text('Email Address'),
                      labelStyle: TextStyle(
                        color: hexToColor('#545454'),
                        fontSize: 16,
                      ),
                      fillColor: hexToColorWithOpacity('#D9D9D9', 0.2),
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.r),
                        borderSide: BorderSide(
                          color: hexToColor('#838383'),
                          width: 1.0,
                        ),
                      ),
                    ),
                    keyboardType: TextInputType.emailAddress,
                  ),
                ),
                SizedBox(height: 20),
                Container(
                    padding: EdgeInsets.only(left: 470.w),
                    child: CircleAvatar(
                      backgroundColor: _emailController.text.isNotEmpty
                          ? Theme.of(context).primaryColor
                          : Colors.grey[500],
                      radius: 40.w,
                      child: IconButton(
                        icon: Icon(Icons.arrow_forward),
                        onPressed: () {
                          if (_emailController.text.isNotEmpty) {
                            _pageController.jumpToPage(_currentPage + 1);
                          }
                        },
                        color: Colors.white,
                      ),
                    )),
              ],
            ),
            Column(
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
                                  color: hexToColor('#E6E6E6'),
                                  fontSize: 16.sp),
                            ),
                          ],
                        ),
                      ),
                      Spacer(),
                      IconButton(
                        style: ButtonStyle(
                          backgroundColor: WidgetStateProperty.all(
                            Colors.grey[100],
                          ),
                          shape: WidgetStateProperty.all(
                            CircleBorder(),
                          ),
                        ),
                        icon:
                        Icon(Icons.arrow_back_ios_new, color: Colors.black),
                        onPressed: () {
                          _pageController.jumpToPage(_currentPage - 1);
                        },
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 400.h),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Check your email',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 40.sp,
                        ),
                      ),
                      SizedBox(height: 15.h),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20.0),
                        child: Text(
                          'We have sent a password recovery instruction to your email',
                          style: TextStyle(
                            color: hexToColor('#636363'),
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w500,
                            fontSize: 27.sp,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 50.h),
                Center(
                  child: GestureDetector(
                    onTap: () {
                      _pageController.jumpToPage(_currentPage + 1);
                    },
                    child: Container(
                      width: 345.w,
                      height: 95.h,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                      child: Text(
                        'Verify email',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 27.sp,
                        ),
                      ),
                    )
                  ),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
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
                                  color: hexToColor('#E6E6E6'),
                                  fontSize: 16.sp),
                            ),
                          ],
                        ),
                      ),
                      Spacer(),
                    ],
                  ),
                ),
                SizedBox(height: 200.h),
                Container(
                  width: 485.w,
                  padding: EdgeInsets.only(left: 26.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Create new password',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 40.sp,
                        ),
                      ),
                      Text(
                        'Your new password must be different from previous used passwords.',
                        style: TextStyle(
                          color: hexToColor('#636363'),
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w500,
                          fontSize: 27.sp,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                Container(
                  margin: EdgeInsets.only(left: 20, right: 50),
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                    color: hexToColor('#D9D9D9'),
                    border: Border.all(
                      color: hexToColor('#838383'),
                      strokeAlign: BorderSide.strokeAlignInside,
                      style: BorderStyle.solid,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: TextField(
                    style: TextStyle(
                      fontFamily: 'Gotham',
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                    ),
                    decoration: InputDecoration(
                        label: Text('New Password'),
                        labelStyle: TextStyle(
                          color: hexToColor('#545454'),
                          fontSize: 16,
                        ),
                        border: InputBorder.none),
                    keyboardType: TextInputType.visiblePassword,
                  ),
                ),
                SizedBox(height: 10),
                Container(
                  margin: EdgeInsets.only(left: 20, right: 50),
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                    color: hexToColor('#D9D9D9'),
                    border: Border.all(
                      color: hexToColor('#838383'),
                      strokeAlign: BorderSide.strokeAlignInside,
                      style: BorderStyle.solid,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: TextField(
                    style: TextStyle(
                      fontFamily: 'Gotham',
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                    ),
                    decoration: InputDecoration(
                        label: Text('Confirm Password'),
                        labelStyle: TextStyle(
                          color: hexToColor('#545454'),
                          fontSize: 16,
                        ),
                        border: InputBorder.none),
                    keyboardType: TextInputType.visiblePassword,
                  ),
                ),
                SizedBox(height: 20),
                Container(
                  padding: EdgeInsets.only(right: 40),
                  child: Row(
                    children: [
                      Spacer(),
                      CircleAvatar(
                        backgroundColor: Theme.of(context).primaryColor,
                        radius: 30,
                        child: IconButton(
                          icon: Icon(Icons.arrow_forward),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SignInScreen()));
                          },
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
