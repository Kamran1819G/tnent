import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';
import 'package:tnent/core/helpers/color_utils.dart';
import 'package:tnent/models/product_model.dart';
import 'package:tnent/presentation/pages/product_detail_screen.dart';

class RemovableProductTile extends StatelessWidget {
  final ProductModel product;
  final double width;
  final double height;
  final VoidCallback onRemove;

  RemovableProductTile({
    required this.product,
    double? width,
    double? height,
    required this.onRemove,
  })  : width = width ?? 240.w,
        height = height ?? 390.h;

  ProductVariant? _getFirstVariation() {
    if (product.variations.isNotEmpty) {
      return product.variations.values.first;
    }
    return null;
  }

  Widget _buildShimmerSkeleton() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.vertical(top: Radius.circular(6.r)),
          color: Colors.white,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var firstVariation = _getFirstVariation();
    var price = firstVariation?.price ?? 0.0;
    var discount = firstVariation?.discount ?? 0.0;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetailScreen(
              product: product,
            ),
          ),
        );
      },
      child: Container(
        width: width,
        height: height,
        margin: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.r),
          // color: hexToColor('#F5F5F5'),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Stack(
                fit: StackFit.expand,
                children: [
                  ClipRRect(
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(6.r)),
                    child: product.imageUrls.isNotEmpty
                        ? CachedNetworkImage(
                            imageUrl: product.imageUrls[0],
                            fit: BoxFit.cover,
                            placeholder: (context, url) =>
                                _buildShimmerSkeleton(),
                            errorWidget: (context, url, error) =>
                                const Icon(Icons.error),
                          )
                        : Container(
                            color: Colors.grey[300],
                            child: const Icon(Icons.image_not_supported,
                                size: 40, color: Colors.grey),
                          ),
                  ),
                  Positioned(
                    right: 14.w,
                    top: 14.h,
                    child: GestureDetector(
                      onTap: onRemove,
                      child: Container(
                        padding: EdgeInsets.all(6.w),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.remove,
                          color: Colors.red,
                          size: 20.sp,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    product.name,
                    style: TextStyle(
                      color: hexToColor('#343434'),
                      fontSize: 18.sp,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 8.h),
                  Row(
                    children: [
                      Text(
                        '₹${price.toStringAsFixed(2)}',
                        style: TextStyle(
                          color: hexToColor('#343434'),
                          fontSize: 16.sp,
                        ),
                      ),
                      SizedBox(width: 8.w),
                      if (discount > 0)
                        Text(
                          '${discount.toStringAsFixed(0)}% OFF',
                          style: TextStyle(
                            color: hexToColor('#FF0000'),
                            fontSize: 16.sp,
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
