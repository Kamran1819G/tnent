import 'package:flutter/material.dart';

class Catalog extends StatefulWidget {
  const Catalog({super.key});

  @override
  State<Catalog> createState() => _CatalogState();
}

class _CatalogState extends State<Catalog> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
      SizedBox(height: 40.0),
      Container(
      height: 100,
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      child: Expanded(
        child: RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: 'Catalog'.toUpperCase(),
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w900,
                  fontSize: 28.0,
                  letterSpacing: 1.5,
                ),
              ),
              TextSpan(
                text: ' •',
                style: TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: 28.0,
                  color: Colors.yellow,
                ),
              ),
            ],
          ),
        ),
      ),
    ),
      ],
    );
  }
}
