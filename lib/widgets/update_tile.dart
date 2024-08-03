import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';
import 'package:tnent/helpers/color_utils.dart';

class UpdateTile extends StatelessWidget {
  final String image;
  final VoidCallback onTap;

  UpdateTile({
    required this.image,
    required this.onTap,
  });

  Widget _buildShimmerSkeleton() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        height: 220.h,
        width: 480.w,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18.r),
          color: Colors.white,
        ),
      ),
    );
  }

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
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(18.r),
          child: image.isNotEmpty
              ? CachedNetworkImage(
            imageUrl: image,
            fit: BoxFit.cover,
            placeholder: (context, url) => _buildShimmerSkeleton(),
            errorWidget: (context, url, error) => Center(
              child: Icon(Icons.error, size: 40, color: Colors.grey),
            ),
          )
              : Center(
            child: Icon(Icons.image_not_supported,
                size: 40, color: Colors.grey),
          ),
        ),
      ),
    );
  }
}