import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_dash/flutter_dash.dart';
import 'package:intl/intl.dart';
import 'package:tnent/helpers/color_utils.dart';
import 'package:tnent/pages/coupon_pages/share_coupon.dart';

class FixedPriceCoupon extends StatefulWidget {
  const FixedPriceCoupon({super.key});

  @override
  State<FixedPriceCoupon> createState() => _FixedPriceCouponState();
}

class _FixedPriceCouponState extends State<FixedPriceCoupon> {
  late TextEditingController _discountController;
  late TextEditingController _orderAmountController;
  late TextEditingController _couponCodeController;
  late TextEditingController _couponLimitController;
  late TextEditingController _expiryDateController;

  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    _discountController = TextEditingController(text: '50');
    _orderAmountController = TextEditingController(text: '2000');
    _couponCodeController = TextEditingController();
    _couponLimitController = TextEditingController();
    _expiryDateController = TextEditingController(text: DateFormat('dd/MM/yyyy').format(DateTime.now().add(Duration(days: 30))));
  }

  GlobalKey _globalKey = GlobalKey();

  @override
  void dispose() {
    _discountController.dispose();
    _orderAmountController.dispose();
    _couponCodeController.dispose();
    _couponLimitController.dispose();
    _expiryDateController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _expiryDateController.text = DateFormat('dd/MM/yyyy').format(_selectedDate!);
      });
    }
  }

  Future<Uint8List?> _capturePng() async {
    try {
      RenderRepaintBoundary boundary = _globalKey.currentContext!
          .findRenderObject() as RenderRepaintBoundary;
      ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      ByteData? byteData =
      await image.toByteData(format: ui.ImageByteFormat.png);
      return byteData?.buffer.asUint8List();
    } catch (e) {
      print(e);
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children:[
                Container(
                  height: 100,
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    children: [
                      Row(
                        children: [
                          Text(
                            'Coupon'.toUpperCase(),
                            style: TextStyle(
                              color: hexToColor('#1E1E1E'),
                              fontSize: 24.0,
                              letterSpacing: 1.5,
                            ),
                          ),
                          Text(
                            ' •',
                            style: TextStyle(
                              fontSize: 24.0,
                              color: hexToColor('#FF0000'),
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
                      )
                    ],
                  ),
                ),
                SizedBox(height: 20),
                RepaintBoundary(
                  key: _globalKey,
                  child: Stack(
                    children: [
                      ClipRRect(
                        child: Image.asset(
                          'assets/coupon_bg.png',
                          width: MediaQuery.of(context).size.width * 0.9,
                        ),
                      ),
                      Positioned(
                        left: 20,
                        top: 20,
                        child: Container(
                          padding:
                          EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20.0),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 1,
                                blurRadius: 5,
                                offset: Offset(0, 3), // changes position of shadow
                              ),
                            ],
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Coupon: ',
                                style: TextStyle(
                                  color: hexToColor('#9A9A9A'),
                                  fontFamily: 'Gotham',
                                  fontWeight: FontWeight.w500,
                                  fontSize: 10.0,
                                ),
                              ),
                              Text(
                                _couponCodeController.text.toUpperCase(),
                                style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w700,
                                  fontSize: 10.0,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 20,
                        left: 30,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  '₹',
                                  style: TextStyle(
                                    color: hexToColor('#343434'),
                                    fontSize: 38.0,
                                  ),
                                ),
                                Text(
                                  _discountController.text,
                                  style: TextStyle(
                                    color: hexToColor('#343434'),
                                    fontSize: 38.0,
                                  ),
                                ),
                                Text(
                                  ' OFF',
                                  style: TextStyle(
                                    color: hexToColor('#343434'),
                                    fontSize: 18.0,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'On all orders ',
                                  style: TextStyle(
                                    color: hexToColor('#9A9A9A'),
                                    fontFamily: 'Gotham',
                                    fontWeight: FontWeight.w500,
                                    fontSize: 14.0,
                                  ),
                                ),
                                _orderAmountController.text.isNotEmpty &&
                                    int.parse(_orderAmountController.text) != 0
                                    ? Text(
                                  'over ₹ ${_orderAmountController.text}',
                                  style: TextStyle(
                                    color: hexToColor('#9A9A9A'),
                                    fontFamily: 'Gotham',
                                    fontWeight: FontWeight.w500,
                                    fontSize: 14.0,
                                  ),
                                )
                                    : Container()
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                Dash(
                  direction: Axis.horizontal,
                  length: MediaQuery.of(context).size.width * 0.9,
                  dashLength: 10,
                  dashColor: hexToColor('#DDDDDD'),
                ),
                SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.only(left: 16.0, right: 50.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextField(
                        controller: _discountController,
                        keyboardType: TextInputType.number,
                        style: TextStyle(
                          fontFamily: 'Gotham',
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                        ),
                        decoration: InputDecoration(
                          labelText: 'Discount Value',
                          prefixIcon: Icon(Icons.currency_rupee),
                          prefixIconConstraints: BoxConstraints(
                            minWidth: 40,
                          ),
                          labelStyle: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontSize: 16,
                          ),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: hexToColor('#848484'),
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),),
                      ),
                      SizedBox(height: 16.0),
                      TextField(
                        controller: _orderAmountController,
                        keyboardType: TextInputType.number,
                        style: TextStyle(
                          fontFamily: 'Gotham',
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                        ),
                        decoration: InputDecoration(
                          labelText: 'On Orders Over',
                          labelStyle: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontSize: 16,
                          ),
                          suffixText: '(optional)',
                          suffixStyle: TextStyle(
                            color: hexToColor('#B1B1B1'),
                            fontFamily: 'Gotham',
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                          ),
                          prefixIcon: Icon(Icons.currency_rupee),
                          prefixIconConstraints: BoxConstraints(
                            minWidth: 40,
                          ),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: hexToColor('#848484'),
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),),
                      ),
                      SizedBox(height: 16.0),
                      TextField(
                        controller: _couponCodeController,
                        style: TextStyle(
                          fontFamily: 'Gotham',
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                        ),
                        decoration: InputDecoration(
                          labelText: 'Coupon Code',
                          labelStyle: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontSize: 16,
                          ),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: hexToColor('#848484'),
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        maxLength: 12,
                      ),
                      SizedBox(height: 16.0),
                      TextField(
                        controller: _couponLimitController,
                        keyboardType: TextInputType.number,
                        style: TextStyle(
                          fontFamily: 'Gotham',
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                        ),
                        decoration: InputDecoration(
                          labelText: 'Coupon Limit',
                          labelStyle: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontSize: 16,
                          ),
                          suffixText: '(Coupons)',
                          suffixStyle: TextStyle(
                            color: hexToColor('#B1B1B1'),
                            fontFamily: 'Gotham',
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                          ),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: hexToColor('#848484'),
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),),
                      ),
                      SizedBox(height: 16.0),
                      TextField(
                        controller: _expiryDateController,
                        readOnly: true,
                        style: TextStyle(
                          fontFamily: 'Gotham',
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                        ),
                        decoration: InputDecoration(
                          labelText: 'Expiry Date',
                          labelStyle: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontSize: 16,
                          ),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: hexToColor('#848484'),
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onTap: () {
                          _selectDate(context);
                        },
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 30.0),
                Center(
                  child: ElevatedButton(
                    onPressed: () async {
                      Uint8List? imageBytes = await _capturePng();
                      if (imageBytes != null) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                ShareCoupon(imageBytes: imageBytes),
                          ),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: hexToColor('#2D332F'),
                      // Set the button color to black
                      foregroundColor: Colors.white,
                      // Set the text color to white
                      padding: EdgeInsets.symmetric(
                          horizontal: 100, vertical: 18),
                      // Set the padding
                      textStyle: TextStyle(
                        fontSize: 16, // Set the text size
                        fontFamily: 'Gotham',
                        fontWeight: FontWeight.w500, // Set the text weight
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                            30), // Set the button corner radius
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('Generate Coupon', style: TextStyle(fontSize: 16)),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 50.0),
              ]
          ),
        ),
      ),
    );
  }
}
