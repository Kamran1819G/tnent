import 'package:flutter/material.dart';

class ShareCoupon extends StatefulWidget {
  const ShareCoupon({super.key});

  @override
  State<ShareCoupon> createState() => _ShareCouponState();
}

class _ShareCouponState extends State<ShareCoupon> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Text('Share Coupon Page'),
          ],
        ),
      ),
    );
  }
}
