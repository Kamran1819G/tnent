import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tnent/core/helpers/color_utils.dart';

class ContactScreen extends StatelessWidget {
  const ContactScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.symmetric(vertical: 30.h, horizontal: 24.w),
              child: Row(
                children: [
                  Text(
                    'Contact Us',
                    style: TextStyle(
                      fontSize: 42.sp,
                    ),
                  ),
                  Spacer(),
                  IconButton(
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(hexToColor('#F5F5F5')),
                    ),
                    onPressed: () {
                      // Add your back logic here
                    },
                    icon: Icon(Icons.arrow_back_ios),
                  ),
                ],
              ),
            ),
            SizedBox(height: 24.h),
            Card(
              color: Colors.white,
              elevation: 3,
              margin: EdgeInsets.symmetric(horizontal: 24.w),
              child: Padding(
                padding: EdgeInsets.all(24.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Get in Touch'.toUpperCase(),
                      style: TextStyle(
                        fontSize: 32.sp,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 12.h),
                    Text(
                      'Fill up the form and our Team will get back\nto you within 24 hours.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: hexToColor('#6B7280'),
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w500),
                    ),
                    SizedBox(height: 24.h),
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Your Name',
                        labelStyle: TextStyle(
                          fontSize: 24.sp,
                        ),
                        border: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.black),
                        ),
                      ),
                    ),
                    SizedBox(height: 24.h),
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Your Email',
                        labelStyle: TextStyle(
                          fontSize: 24.sp,
                        ),
                        border: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.black),
                        ),
                      ),
                    ),
                    SizedBox(height: 24.h),
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Your Subject',
                        labelStyle: TextStyle(
                          fontSize: 24.sp,
                        ),
                        border: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.black),
                        ),
                      ),
                    ),
                    SizedBox(height: 24.h),
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Your Message',
                        labelStyle: TextStyle(
                          fontSize: 24.sp,
                        ),
                        border: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.black),
                        ),
                      ),
                      maxLines: 4,
                    ),
                    SizedBox(height: 30.h),
                    ElevatedButton(
                      onPressed: () {
                        // Add your send message logic here
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).primaryColor,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(vertical: 24.h),
                      ),
                      child: Text(
                        'Send Message',
                        style: TextStyle(fontSize: 24.sp),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 50.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 18.h),
                height: 300.h,
                width: double.infinity,
                decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.circular(20.r)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Contact Information',
                      style: TextStyle(
                        fontSize: 32.sp,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 30.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.phone,
                          color: Colors.white,
                          size: 24.sp,
                        ),
                        SizedBox(width: 12.w),
                        Text(
                          '+91 93953 40221',
                          style: TextStyle(
                            fontSize: 24.sp,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 12.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.email,
                          color: Colors.white,
                          size: 24.sp,
                        ),
                        SizedBox(width: 12.w),
                        Text(
                          'support@tnennt.com',
                          style: TextStyle(
                            fontSize: 24.sp,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 12.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.location_on,
                          color: Colors.white,
                          size: 24.sp,
                        ),
                        SizedBox(width: 12.w),
                        Text(
                          'Karimganj, Assam, India',
                          style: TextStyle(
                            fontSize: 24.sp,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    ));
  }
}
