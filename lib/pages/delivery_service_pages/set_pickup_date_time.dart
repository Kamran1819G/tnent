import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../../helpers/color_utils.dart';

class SetPickupDateTime extends StatefulWidget {
  const SetPickupDateTime({super.key});

  @override
  State<SetPickupDateTime> createState() => _SetPickupDateTimeState();
}

class _SetPickupDateTimeState extends State<SetPickupDateTime> {
  bool value = false;
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;

  @override
  void initState() {
    super.initState();
    // Set default date to tomorrow
    _selectedDate = DateTime.now().add(Duration(days: 1));
    // Set default time to 11:00 PM
    _selectedTime = TimeOfDay(hour: 23, minute: 0);
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime ?? TimeOfDay.now(),
    );
    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
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
                  alignment: Alignment(0, 0.3),
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  width: MediaQuery.of(context).size.width,
                  child: Text(
                    'When Do You Want Your Item To Be Picked Up?',
                    style: TextStyle(
                      color: hexToColor('#2A2A2A'),
                      fontSize: 34,
                      fontWeight: FontWeight.w900,
                    ),
                    textAlign: TextAlign.center,
                  ),
                )
              ],
            ),
          ),
          SizedBox(height: 20),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.4,
            child: TextField(
              readOnly: true,
              textAlign: TextAlign.center,
              decoration: InputDecoration(
                hintText: _selectedDate != null
                    ? DateFormat('EEE, dd').format(
                        DateTime.parse(_selectedDate!.toString().split(' ')[0]))
                    : '',
                hintStyle: TextStyle(
                  color: Colors.black,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w500,
                  fontSize: 18,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(18),
                  borderSide: BorderSide(
                    color: hexToColor('#848484'),
                  ),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(18),
                  borderSide: BorderSide(
                    color: hexToColor('#848484'),
                  ),
                ),
              ),
              onTap: () => _selectDate(context),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.4,
            child: TextField(
              readOnly: true,
              textAlign: TextAlign.center,
              decoration: InputDecoration(
                hintText:
                    _selectedTime != null ? _selectedTime!.format(context) : '',
                hintStyle: TextStyle(
                  color: Colors.black,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w500,
                  fontSize: 18,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(18),
                  borderSide: BorderSide(
                    color: hexToColor('#848484'),
                  ),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(18),
                  borderSide: BorderSide(
                    color: hexToColor('#848484'),
                  ),
                ),
              ),
              onTap: () => _selectTime(context),
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.05,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
                'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. eiusmod tempor incididunt ut labore et do Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor.',
                style: TextStyle(
                  color: hexToColor('#9C9C9C'),
                  fontFamily: 'Gotham',
                  fontSize: 14,
                ),
                textAlign: TextAlign.center,
                maxLines: 20,
                overflow: TextOverflow.ellipsis
            ),
          ),
          Spacer(),
          Container(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Checkbox(
                    activeColor: Theme.of(context).primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                    value: value,
                    onChanged: (value) {
                      setState(() {
                        this.value = value!;
                      });
                    },
                  ),
                  Text(
                    'I agree to the',
                    style: TextStyle(
                      color: hexToColor('#636363'),
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                    ),
                  ),
                  SizedBox(width: 4),
                  GestureDetector(
                    onTap: () {},
                    child: Text(
                      'Terms and Conditions',
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              )),
          SizedBox(
            height: 20,
          ),
          Center(
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: hexToColor('#2D332F'),
                // Set the button color to black
                foregroundColor: Colors.white,
                // Set the text color to white
                padding: EdgeInsets.symmetric(horizontal: 50, vertical: 18),
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
                  Text('Set Pickup Date & Time',
                      style: TextStyle(fontSize: 16)),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
        ],
      ),
    ));
  }
}
