import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

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
                    GestureDetector(
                      onTap: () {
                        showModalBottomSheet(
                            backgroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(12),
                                topRight: Radius.circular(12),
                              ),
                            ),
                            context: context,
                            builder: (context) => _buildBottomSheet());
                      },
                      child: Container(
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
                    ),
                  ],
                ),
              ),
              SizedBox(height: 40),

              // Total Customers
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
                              fontSize: 10,
                              fontFamily: 'Gotham',
                              fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),

              // Total Ordered Item
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
                          height: 120,
                          width: 120,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Image.asset('assets/sahachari_image.png'),
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Item Name',
                          style: TextStyle(color: hexToColor('#343434'),
                            fontWeight: FontWeight.w900,
                            fontSize: 12.0,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),

              SizedBox(height: 20),

              // Total Store Visitors & Conversion Rate From New Visitors
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
                        SizedBox(
                          width: 100,
                          child: Text(
                            'Total Store Visitors',
                            style: TextStyle(
                                color: hexToColor('#747474'),
                                fontSize: 14,
                                fontFamily: 'Gotham',
                                fontWeight: FontWeight.w500),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Text(
                          '800k',
                          style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontSize: 28,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        SizedBox(height: 20),
                        SizedBox(
                          width: 100,
                          child: Text(
                            'Conversion Rate',
                            style: TextStyle(
                                color: hexToColor('#747474'),
                                fontSize: 14,
                                fontFamily: 'Gotham',
                                fontWeight: FontWeight.w500),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Text(
                          '0.00%',
                          style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontSize: 28,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 100,
                          child: Text(
                            'New Store Visitors',
                            style: TextStyle(
                                color: hexToColor('#747474'),
                                fontSize: 14,
                                fontFamily: 'Gotham',
                                fontWeight: FontWeight.w500),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Text(
                          '10k',
                          style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontSize: 28,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        SizedBox(height: 20),
                        SizedBox(
                          width: 150,
                          child: Text(
                            'Conversion Rate From New Visitors',
                            style: TextStyle(
                                color: hexToColor('#747474'),
                                fontSize: 14,
                                fontFamily: 'Gotham',
                                fontWeight: FontWeight.w500),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Text(
                          '0.00%',
                          style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontSize: 28,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              SizedBox(height: 20),

              // Average Order Value
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
                      'Average Order Value',
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
                          '₹',
                          style: TextStyle(
                            fontWeight: FontWeight.w900,
                            color: Theme.of(context).primaryColor,
                            fontSize: 30,
                          ),
                        ),
                        Text(
                          '760',
                          style: TextStyle(
                            fontWeight: FontWeight.w900,
                            color: Theme.of(context).primaryColor,
                            fontSize: 30,
                          ),
                        ),
                        SizedBox(width: 8),
                        SizedBox(
                          width: 250,
                          child: Text(
                            'is the average item price that your customer purchases.',
                            style: TextStyle(
                                color: hexToColor('#B0B0B0'),
                                fontSize: 10,
                                fontFamily: 'Gotham',
                                fontWeight: FontWeight.w500),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
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
                        SizedBox(
                          width: 100,
                          child: Text(
                            'Revenue From Store',
                            style: TextStyle(
                                color: hexToColor('#747474'),
                                fontSize: 14,
                                fontFamily: 'Gotham',
                                fontWeight: FontWeight.w500),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          '800k',
                          style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontSize: 28,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        SizedBox(height: 20),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: 100,
                              child: Text(
                                'Tax Amount',
                                style: TextStyle(
                                    color: hexToColor('#747474'),
                                    fontSize: 14,
                                    fontFamily: 'Gotham',
                                    fontWeight: FontWeight.w500),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Text(
                              'platform tax, GST, Middlemen',
                              style: TextStyle(
                                color: hexToColor('#B0B0B0'),
                                fontSize: 8,
                                fontFamily: 'Gotham',
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        Text(
                          '40k',
                          style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontSize: 28,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 100,
                          child: Text(
                            'Net Profit From Store',
                            style: TextStyle(
                                color: hexToColor('#747474'),
                                fontSize: 14,
                                fontFamily: 'Gotham',
                                fontWeight: FontWeight.w500),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          '760k',
                          style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontSize: 28,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        SizedBox(height: 20),
                        SizedBox(
                          width: 150,
                          child: Text(
                            'Store Performance',
                            style: TextStyle(
                                color: hexToColor('#747474'),
                                fontSize: 14,
                                fontFamily: 'Gotham',
                                fontWeight: FontWeight.w500),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        SizedBox(height: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '+0.00%',
                              style: TextStyle(
                                color: Theme.of(context).primaryColor,
                                fontSize: 28,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            Text(
                              'difference compared to last month',
                              style: TextStyle(
                                color: hexToColor('#B0B0B0'),
                                fontSize: 8,
                                fontFamily: 'Gotham',
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBottomSheet() {
    return Container(
      height: 250,
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 100,
              height: 4,
              margin: const EdgeInsets.symmetric(vertical: 15),
              decoration: BoxDecoration(
                color: hexToColor('#CACACA'),
                borderRadius: BorderRadius.circular(5),
              ),
            ),
          ),
          SizedBox(height: 10),
          Text(
            'Print Data As',
            style: TextStyle(
                color: hexToColor('#343434'),
                fontWeight: FontWeight.w900,
                fontSize: 16.0),
          ),
          SizedBox(height: 25),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                children: [
                  Image.asset(
                    'assets/icons/xls.png',
                    scale: 1.5,
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Excel',
                    style: TextStyle(
                        color: hexToColor('#2B2B2B'),
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w500,
                        fontSize: 12.0),
                  ),
                ],
              ),
              Column(
                children: [
                  Image.asset(
                    'assets/icons/jpg.png',
                    scale: 1.5,
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Image',
                    style: TextStyle(
                        color: hexToColor('#2B2B2B'),
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w500,
                        fontSize: 12.0),
                  ),
                ],
              ),
              Column(
                children: [
                  Image.asset(
                    'assets/icons/doc.png',
                    scale: 1.5,
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Doc',
                    style: TextStyle(
                        color: hexToColor('#2B2B2B'),
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w500,
                        fontSize: 12.0),
                  ),
                ],
              ),
              Column(
                children: [
                  Image.asset(
                    'assets/icons/pdf.png',
                    scale: 1.5,
                  ),
                  SizedBox(height: 10),
                  Text(
                    'PDF',
                    style: TextStyle(
                        color: hexToColor('#2B2B2B'),
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w500,
                        fontSize: 12.0),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
