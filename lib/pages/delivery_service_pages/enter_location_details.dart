import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:tnennt/models/location_details_model.dart';

import '../../helpers/color_utils.dart';

class EnterLocationDetails extends StatefulWidget {
  final Function(LocationDetails) onSubmit;
  final String type;

  EnterLocationDetails({required this.onSubmit, required this.type});
  @override
  State<EnterLocationDetails> createState() => _EnterLocationDetailsState();
}

class _EnterLocationDetailsState extends State<EnterLocationDetails> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _addressLine1Controller = TextEditingController();
  TextEditingController _addressLine2Controller = TextEditingController();
  TextEditingController _zipController = TextEditingController();
  TextEditingController _cityController = TextEditingController();
  TextEditingController _stateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.2,
                child: Stack(
                  children: [
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
                      alignment: Alignment(0, 1),
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      width: MediaQuery.of(context).size.width * 0.8,
                      child: Text(
                        'Enter ${widget.type} Details',
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
              SizedBox(
                height: 50,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.8,
                      child: TextField(
                        controller: _nameController,
                        style: TextStyle(
                          color: hexToColor('#2A2A2A'),
                          fontFamily: 'Gotham',
                          fontSize: 14,
                          fontWeight: FontWeight.w900,
                        ),
                        decoration: InputDecoration(
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          labelText: 'Name',
                          labelStyle: TextStyle(
                            color: hexToColor('#545454'),
                            fontSize: 16,
                            fontWeight: FontWeight.w900,
                          ),
                          hintText: 'Enter Name',
                          hintStyle: TextStyle(
                            color: hexToColor('#545454'),
                            fontSize: 14,
                            fontWeight: FontWeight.w900,
                          ),
                          prefixIcon: Icon(Icons.person_outline),
                          prefixIconColor: Theme.of(context).primaryColor,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                              color: hexToColor('#2A2A2A'),
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                              color: hexToColor('#2A2A2A'),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 35,
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.8,
                      child: TextField(
                        controller: _phoneController,
                        style: TextStyle(
                          color: hexToColor('#2A2A2A'),
                          fontFamily: 'Gotham',
                          fontSize: 14,
                          fontWeight: FontWeight.w900,
                        ),
                        decoration: InputDecoration(
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          labelText: 'Mobile Number',
                          labelStyle: TextStyle(
                            color: hexToColor('#545454'),
                            fontSize: 16,
                            fontWeight: FontWeight.w900,
                          ),
                          hintText: ' XXXXX-XXXXX',
                          hintStyle: TextStyle(
                            color: hexToColor('#545454'),
                            fontSize: 14,
                            fontWeight: FontWeight.w900,
                          ),
                          prefixIcon: Icon(Icons.phone_outlined),
                          prefixIconColor: Theme.of(context).primaryColor,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                              color: hexToColor('#2A2A2A'),
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                              color: hexToColor('#2A2A2A'),
                            ),
                          ),
                        ),
                        keyboardType: TextInputType.phone,
                      ),
                    ),
                    SizedBox(
                      height: 35,
                    ),
                    SizedBox(
                      child: TextField(
                        controller: _addressLine1Controller,
                        style: TextStyle(
                          color: hexToColor('#2A2A2A'),
                          fontFamily: 'Gotham',
                          fontSize: 14,
                          fontWeight: FontWeight.w900,
                        ),
                        decoration: InputDecoration(
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          labelText: 'Flat/ Housing No./ Building/ Apartment',
                          labelStyle: TextStyle(
                            color: hexToColor('#545454'),
                            fontSize: 16,
                            fontWeight: FontWeight.w900,
                          ),
                          hintText: 'Address Line 1',
                          hintStyle: TextStyle(
                            color: hexToColor('#545454'),
                            fontSize: 14,
                            fontWeight: FontWeight.w900,
                          ),
                          prefixIcon: Image.asset('assets/icons/globe.png', width: 10, height: 10),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                              color: hexToColor('#2A2A2A'),
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                              color: hexToColor('#2A2A2A'),
                            ),
                          ),
                        ),
                        keyboardType: TextInputType.streetAddress,
                      ),
                    ),
                    SizedBox(
                      height: 35,
                    ),
                    SizedBox(
                      child: TextField(
                        controller: _addressLine2Controller,
                        style: TextStyle(
                          color: hexToColor('#2A2A2A'),
                          fontFamily: 'Gotham',
                          fontSize: 14,
                          fontWeight: FontWeight.w900,
                        ),
                        decoration: InputDecoration(
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          labelText: 'Area/ Street/ Sector',
                          labelStyle: TextStyle(
                            color: hexToColor('#545454'),
                            fontSize: 16,
                            fontWeight: FontWeight.w900,
                          ),
                          hintText: 'Address Line 2',
                          hintStyle: TextStyle(
                            color: hexToColor('#545454'),
                            fontSize: 14,
                            fontWeight: FontWeight.w900,
                          ),
                          prefixIcon: Icon(Icons.location_on_outlined),
                          prefixIconColor: Theme.of(context).primaryColor,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                              color: hexToColor('#2A2A2A'),
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                              color: hexToColor('#2A2A2A'),
                            ),
                          ),
                        ),
                        keyboardType: TextInputType.streetAddress,
                      ),
                    ),
                    SizedBox(
                      height: 35,
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.5,
                      child: TextField(
                        controller: _zipController,
                        style: TextStyle(
                          color: hexToColor('#2A2A2A'),
                          fontFamily: 'Gotham',
                          fontSize: 14,
                          fontWeight: FontWeight.w900,
                        ),
                        decoration: InputDecoration(
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          labelText: 'Pincode',
                          labelStyle: TextStyle(
                            color: hexToColor('#545454'),
                            fontSize: 16,
                            fontWeight: FontWeight.w900,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                              color: hexToColor('#2A2A2A'),
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                              color: hexToColor('#2A2A2A'),
                            ),
                          ),
                        ),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    SizedBox(
                      height: 35,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.45,
                          child: TextField(
                            controller: _cityController,
                            style: TextStyle(
                              color: hexToColor('#2A2A2A'),
                              fontFamily: 'Gotham',
                              fontSize: 14,
                              fontWeight: FontWeight.w900,
                            ),
                            decoration: InputDecoration(
                              floatingLabelBehavior: FloatingLabelBehavior.always,
                              labelText: 'City',
                              labelStyle: TextStyle(
                                color: hexToColor('#545454'),
                                fontSize: 16,
                                fontWeight: FontWeight.w900,
                              ),
          
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                  color: hexToColor('#2A2A2A'),
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                  color: hexToColor('#2A2A2A'),
                                ),
                              ),
                            ),
                            keyboardType: TextInputType.name,
                          ),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.45,
                          child: TextField(
                            controller: _stateController,
                            style: TextStyle(
                              color: hexToColor('#2A2A2A'),
                              fontFamily: 'Gotham',
                              fontSize: 14,
                              fontWeight: FontWeight.w900,
                            ),
                            decoration: InputDecoration(
                              floatingLabelBehavior: FloatingLabelBehavior.always,
                              labelText: 'State',
                              labelStyle: TextStyle(
                                color: hexToColor('#545454'),
                                fontSize: 16,
                                fontWeight: FontWeight.w900,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                  color: hexToColor('#2A2A2A'),
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                  color: hexToColor('#2A2A2A'),
                                ),
                              ),
                            ),
                            keyboardType: TextInputType.name,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 40,
              ),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    final pickupDetails = LocationDetails(
                      name: _nameController.text,
                      phone: _phoneController.text,
                      addressLine1: _addressLine1Controller.text,
                      addressLine2: _addressLine2Controller.text,
                      zip: _zipController.text,
                      city: _cityController.text,
                      state: _stateController.text,
                    );
          
                    widget.onSubmit(pickupDetails);
                    Navigator.pop(context);
                    },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: hexToColor('#2D332F'),
                    // Set the button color to black
                    foregroundColor: Colors.white,
                    // Set the text color to white
                    padding: EdgeInsets.symmetric(horizontal: 100, vertical: 20),
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
                      Text('Proceed', style: TextStyle(fontSize: 16)),
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
      ),
    );
  }
}
