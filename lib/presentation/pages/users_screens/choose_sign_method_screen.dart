import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:tnent/core/routes/app_routes.dart';

import '../../../core/helpers/color_utils.dart';

class ChooseSignInMethodScreen extends StatelessWidget {
  const ChooseSignInMethodScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () {
                Get.toNamed(AppRoutes.SIGN_IN);
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
                      'Sign In to your existing account',
                      style: TextStyle(
                          fontSize: 25.sp,
                          color: Colors.white,
                          fontFamily: 'Gotham',
                          fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            GestureDetector(
              onTap: () {
                Get.toNamed(AppRoutes.SIGN_UP);
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
                      'Create a new account',
                      style: TextStyle(
                          fontSize: 25.sp,
                          color: Colors.white,
                          fontFamily: 'Gotham',
                          fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
