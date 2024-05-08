import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:tnennt/models/location_details_model.dart';
import 'package:tnennt/pages/delivery_service_pages/upload_and_verify_document.dart';

import '../../helpers/color_utils.dart';
import 'enter_location_details.dart';

class DeliverProduct extends StatefulWidget {
  const DeliverProduct({super.key});

  @override
  State<DeliverProduct> createState() => _DeliverProductState();
}

class _DeliverProductState extends State<DeliverProduct> {
  String _selectedParcelType = '';
  LocationDetails? _pickupDetails;
  LocationDetails? _dropDetails;

  final TextEditingController _pickupLocationController =
      TextEditingController();
  final TextEditingController _dropLocationController = TextEditingController();

  @override
  void dispose() {
    _pickupLocationController.dispose();
    _dropLocationController.dispose();
    super.dispose();
  }



  void _setPickupLocation(LocationDetails pickupDetails) {
    setState(() {
      _pickupDetails = pickupDetails;
      _pickupLocationController.text = pickupDetails.addressLine1;
    });
  }

  void _setDropLocation(LocationDetails dropDetails) {
    setState(() {
      _dropDetails = dropDetails;
      _dropLocationController.text = dropDetails.addressLine1;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
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
                  Container(
                    height: 75,
                    padding: EdgeInsets.only(left: 16, right: 8),
                    child: Row(
                      children: [
                        Image.asset('assets/black_tnennt_logo.png',
                            width: 30, height: 30),
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
                  Container(
                    alignment: Alignment(0, 0.1),
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    width: MediaQuery.of(context).size.width * 0.85,
                    child: Text(
                      'Enter Your Delivery Address & Parcel Details',
                      style: TextStyle(
                        color: hexToColor('#2A2A2A'),
                        fontSize: 34,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  )
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Stack(
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width * 0.35,
                          height: MediaQuery.of(context).size.height * 0.25,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage(
                                  'assets/delivery_service_bg_2.png'),
                              fit: BoxFit.fill,
                              colorFilter: ColorFilter.mode(
                                  Colors.white.withOpacity(0.1),
                                  BlendMode.softLight),
                            ),
                          ),
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              height: 150,
                              width: 20,
                              margin: EdgeInsets.only(left: 16, right: 8),
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: AssetImage(
                                      'assets/src_to_dest_graphic.png'),
                                  fit: BoxFit.fill,
                                ),
                              ),
                            ),
                            SizedBox(width: 10),
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.3,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Pickup Details',
                                    style: TextStyle(
                                      color: hexToColor('#2A2A2A'),
                                      fontSize: 16,
                                      fontWeight: FontWeight.w900,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 16,
                                  ),
                                  Row(
                                    children: [
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.7,
                                        child: TextField(
                                          controller: _pickupLocationController,
                                          cursorColor:
                                              Theme.of(context).primaryColor,
                                          style: TextStyle(
                                            fontFamily: 'Gotham',
                                            fontWeight: FontWeight.w500,
                                            fontSize: 16,
                                          ),
                                          onTap: () async {
                                            final pickupDetails = await Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => EnterLocationDetails(
                                                  onSubmit: _setPickupLocation,
                                                  type: "Pickup",
                                                ),
                                              ),
                                            );
                                            if (pickupDetails != null) {
                                              _setPickupLocation(pickupDetails);
                                            }
                                          },
                                          decoration: InputDecoration(
                                            floatingLabelBehavior:
                                                FloatingLabelBehavior.always,
                                            label: Text('Location'),
                                            labelStyle: TextStyle(
                                              color: hexToColor('#545454'),
                                              fontWeight: FontWeight.w900,
                                              fontSize: 16,
                                            ),
                                            focusColor:
                                                Theme.of(context).primaryColor,
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color: Theme.of(context)
                                                    .primaryColor,
                                                width: 1,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                            prefixIcon: Image.asset(
                                              'assets/icons/globe.png',
                                              width: 16,
                                              height: 16,
                                            ),
                                            prefixIconConstraints:
                                                BoxConstraints(
                                              minWidth: 40,
                                            ),
                                            hintText: 'Pickup item from...',
                                            hintStyle: TextStyle(
                                              color: Colors.black,
                                              fontFamily: 'Gotham',
                                              fontWeight: FontWeight.w500,
                                              fontSize: 16,
                                            ),
                                            border: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color: hexToColor('#848484'),
                                                width: 1,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                          ),
                                          keyboardType: TextInputType.none,
                                        ),
                                      ),
                                      if (_pickupLocationController
                                          .text.isNotEmpty)
                                        IconButton(
                                          icon: Image.asset(
                                            'assets/icons/delete.png',
                                            width: 20,
                                          ),
                                          onPressed: () {
                                            _pickupLocationController.clear();
                                          },
                                        ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 40,
                                  ),
                                  Text(
                                    'Shipment Details',
                                    style: TextStyle(
                                      color: hexToColor('#2A2A2A'),
                                      fontSize: 16,
                                      fontWeight: FontWeight.w900,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 16,
                                  ),
                                  Row(
                                    children: [
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.7,
                                        child: TextField(
                                          controller: _dropLocationController,
                                          cursorColor:
                                              Theme.of(context).primaryColor,
                                          style: TextStyle(
                                            fontFamily: 'Gotham',
                                            fontWeight: FontWeight.w500,
                                            fontSize: 16,
                                          ),
                                          onTap: () async {
                                            final dropDetails = await Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => EnterLocationDetails(
                                                  onSubmit: _setDropLocation,
                                                  type: "Shipment",
                                                ),
                                              ),
                                            );
                                            if (dropDetails != null) {
                                              _setDropLocation(dropDetails);
                                            }
                                          },
                                          decoration: InputDecoration(
                                            floatingLabelBehavior:
                                                FloatingLabelBehavior.always,
                                            label: Text('Location'),
                                            labelStyle: TextStyle(
                                              color: hexToColor('#545454'),
                                              fontWeight: FontWeight.w900,
                                              fontSize: 16,
                                            ),
                                            prefixIcon: Image.asset(
                                              'assets/icons/globe.png',
                                              width: 16,
                                              height: 16,
                                            ),
                                            prefixIconConstraints:
                                                BoxConstraints(
                                              minWidth: 40,
                                            ),
                                            hintText: 'Drop item to...',
                                            hintStyle: TextStyle(
                                              color: Colors.black,
                                              fontFamily: 'Gotham',
                                              fontWeight: FontWeight.w500,
                                              fontSize: 16,
                                            ),
                                            focusColor:
                                                Theme.of(context).primaryColor,
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color: Theme.of(context)
                                                    .primaryColor,
                                                width: 1,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                            border: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color: hexToColor('#848484'),
                                                width: 1,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                          ),
                                          keyboardType: TextInputType.none,
                                        ),
                                      ),
                                      if (_dropLocationController
                                          .text.isNotEmpty)
                                        IconButton(
                                          icon: Image.asset(
                                            'assets/icons/delete.png',
                                            width: 20,
                                          ),
                                          onPressed: () {
                                            _dropLocationController.clear();
                                          },
                                        ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 25, vertical: 10),
                          child: Text(
                            'Parcel Details',
                            style: TextStyle(
                              color: hexToColor('#2A2A2A'),
                              fontSize: 16,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(
                            top: 10,
                          ),
                          height: 175,
                          padding: EdgeInsets.symmetric(horizontal: 30),
                          child: GridView.count(
                            physics: NeverScrollableScrollPhysics(),
                            crossAxisCount: 2,
                            crossAxisSpacing: 30,
                            mainAxisSpacing: 20,
                            childAspectRatio: 2.5,
                            children: [
                              _buildParcelDetailCard(
                                  'Small', '10gm - 500gm', 'assets/weight.png'),
                              _buildParcelDetailCard(
                                  'Medium', '500gm - 3kg', 'assets/weight.png'),
                              _buildParcelDetailCard(
                                  'Large', '3kg - 7kg', 'assets/weight.png'),
                              _buildParcelDetailCard('Extra Large',
                                  '7kg - 14kg', 'assets/weight.png'),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 25, vertical: 10),
                          child: Text(
                            'Parcel Worth',
                            style: TextStyle(
                              color: hexToColor('#2A2A2A'),
                              fontSize: 16,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 10),
                          height: 100,
                          padding: EdgeInsets.symmetric(horizontal: 25),
                          child: TextField(
                            style: TextStyle(
                              fontFamily: 'Gotham',
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                            ),
                            decoration: InputDecoration(
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.always,
                              label: Text('Enter Parcel Worth'),
                              labelStyle: TextStyle(
                                color: hexToColor('#545454'),
                                fontWeight: FontWeight.w900,
                                fontSize: 16,
                              ),
                              prefixIcon: Icon(
                                Icons.currency_rupee,
                                size: 20,
                              ),
                              prefixIconConstraints: BoxConstraints(
                                minWidth: 40,
                              ),
                              prefixIconColor: Theme.of(context).primaryColor,
                              hintText: '100 - 10,000',
                              hintStyle: TextStyle(
                                color: Colors.black,
                                fontFamily: 'Gotham',
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                              ),
                              border: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: hexToColor('#848484'),
                                  width: 1,
                                ),
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            keyboardType: TextInputType.number,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 10),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => UploadAndVerifyDocument(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: hexToColor('#2D332F'),
                  // Set the button color to black
                  foregroundColor: Colors.white,
                  // Set the text color to white
                  padding: EdgeInsets.symmetric(horizontal: 100, vertical: 18),
                  // Set the padding
                  textStyle: TextStyle(
                    fontSize: 16, // Set the text size
                    fontFamily: 'Gotham',
                    fontWeight: FontWeight.w500, // Set the text weight
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                        100), // Set the button corner radius
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('Next Process', style: TextStyle(fontSize: 16)),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }

  _buildParcelDetailCard(String title, String value, String iconPath) {
    bool isSelected = title == _selectedParcelType;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedParcelType = isSelected ? '' : title;
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Theme.of(context).primaryColor : Colors.white,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(
            color: isSelected
                ? Theme.of(context).primaryColor
                : hexToColor('#848484'),
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                color: isSelected ? Colors.white : hexToColor('#545454'),
                fontSize: 14,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(
              height: 4,
            ),
            Text(
              'Wt. $value',
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.black,
                fontFamily: 'Poppins',
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
