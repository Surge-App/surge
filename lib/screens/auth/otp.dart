import 'package:flutter/material.dart';
import 'package:testings/services/auth.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:testings/services/db.dart';

class OtpScreen extends StatefulWidget {
  const OtpScreen({
    required this.phoneNumber,
    this.name,
    this.email,
    required this.registered,
    required this.auth,
    Key? key,
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
  final _auth = AuthService();

  @override
  void initState() {
    widget.auth!.logInWIthPhone(phone: widget.phoneNumber!);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          backgroundColor: Color(0xff0D104E),
          body: Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(right: 350, bottom: 120),
                child: IconButton(
                  color: Colors.white,
                  icon: Icon(Icons.arrow_back),
                  iconSize: 30,
                  onPressed: () => Navigator.pop(context),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Center(
                child: Container(
                  color: Colors.white,
                  child: Column(
                    children: <Widget>[
                      SizedBox(height: 30),
                      Text(
                        'Verify Phone No.',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w900,
                          fontSize: 25,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        'Code is sent to +91 ${widget.phoneNumber}',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.black38,
                          fontWeight: FontWeight.w400,
                          fontSize: 20,
                        ),
                      ),
                      SizedBox(
                        height: 50,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 50.0),
                        child: OTPTextField(
                          length: 6,
                          width: MediaQuery.of(context).size.width,
                          fieldWidth: 16,
                          style: TextStyle(fontSize: 20, color: Colors.black),
                          textFieldAlignment: MainAxisAlignment.spaceAround,
                          onCompleted: (pin) {
                            enteredOTP = pin;
                          },
                          onChanged: (pin) {},
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      SizedBox(
                        height: 40,
                      ),
                      ElevatedButton(
                        onPressed: () {
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
                          'VERIFY',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                            primary: Color(0xff8A00FF),
                            padding: EdgeInsets.symmetric(
                                horizontal: 90, vertical: 15)),
                      ),
                      SizedBox(
                        height: 30,
                      )
                    ],
                  ),
                ),
              ),
            ],
          )),
    );
  }
}
