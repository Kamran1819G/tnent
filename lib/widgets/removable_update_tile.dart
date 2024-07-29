import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';
import 'package:tnennt/helpers/color_utils.dart';

class RemovableUpdateTile extends StatelessWidget {
  final String image;
  final VoidCallback onRemove;
  final VoidCallback onTap;

  RemovableUpdateTile({
    required this.image,
    required this.onRemove,
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
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 18.w),
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(18.r),
              child: Container(
                height: 220.h,
                width: 480.w,
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
      ),
    );
  }
}