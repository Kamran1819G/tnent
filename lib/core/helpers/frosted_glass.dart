import 'dart:ui';
import 'package:flutter/material.dart';

class FrostedGlass extends StatelessWidget {
  const FrostedGlass(
      {super.key,
      required this.width,
      required this.height,
      required this.child,
      this.borderRadius = 10,
      this.maxOpacity = 0.19,
      this.minOpacity = 0.09,
      this.sigmaX = 6,
      this.sigmaY = 6,
      this.borderColor});
  final double width;
  final double height;
  final Widget child;
  final double borderRadius;
  final double? maxOpacity;
  final double? minOpacity;
  final double? sigmaX;
  final double? sigmaY;
  final Color? borderColor;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        width: width,
        height: height,
        // color: Colors.transparent,
        child: Stack(
          children: [
            //blur effect
            BackdropFilter(
              filter: ImageFilter.blur(
                sigmaX: sigmaX!,
                sigmaY: sigmaY!,
              ),
              child: Container(),
            ),
            //gradient effect
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(borderRadius),
                border: Border.all(
                  color: borderColor == null
                      ? Colors.white.withOpacity(0.175)
                      : borderColor!,
                ),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.topRight,
                  colors: [
                    Colors.white.withOpacity(maxOpacity!),
                    Colors.white.withOpacity(minOpacity!),
                  ],
                ),
              ),
            ),
            //child
            Center(
              child: child,
            )
          ],
        ),
      ),
    );
  }
}
