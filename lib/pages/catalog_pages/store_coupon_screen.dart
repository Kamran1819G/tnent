import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tnent/helpers/color_utils.dart';

class StoreCouponScreen extends StatefulWidget {
  const StoreCouponScreen({super.key});

  @override
  State<StoreCouponScreen> createState() => _StoreCouponScreenState();
}

class _StoreCouponScreenState extends State<StoreCouponScreen> {
  int selectedCheckboxIndex = -1;

  // Assume these are the coupon values
  final List<double> couponValues = [10.0, 15.0, 20.0, 25.0, 30.0];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // ... (previous header code remains unchanged)

            Expanded(
              child: ListView.separated(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                itemCount: 5,
                separatorBuilder: (context, index) => SizedBox(height: 16.0),
                itemBuilder: (context, index) {
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/sample_coupon_horiz.png',
                        width: MediaQuery.of(context).size.width * 0.8,
                      ),
                      SizedBox(width: 10.0),
                      Checkbox(
                        visualDensity: VisualDensity.compact,
                        value: selectedCheckboxIndex == index,
                        checkColor: Colors.white,
                        activeColor: Theme.of(context).primaryColor,
                        onChanged: (value) {
                          setState(() {
                            selectedCheckboxIndex = value! ? index : -1;
                          });
                          if (value! && selectedCheckboxIndex != -1) {
                            // Pass the selected coupon value to the checkout page
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CheckoutPage(couponValue: couponValues[selectedCheckboxIndex]),
                              ),
                            );
                          }
                        },
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// This is a placeholder for the CheckoutPage
class CheckoutPage extends StatelessWidget {
  final double couponValue;

  const CheckoutPage({Key? key, required this.couponValue}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Checkout')),
      body: Center(
        child: Text('Selected Coupon Value: \$${couponValue.toStringAsFixed(2)}'),
      ),
    );
  }
}