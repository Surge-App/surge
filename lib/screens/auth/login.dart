// ignore_for_file: unused_import, unused_field

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:testings/screens/otp.dart';
import 'package:testings/services/auth.dart';
import 'package:testings/services/messaging.dart';
import 'register.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen(this.phoneController);
  final TextEditingController phoneController;
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

final _formKey = GlobalKey<FormState>();

const themeColor = const Color(0xff063970);

class _LoginScreenState extends State<LoginScreen> {
  final phoneController = TextEditingController();
  final _auth = AuthService();

  @override
  void initState() {
    MessagingService().getPermissions();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: Color(0xff060427),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.12,
              ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: 50),
                  child: Text(
                    'Welcome Back!',
                    style: TextStyle(color: Colors.white, fontSize: 50),
                  ),
                ),
              ),
              // SizedBox(
              //   height: 10,
              // ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    "You've been saved",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.15),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                child: TextFormField(
                  keyboardType: TextInputType.number,
                  controller: widget.phoneController,
                  style: TextStyle(fontSize: 20, color: Colors.white),
                  maxLength: 10,
                  validator: (value) {
                    if (value == null) {
                      return 'Please enter phone number';
                    } else if (value.length < 10 ||
                        int.tryParse(value) == null) {
                      return 'Enter valid phone number';
                    } else {
                      return null;
                    }
                  },
                  decoration: InputDecoration(
                      fillColor: Color(0xff241252),
                      filled: true,
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(10),
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        borderSide:
                            const BorderSide(color: Colors.black, width: 2.0),
                      ),
                      hintText: 'Phone No.',
                      prefixIcon: Icon(
                          Icons.call,
                          color: Color(0xffD19549),
                        ),
                      hintStyle: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 20,
                          color: Color(0xffC9C9C9))),
                ),
              ),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    var doc = await FirebaseFirestore.instance
                        .collection('users')
                        .doc('+91' + phoneController.text)
                        .get();
                    if (doc.exists) {
                      _auth.logInWIthPhone(phone: phoneController.text);
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => OtpScreen(
                                    phoneNumber: phoneController.text,
                                    registered: true,
                                    auth: _auth,
                                  )));
                    } else {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  RegisterScreen(phoneController)));
                    }
                  }
                },
                child: Text(
                  'Send OTP',
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
                      onPressed: () {},
                      child: Text(
                        'Need Help?',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w800),
                      ))),
            ],

            //   ElevatedButton(
            //     onPressed: () async {
            //       if (_formKey.currentState!.validate()) {
            //         var doc = await FirebaseFirestore.instance
            //             .collection('users')
            //             .doc('+91' + phoneController.text)
            //             .get();
            //         if (doc.exists) {
            //           _auth.logInWIthPhone(phone: phoneController.text);
            //           Navigator.pushReplacement(
            //               context,
            //               MaterialPageRoute(
            //                   builder: (context) => OtpScreen(
            //                         phoneNumber: phoneController.text,
            //                         registered: true,
            //                         auth: _auth,
            //                       )));
            //         } else {
            //           Navigator.push(
            //               context,
            //               MaterialPageRoute(
            //                   builder: (context) =>
            //                       RegisterScreen(phoneController)));
            //         }
            //       }
            //     },
            //     child: Text(
            //       'Login',
            //       style: TextStyle(
            //         color: Color(0xff464646),
            //         fontWeight: FontWeight.bold,
            //         fontSize: 20,
            //       ),
            //     ),
            //     style: ElevatedButton.styleFrom(
            //       shape: new RoundedRectangleBorder(
            //         borderRadius: new BorderRadius.circular(10.0),
            //       ),
            //       elevation: 10,
            //       primary: Color(0xffD19549),
            //       padding: EdgeInsets.symmetric(horizontal: 100, vertical: 15),
            //     ),
            //   ),
            // ],
          ),
        ),
      ),
    ));
  }
}
