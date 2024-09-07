import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:tnent/core/routes/app_routes.dart';

class ChooseSignInMethodScreen extends StatelessWidget {
  const ChooseSignInMethodScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            btn(() {
              Get.toNamed(AppRoutes.SIGN_UP);
            }, 'Create your new account'),
            const SizedBox(
              height: 25,
            ),
            btn(() {
              Get.toNamed(AppRoutes.SIGN_IN);
            }, 'Log in to your account'),
          ],
        ),
      ),
    );
  }
}

Widget btn(VoidCallback onTap, String text) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      width: 500.w,
      height: 100.h,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        color: Colors.white,
        borderRadius: BorderRadius.circular(50.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            text,
            style: TextStyle(
                fontSize: 23.sp,
                color: Colors.black,
                fontFamily: 'regular',
                fontWeight: FontWeight.w600),
          ),
        ],
      ),
    ),
  );
}
