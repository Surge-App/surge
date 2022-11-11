
import 'dart:async';
// ignore: unused_import
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:otp_text_field/otp_text_field.dart';
import 'package:otp_text_field/style.dart';
import 'package:testings/services/auth.dart';
import 'package:testings/services/db.dart';

class OtpScreen extends StatefulWidget {
  const OtpScreen({
    required this.phoneNumber,
    this.name,
    this.email,
    required this.registered,
    required this.auth,
    Key? key,
    phoneController,
  }) : super(key: key);

  final String? phoneNumber;
  final String? name;
  final String? email;
  final bool? registered;
  final AuthService? auth;

  @override
  _OtpScreenState createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  String? sentCode;
  String? enteredOTP = '';
  int start = 30;
  bool wait = true;
  String buttonName = "Send";
  // final _auth = AuthService();
  @override
  void initState() {
    widget.auth!.logInWIthPhone(phone: widget.phoneNumber!);
    startTimer();
    wait = true;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Color(0xff060427),
      body: SingleChildScrollView(
        child: Form(
          child: Column(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.12,
              ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: 50, bottom: 0),
                  child: Text(
                    'You are',
                    style: TextStyle(color: Colors.white, fontSize: 50),
                  ),
                ),
              ),
              Center(
                child: Text(
                  'almost there!',
                  style: TextStyle(color: Colors.white, fontSize: 50),
                ),
              ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    "You're safe!",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.1),
              Container(
                width: MediaQuery.of(context).size.width * 0.88,
                height: MediaQuery.of(context).size.height * 0.075,
                decoration: BoxDecoration(
                  color: Color(0xff241252),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    children: [
                      Icon(
                        Icons.call,
                        color: Color(0xffD19549),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        '+91 ${widget.phoneNumber}',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              OTPTextField(
                length: 6,
                width: MediaQuery.of(context).size.width * 0.92,
                fieldWidth: MediaQuery.of(context).size.width * 0.11,
                otpFieldStyle: OtpFieldStyle(
                  backgroundColor: Color(0xffffffff),
                  borderColor: Color(0xff0473270),
                  enabledBorderColor: Color(0xff452ac6),
                  focusBorderColor: Color(0xff452ac6),
                ),
                style: TextStyle(fontSize: 17, color: Colors.black),
                textFieldAlignment: MainAxisAlignment.spaceAround,
                fieldStyle: FieldStyle.box,
                onCompleted: (pin) {
                  enteredOTP = pin;
                },
                onChanged: (pin) {},
              ),
              SizedBox(
                height: 25,
              ),
              ElevatedButton(
                onPressed: () async {
                  if (enteredOTP!.length < 6) {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            content: Text('Invalid OTP'),
                          );
                        });
                  } else {
                    widget.auth!.verifyOtp(enteredOTP!, context);
                    if (!widget.registered!) {
                      Db().addUser(
                        widget.email!,
                        widget.name!,
                        widget.phoneNumber!,
                      );
                    }
                  }
                },
                child: Text(
                  'Verify',
                  style: TextStyle(
                    color: Color(0xffffffff),
                    fontWeight: FontWeight.w800,
                    fontSize: 25,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  shape: new RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(10.0),
                  ), backgroundColor: Color(0xff9B4BFF),
                  elevation: 10,
                  padding: EdgeInsets.symmetric(
                      horizontal: MediaQuery.of(context).size.width * 0.33,
                      vertical: MediaQuery.of(context).size.height * 0.012),
                ),
              ),
              Center(
                  child: TextButton(
                      onPressed: wait
                          ? null
                          : () async {
                              widget.auth!
                                  .logInWIthPhone(phone: widget.phoneNumber!);
                              setState(() {
                                startTimer();
                                start = 30;
                                wait = true;
                              });
                            },
                      child: Text(
                        'Resend OTP',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w800),
                      ))),
            ],
          ),
        ),
      ),
    ));
  }

  void startTimer() {
    const onsec = Duration(seconds: 1);
    // ignore: unused_local_variable
    Timer _timer = Timer.periodic(onsec, (timer) {
      if (start == 0) {
        setState(() {
          timer.cancel();
          wait = false;
        });
      } else {
        setState(() {
          start--;
        });
      }
    });
  }
}
