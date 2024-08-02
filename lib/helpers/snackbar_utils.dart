import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quickalert/quickalert.dart';
import 'package:toastification/toastification.dart';

void showSnackBar(
  BuildContext context,
  String? message, {
  ToastificationType toastificationType = ToastificationType.info,
  ToastificationStyle toastificationStyle = ToastificationStyle.flat,
  Widget leadIcon = const Icon(
    Icons.warning_amber_rounded,
    color: Colors.white,
  ),
  Color bgColor = Colors.red,
  Duration duration = const Duration(seconds: 4),
}) {
  if (!context.mounted) return;

  toastification.show(
    context: context,
    style: ToastificationStyle.flat,
    type: ToastificationType.info,
    title: Text(
      message!,
      style: TextStyle(
        fontSize: 14.sp,
        color: Colors.white,
        fontFamily: 'Poppins',
        fontWeight: FontWeight.w500,
      ),
    ),
    icon: leadIcon,
    backgroundColor: bgColor,
    autoCloseDuration: duration,
    alignment: Alignment.bottomCenter,
  );
}

void showSnackBarWithAction(BuildContext context,
    {required String text,
    required VoidCallback action,
    String confirmBtnText = 'Yes',
    String cancelBtnText = 'No',
    Color confirmBtnColor = Colors.black,
    QuickAlertType quickAlertType = QuickAlertType.confirm}) {
  QuickAlert.show(
    context: context,
    type: quickAlertType,
    text: text,
    confirmBtnText: confirmBtnText,
    cancelBtnText: cancelBtnText,
    confirmBtnColor: confirmBtnColor,
    onConfirmBtnTap: action,
    onCancelBtnTap: () {
      Navigator.of(context).pop();
    },
  );
}
