// ignore_for_file: use_build_context_synchronously

import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:tnennt/helpers/snackbar_utils.dart';

class OTPController {
  String? apiKey;
  DocumentSnapshot<Map<String, dynamic>>? doc;

  Future<String?> sendOtp(String phoneNumber, BuildContext context) async {
    doc = await FirebaseFirestore.instance
        .collection('confidential')
        .doc('otpCreds')
        .get();

    String numericalPhoneNumber = phoneNumber.replaceAll(RegExp(r'[^\d]'), '');
    numericalPhoneNumber = '+91$numericalPhoneNumber';

    if (doc != null && doc!.exists) {
      Map<String, dynamic> data = doc!.data() as Map<String, dynamic>;
      apiKey = data['apiKey'];

      final url = Uri.parse(
          'https://2factor.in/API/V1/$apiKey/SMS/$numericalPhoneNumber/AUTOGEN');

      try {
        final response = await http.get(url);

        if (response.statusCode == 200) {
          var data = json.decode(response.body);
          if (data['Status'] == 'Success') {
            String sessionId = data['Details'];
            log('OTP sent successfully. Session ID: $sessionId');
            showSnackBar(
              context,
              'OTP sent successfully. Receive it through Call/SMS',
              bgColor: Colors.green,
              leadIcon: const Icon(Icons.check, color: Colors.white),
            );

            return sessionId;
          } else {
            showSnackBar(context, 'Failed to send OTP: ${data['Details']}');

            return null;
          }
        } else {
          showSnackBar(context,
              'Failed to send OTP. Status code: ${response.statusCode}');

          return null;
        }
      } catch (e) {
        showSnackBar(context, 'Error occurred while sending OTP: $e');
        return null;
      }
    } else {
      showSnackBar(context, 'An unexpected error occurred while sending OTP.');
      return null;
    }
  }

  Future<bool> verifyOtp(
      String sessionId, String otp, BuildContext context) async {
    final url = Uri.parse(
        'https://2factor.in/API/V1/$apiKey/SMS/VERIFY/$sessionId/$otp');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        if (data['Status'] == 'Success') {
          log('OTP verified successfully.');
          showSnackBar(
            context,
            'OTP verified successfully',
            bgColor: Colors.green,
            leadIcon: const Icon(Icons.check, color: Colors.white),
          );

          return true;
        } else {
          showSnackBar(context, 'OTP verification failed: ${data['Details']}');
          return false;
        }
      } else {
        showSnackBar(context,
            'Failed to verify OTP. Status code: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      showSnackBar(context, 'Error occurred while verifying OTP: $e');
      return false;
    }
  }
}
