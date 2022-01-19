// ignore_for_file: import_of_legacy_library_into_null_safe

import 'dart:convert';

import 'package:demo/body.dart';
import 'package:flutter/material.dart';
import 'package:otp_screen/otp_screen.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class OTPScreen extends StatefulWidget {
  OTPScreen({Key? key}) : super(key: key);

  @override
  _OTPScreenState createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  Map<String, dynamic> data = {'response': ''};

  Future<String> validateOtp(String otp) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // await Future.delayed(Duration(milliseconds: 2000));
    //http://paarshinfotech.com/HospiOne/hospione_api/patient_login.php?otp={val}

    var response = await http.post(
        Uri.parse(
            "http://paarshinfotech.com/HospiOne/hospione_api/patient_login.php"),
        body: {
          'otp': otp,
        });
    data = json.decode(response.body);
    // print(data['data'][0]['pname']);
    if (data['status'] == "001") {
      prefs.setString('username', data['data'][0]['pname']);
      prefs.setString('userId', data['data'][0]['pid']);
      prefs.setString('user_type', data['data'][0]['user_type']);

      // String? username = prefs.getString('user');
      // print('hello $username');
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
        return Body();
      }));
      return 'Successfully Verified';
    } else {
      return "The entered Otp is wrong";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: OtpScreen(
        otpLength: 4,
        //routeCallback: moveToNextScreen,
        titleColor: Colors.black,
        validateOtp: validateOtp,
        title: 'Verify your Phone Number',
        themeColor: Colors.green,
      ),
    );
  }
}
