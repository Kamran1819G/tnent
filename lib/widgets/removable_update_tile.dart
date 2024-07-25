import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tnennt/helpers/color_utils.dart';

class RemovableUpdateTile extends StatelessWidget {
  final String image;
  final VoidCallback onRemove;

  RemovableUpdateTile({
    required this.image,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 18.w),
      child: Stack(
        children: [
          Container(
            height: 220.h,
            width: 480.w,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18.r),
              image: DecorationImage(
                image: AssetImage(image),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned(
            right: 14.w,
            top: 14.h,
            child: GestureDetector(
              onTap: onRemove,
              child: Container(
                padding: EdgeInsets.all(8.w),
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.remove,
                  color: Colors.red,
                  size: 28.sp,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}