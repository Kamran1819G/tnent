import 'package:flutter/material.dart';
import 'package:tnent/core/helpers/color_utils.dart';
import 'package:tnent/presentation/pages/delivery_service_pages/deliver_from_me.dart';
import 'package:tnent/presentation/pages/delivery_service_pages/deliver_to_me.dart';
import 'package:tnent/presentation/pages/delivery_service_pages/deliver_product.dart';

class DeliverAnythingAnywhere extends StatefulWidget {
  const DeliverAnythingAnywhere({Key? key}) : super(key: key);

  @override
  State<DeliverAnythingAnywhere> createState() =>
      _DeliverAnythingAnywhereState();
}

class _DeliverAnythingAnywhereState extends State<DeliverAnythingAnywhere> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DeliveryPageBody(),
    );
  }
}

class DeliveryPageBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          HeaderSection(),
          SizedBox(height: 20),
          DescriptionSection(),
          SizedBox(height: 20),
          DeliveryOptionsSection(),
          Spacer(),
          DeliveryProductButton(),
          SizedBox(height: 10),
        ],
      ),
    );
  }
}

class HeaderSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.3,
      child: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.3,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/delivery_service_bg_1.png'),
                fit: BoxFit.fill,
              ),
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: HeaderAppBar(),
          ),
          HeaderTitle(),
        ],
      ),
    );
  }
}

class HeaderAppBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 75,
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Image.asset('assets/black_tnent_logo.png', width: 30, height: 30),
          Spacer(),
          IconButton(
            icon: Icon(Icons.arrow_back_ios_new, color: Colors.black),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }
}

class HeaderTitle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment(0, 0.1),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Text(
          'Deliver Anything Anywhere Easily',
          style: TextStyle(
            color: hexToColor('#2A2A2A'),
            fontSize: 34,
          ),
        ),
      ),
    );
  }
}

class DescriptionSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Text(
        'Check all your recent & ongoing delivery details just in one click',
        style: TextStyle(
          color: hexToColor('#2A2A2A'),
          fontFamily: 'Gotham',
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

class DeliveryOptionsSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        DeliveryOption(
          title: 'to me',
          color: hexToColor('#EFEFEF'),
          textColor: hexToColor('#FF0000'),
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => DeliverToMe()),
          ),
        ),
        SizedBox(height: 20),
        DeliveryOption(
          title: 'from me',
          color: hexToColor('#FFDFDF'),
          textColor: hexToColor('#34A853'),
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => DeliverFromMe()),
          ),
        ),
      ],
    );
  }
}

class DeliveryOption extends StatelessWidget {
  final String title;
  final Color color;
  final Color textColor;
  final VoidCallback onTap;

  const DeliveryOption({
    required this.title,
    required this.color,
    required this.textColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.45,
        margin: EdgeInsets.symmetric(horizontal: 16.0),
        padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 30.0),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'Deliver',
                  style: TextStyle(
                    fontSize: 24.0,
                    height: 1,
                  ),
                ),
                Text(
                  ' •',
                  style: TextStyle(
                    fontSize: 18.0,
                    color: textColor,
                    height: 1,
                  ),
                ),
              ],
            ),
            Text(
              title,
              style: TextStyle(
                fontSize: 24.0,
              ),
            ),
            SizedBox(height: 16),
            Text(
              title.contains('to')
                  ? 'See all the deliveries you have received'
                  : 'See all deliveries I have sent',
              style: TextStyle(
                color: hexToColor('#6B6B6B'),
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w400,
                fontSize: 12.0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DeliveryProductButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => DeliverProduct()),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: hexToColor('#2D332F'),
          foregroundColor: Colors.white,
          padding: EdgeInsets.symmetric(horizontal: 100, vertical: 18),
          textStyle: TextStyle(
            fontSize: 16,
            fontFamily: 'Gotham',
            fontWeight: FontWeight.w500,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(100),
          ),
        ),
        child: Text('Deliver Product', style: TextStyle(fontSize: 16)),
      ),
    );
  }
}
