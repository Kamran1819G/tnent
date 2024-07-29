import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tnennt/helpers/color_utils.dart';

class StoreConnectionNotification extends StatelessWidget {
  final String name;
  final String image;
  final String time;

  StoreConnectionNotification({
    required this.name,
    required this.image,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 20.h),
      child: ListTile(
        leading: CircleAvatar(
          radius: 36.w,
          child: Image.network(image),
        ),
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
