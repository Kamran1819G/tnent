import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tnent/core/helpers/color_utils.dart';
import 'package:tnent/core/helpers/text_utils.dart';

class StoreConnectionNotification extends StatelessWidget {
  final String name;
  final String time;

  StoreConnectionNotification({
    required this.name,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 20.h, horizontal: 20.w),
      child: ListTile(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              time,
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w900,
                fontFamily: 'Poppins',
                fontSize: 16.sp,
              ),
            ),
            SizedBox(height: 6.h),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  name,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 19.sp,
                  ),
                ),
                SizedBox(width: 12.sp),
                Text(
                  'connected to your store',
                  style: TextStyle(
                    color: hexToColor('#343434'),
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w500,
                    fontSize: 19.sp,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
