import 'package:flutter/material.dart';

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
              height: 100,
              padding: EdgeInsets.symmetric(horizontal: 16.0),
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
                              fontWeight: FontWeight.w900,
                              fontSize: 24.0,
                              letterSpacing: 1.5,
                            ),
                          ),
                          Text(
                            ' •',
                            style: TextStyle(
                              fontWeight: FontWeight.w900,
                              fontSize: 28.0,
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
                          fontSize: 12.0,
                        ),
                      ),
                    ],
                  ),
                  Spacer(),
                  Container(
                    margin: EdgeInsets.all(8.0),
                    child: CircleAvatar(
                      backgroundColor: Colors.grey[100],
                      child: IconButton(
                        icon:
                            Icon(Icons.arrow_back_ios_new, color: Colors.black),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 8.0),
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
              decoration: BoxDecoration(
                color: hexToColor('#F5F5F5'),
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: hexToColor('#FFFFFF'),
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    child: Icon(Icons.credit_card_rounded,
                        color: hexToColor('#1E1E1E')),
                  ),
                  SizedBox(width: 16.0),
                  Text(
                    'UPI ID:',
                    style: TextStyle(
                      color: hexToColor('#272822'),
                      fontFamily: 'Poppins',
                      fontSize: 14.0,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(width: 8.0),
                  Text(
                    'worldsxtreme2910@oksbi',
                    style: TextStyle(
                      color: hexToColor('#838383'),
                      fontFamily: 'Gotham',
                      fontSize: 14.0,
                      fontWeight: FontWeight.w500,
                    ),
                  )
                ],
              ),
            ),
            SizedBox(height: 40.0),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12.0),
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Monthly Earning',
                        style: TextStyle(
                          color: hexToColor('#838383'),
                          fontWeight: FontWeight.w900,
                          fontSize: 18.0,
                        ),
                      ),
                      Text(
                        '₹25k',
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.w900,
                          fontSize: 18.0,
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
                      padding: EdgeInsets.symmetric(horizontal: 25.0),
                      style: TextStyle(
                        color: hexToColor('#272822'),
                        fontWeight: FontWeight.w900,
                        fontSize: 16.0,
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
            SizedBox(height: 20.0),
            ListView.separated(
              shrinkWrap: true,
              itemCount: 5,
              separatorBuilder: (context, index) => SizedBox(height: 10.0),
              itemBuilder: (context, index) {
                return PaymentInfoTile();
              },
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
      margin: EdgeInsets.symmetric(horizontal: 8.0),
      padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
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
                      fontSize: 10,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  SizedBox(width: 8.0),
                  Text(
                    '123456',
                    style: TextStyle(
                      color: hexToColor('#747474'),
                      fontSize: 10,
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
                  fontSize: 10,
                ),
              ),
            ],
          ),
          SizedBox(height: 20.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(
                    'Payment Mode:',
                    style: TextStyle(
                      color: hexToColor('#343434'),
                      fontSize: 12,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w600,
                    ), //TextStyle
                  ),
                  SizedBox(width: 8.0),
                  Text(
                    'UPI',
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'Poppins',
                    ),
                  ),
                ],
              ),
              Text(
                '₹ 2500',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).primaryColor,
                  fontSize: 24.0,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
