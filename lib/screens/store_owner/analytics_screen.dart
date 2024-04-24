import 'package:flutter/material.dart';

import '../../helpers/color_utils.dart';

class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({super.key});

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {
  String selectedPeriod = 'Today';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
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
                              'Analytics'.toUpperCase(),
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
                          'See Your Business Insights & Store Metrics',
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
                          icon: Icon(Icons.arrow_back_ios_new,
                              color: Colors.black),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.0),
                child: Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: hexToColor('#AFAFAF'),
                          width: 1.0,
                        ),
                        borderRadius: BorderRadius.circular(
                            50.0), // Adjust the radius as needed
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
                          'Today',
                          'Yesterday',
                          'Last 7 Days',
                          'Last 30 Days'
                        ].map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                    ),
                    Spacer(),
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                      decoration: BoxDecoration(
                        color: hexToColor('#131312'),
                        borderRadius: BorderRadius.circular(50.0),
                      ),
                      child: Text(
                        'Print Data',
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w600,
                          fontSize: 14.0,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 40),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 12),
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(color: hexToColor('#AFAFAF')),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Total Customers',
                      style: TextStyle(
                        fontWeight: FontWeight.w900,
                        color: hexToColor('#272822'),
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          '760',
                          style: TextStyle(
                            fontWeight: FontWeight.w900,
                            color: Theme.of(context).primaryColor,
                            fontSize: 30,
                          ),
                        ),
                        SizedBox(width: 8),
                        Text(
                          'customers engaged to your store.',
                          style: TextStyle(
                              color: hexToColor('#B0B0B0'),
                              fontSize: 12,
                              fontFamily: 'Gotham',
                              fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 12),
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(color: hexToColor('#AFAFAF')),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Total Ordered item',
                          style: TextStyle(
                            fontWeight: FontWeight.w900,
                            color: hexToColor('#272822'),
                            fontSize: 18,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          'Product Lifetime Sell',
                          style: TextStyle(
                              color: hexToColor('#747474'),
                              fontSize: 14,
                              fontFamily: 'Gotham',
                              fontWeight: FontWeight.w500),
                        ),
                        Text(
                          '100',
                          style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontSize: 28,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Contributing About',
                          style: TextStyle(
                              color: hexToColor('#747474'),
                              fontSize: 14,
                              fontFamily: 'Gotham',
                              fontWeight: FontWeight.w500),
                        ),
                        Row(
                          children: [
                            Text(
                              '0.00%',
                              style: TextStyle(
                                color: Theme.of(context).primaryColor,
                                fontSize: 28,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            SizedBox(width: 8),
                            Text(
                              'of the store sales',
                              style: TextStyle(
                                  color: hexToColor('#B0B0B0'),
                                  fontSize: 10,
                                  fontFamily: 'Gotham',
                                  fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: 100,
                          width: 100,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Image.asset('assets/updates_image.png'),
                        ),
                        SizedBox(height: 20),
                        Text(
                          'Item Name',
                          style: TextStyle(color: hexToColor('#343434')),
                        ),
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
