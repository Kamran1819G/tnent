import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'helpers/color_utils.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: 'Tnennt',
                  style: TextStyle(
                    color: hexToColor('#2D332F'),
                    fontFamily: 'Gotham Black',
                    fontSize: 50.sp,
                  ),
                ),
                TextSpan(
                  text: ' •',
                  style: TextStyle(
                    fontFamily: 'Gotham Black',
                    fontSize: 40.sp,
                    color: hexToColor('#42FF00'),
                  ),
                ),
              ],
            ),
          ),
        ),
      )
    );
  }
}
