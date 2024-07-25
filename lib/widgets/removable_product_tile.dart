import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tnennt/helpers/color_utils.dart';
import 'package:tnennt/models/product_model.dart';
import 'package:tnennt/screens/product_detail_screen.dart';

class RemovableProductTile extends StatelessWidget {
  final ProductModel product;
  final double width;
  final double height;
  final VoidCallback onRemove;

  RemovableProductTile({
    required this.product,
    this.width = 150.0,
    this.height = 200.0,
    required this.onRemove,
  });

  ProductVariant? _getFirstVariation() {
    if (product.variations.isNotEmpty) {
      return product.variations.values.first;
    }
    return null;
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
        margin: EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6.0),
          color: hexToColor('#F5F5F5'),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Stack(
                fit: StackFit.expand,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.vertical(top: Radius.circular(6.0)),
                    child: Image.network(
                      product.imageUrls.first,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                    right: 14.w,
                    top: 14.h,
                    child: GestureDetector(
                      onTap: onRemove,
                      child: Container(
                        padding: EdgeInsets.all(6.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.remove,
                          color: Colors.red,
                          size: 18.0,
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
                      fontSize: 12.0,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4.0),
                  Row(
                    children: [
                      Text(
                        '₹${price.toStringAsFixed(2)}',
                        style: TextStyle(
                          color: hexToColor('#343434'),
                          fontSize: 12.0,
                        ),
                      ),
                      SizedBox(width: 4.0),
                      if (discount > 0)
                        Text(
                          '${discount.toStringAsFixed(0)}% OFF',
                          style: TextStyle(
                            color: hexToColor('#FF0000'),
                            fontSize: 10.0,
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