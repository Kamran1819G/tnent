import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quickalert/quickalert.dart';
import 'package:toastification/toastification.dart';

void showSnackBar(
  BuildContext context,
  String? message, {
  ToastificationType toastificationType = ToastificationType.info,
  ToastificationStyle toastificationStyle = ToastificationStyle.simple,
  Widget leadIcon = const Icon(
    Icons.warning_amber_rounded,
    color: Colors.white,
  ),
  Color bgColor = const Color.fromRGBO(49, 49, 49, 0.98), // dark green
  // Color bgColor = const Color.fromRGBO(159, 168, 218, 1), // purple
  Duration duration = const Duration(seconds: 4),
}) {
  if (!context.mounted) return;

  toastification.show(
    context: context,
    style: toastificationStyle,
    type: toastificationType,
    borderSide: const BorderSide(color: Colors.transparent),
    title: Text(
      message!,
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 16.sp,
        color: Colors.white,
        fontFamily: 'Poppins',
        fontWeight: FontWeight.w500,
      ),
    ),
    icon: leadIcon,
    backgroundColor: bgColor,
    autoCloseDuration: duration,
    alignment: Alignment.topCenter,
  );
}

void showSnackBarWithAction(BuildContext context,
    {required String text,
    required VoidCallback action,
    String confirmBtnText = 'Yes',
    String cancelBtnText = 'No',
    Color confirmBtnColor = Colors.black,
    double buttonTextFontsize = 16,
    Color bgColor = Colors.white,
    QuickAlertType quickAlertType = QuickAlertType.confirm}) {
  QuickAlert.show(
    showCancelBtn: true,
    context: context,
    type: quickAlertType,
    text: text,
    cancelBtnTextStyle:
        TextStyle(fontSize: buttonTextFontsize, color: Colors.grey),
    confirmBtnTextStyle:
        TextStyle(fontSize: buttonTextFontsize, color: Colors.white),
    confirmBtnText: confirmBtnText,
    cancelBtnText: cancelBtnText,
    confirmBtnColor: confirmBtnColor,
    onConfirmBtnTap: action,
    backgroundColor: bgColor,
    onCancelBtnTap: () {
      Navigator.of(context).pop();
    },
  );
}
