import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


void showSnackBar(BuildContext context, String message) {
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
