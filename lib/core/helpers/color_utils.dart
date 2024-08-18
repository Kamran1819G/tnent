import 'package:flutter/material.dart';

// Function to convert hex color code to Color object
Color hexToColor(String code) {
  return Color(int.parse(code.substring(1, 7), radix: 16) + 0xFF000000);
}

Color hexToColorWithOpacity(String code, double opacity) {
  // Ensure opacity is between 0.0 and 1.0
  opacity = opacity.clamp(0.0, 1.0);

  // Convert opacity to hex
  int alpha = (opacity * 255).round();
  String alphaHex = alpha.toRadixString(16).padLeft(2, '0');

  // Parse the color code
  int colorInt = int.parse(code.substring(1, 7), radix: 16);

  // Combine alpha with color
  return Color(colorInt + (alpha << 24));
}