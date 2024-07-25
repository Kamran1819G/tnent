import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tnennt/helpers/color_utils.dart';

class UpdateTile extends StatelessWidget {
  final String image;

  UpdateTile({
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 220.h,
      width: 480.w,
      margin: EdgeInsets.symmetric(horizontal: 18.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18.r),
        image: DecorationImage(
          image: AssetImage(image),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}