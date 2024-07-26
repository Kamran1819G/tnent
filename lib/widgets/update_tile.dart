import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tnennt/helpers/color_utils.dart';

class UpdateTile extends StatelessWidget {
  final String image;
  final VoidCallback onTap;

  UpdateTile({
    required this.image,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 220.h,
        width: 480.w,
        margin: EdgeInsets.symmetric(horizontal: 18.w),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18.r),
          image: image.isNotEmpty
              ? DecorationImage(
                  image: NetworkImage(image),
                  fit: BoxFit.cover,
                )
              : null,
        ),
        child: image.isEmpty
            ? Center(
                child: Icon(Icons.image_not_supported,
                    size: 40, color: Colors.grey))
            : null,
      ),
    );
  }
}
