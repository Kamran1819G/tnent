import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void showSnackBar(BuildContext context, String? message,
    [Color bgColor = Colors.red,
    Duration duration = const Duration(seconds: 3)]) {
  if (!context.mounted) return;
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        content: Text(
          message!,
          style: TextStyle(
            fontSize: 14.sp,
            color: Colors.white,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w500,
          ),
        ),
        backgroundColor: bgColor,
        duration: duration,
      ),
    );
}

void showSnackBarWithAction(
    BuildContext context, String message, String actionText, Function action) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        message,
        style: TextStyle(
          fontSize: 14.sp,
          color: Colors.white,
        ),
      ),
      backgroundColor: Colors.black,
      action: SnackBarAction(
        label: actionText,
        textColor: Colors.white,
        onPressed: () {
          action();
        },
      ),
    ),
  );
}
