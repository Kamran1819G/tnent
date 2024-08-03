import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../helpers/color_utils.dart';

class PaymentsScreen extends StatefulWidget {
  const PaymentsScreen({super.key});

  @override
  State<PaymentsScreen> createState() => _PaymentsScreenState();
}

class _PaymentsScreenState extends State<PaymentsScreen> {
  String selectedPeriod = 'January';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 100.h,
              margin: EdgeInsets.only(top: 20.h, bottom: 20.h),
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          Text(
                            'Payments'.toUpperCase(),
                            style: TextStyle(
                              color: hexToColor('#1E1E1E'),
                              fontSize: 35.sp,
                              letterSpacing: 1.5,
                            ),
                          ),
                          Text(
                            ' •',
                            style: TextStyle(
                              fontSize: 35.sp,
                              color: hexToColor('#42FF00'),
                            ),
                          ),
                        ],
                      ),
                      Text(
                        'My Earnings',
                        style: TextStyle(
                          color: hexToColor('#9C9C9C'),
                          fontWeight: FontWeight.w500,
                          fontFamily: 'Gotham',
                          fontSize: 20.sp,
                        ),
                      ),
                    ],
                  ),
                  Spacer(),
                  IconButton(
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all(
                        Colors.grey[100],
                      ),
                      shape: WidgetStateProperty.all(
                        CircleBorder(),
                      ),
                    ),
                    icon: Icon(Icons.arrow_back_ios_new, color: Colors.black),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            ),
            Container(
              height: 105.h,
              width: 610.w,
              margin: EdgeInsets.symmetric(horizontal: 12.w, vertical: 30.w),
              padding: EdgeInsets.only(left: 12.w),
              alignment: Alignment.centerLeft,
              decoration: BoxDecoration(
                color: hexToColor('#F5F5F5'),
                borderRadius: BorderRadius.circular(26.r),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    height: 90.h,
                    width: 90.w,
                    decoration: BoxDecoration(
                      color: hexToColor('#FFFFFF'),
                      borderRadius: BorderRadius.circular(18.r),
                    ),
                    child: Icon(Icons.credit_card_rounded,
                        color: hexToColor('#1E1E1E')),
                  ),
                  SizedBox(width: 20.w),
                  Text(
                    'UPI ID:',
                    style: TextStyle(
                      color: hexToColor('#272822'),
                      fontFamily: 'Poppins',
                      fontSize: 19.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Text(
                    'worldsxtreme2910@oksbi',
                    style: TextStyle(
                      color: hexToColor('#838383'),
                      fontFamily: 'Gotham',
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  )
                ],
              ),
            ),
            SizedBox(height: 50.h),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 18.w),
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Monthly Earning',
                        style: TextStyle(
                          color: hexToColor('#838383'),
                          fontSize: 24.sp,
                        ),
                      ),
                      Text(
                        '₹25k',
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontSize: 24.sp,
                          height: 1.5,
                        ),
                      )
                    ],
                  ),
                  Spacer(),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: hexToColor('#AFAFAF'),
                        width: 1.0,
                      ),
                      borderRadius: BorderRadius.circular(50.0),
                    ),
                    child: DropdownButton<String>(
                      padding: EdgeInsets.symmetric(horizontal: 24.w),
                      style: TextStyle(
                        color: hexToColor('#272822'),
                        fontFamily: 'Gotham Black',
                        fontSize: 20.sp,
                      ),
                      icon: Icon(Icons.keyboard_arrow_down_rounded),
                      underline: SizedBox(),
                      value: selectedPeriod,
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedPeriod = newValue!;
                        });
                      },
                      items: <String>[
                        'January',
                        'February',
                        'March',
                        'April',
                        'May',
                        'June',
                        'July',
                        'August',
                        'September',
                        'October',
                        'November',
                        'December',
                      ].map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 30.h),
            Expanded(
              child: ListView.separated(
                shrinkWrap: true,
                itemCount: 10,
                separatorBuilder: (context, index) => SizedBox(height: 20.h),
                itemBuilder: (context, index) {
                  return PaymentInfoTile();
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}

class PaymentInfoTile extends StatelessWidget {
  const PaymentInfoTile({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 12.w),
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Order ID:',
                    style: TextStyle(
                      color: hexToColor('#343434'),
                      fontSize: 14.sp,
                    ),
                  ),
                  SizedBox(width: 8.0),
                  Text(
                    '123456',
                    style: TextStyle(
                      color: hexToColor('#747474'),
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Poppins',
                    ),
                  ),
                ],
              ),
              Text(
                'May 7, 2023, 15:43 pm',
                style: TextStyle(
                  color: hexToColor('#747474'),
                  fontFamily: 'Poppins',
                  fontSize: 12.sp,
                ),
              ),
            ],
          ),
          SizedBox(height: 40.sp),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(
                    'Payment Mode:',
                    style: TextStyle(
                      color: hexToColor('#343434'),
                      fontSize: 17.sp,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w600,
                    ), //TextStyle
                  ),
                  SizedBox(width: 12.w),
                  Text(
                    'UPI',
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontSize: 17.sp,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'Poppins',
                    ),
                  ),
                ],
              ),
              Text(
                '₹ 2500',
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontSize: 32.sp,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
