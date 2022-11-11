import 'package:flutter/material.dart';
import 'package:testings/screens/otp.dart';
import 'package:testings/services/auth.dart';

import 'login.dart';

class RegisterScreen extends StatefulWidget {
  RegisterScreen(this.phoneController);

  final TextEditingController phoneController;
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

final _formKey = GlobalKey<FormState>();

const themeColor = const Color(0xff063970);

class _RegisterScreenState extends State<RegisterScreen> {
  final phoneController = TextEditingController();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final _auth = AuthService();

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
                  height: 60,
                ),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 50),
                    child: Text(
                      'Welcome',
                      style: TextStyle(color: Colors.white, fontSize: 50),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Text(
                      'Lorem ipsum dolor sit amet. Sit quae totam in iusto enim et eius cumque et enim laborum!.',
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                  ),
                ),
                SizedBox(height: 80),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                  child: TextFormField(
                    controller: nameController,
                    style: TextStyle(fontSize: 20, color: Colors.white),
                    textCapitalization: TextCapitalization.words,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter name';
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
                        hintText: 'Name',
                        prefixIcon: Icon(
                          Icons.person_outline,
                          color: Color(0xffD19549),
                        ),
                        hintStyle: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 20,
                            color: Color(0xffC9C9C9))),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                  child: TextFormField(
                    controller: emailController,
                    style: TextStyle(fontSize: 20, color: Colors.white),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null) {
                        return 'Please enter e-mail address';
                      } else if (!RegExp(
                              r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                          .hasMatch(value)) {
                        return 'Enter valid Email';
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
                        hintText: 'Email Id',
                        prefixIcon: Icon(
                          Icons.email_outlined,
                          color: Color(0xffD19549),
                        ),
                        hintStyle: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 20,
                            color: Color(0xffC9C9C9))),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
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
                
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => OtpScreen(
                                      phoneNumber: widget.phoneController.text,
                                      name: nameController.text,
                                      email: emailController.text,
                                      registered: false,
                                      auth: _auth, phoneController: null,
                                    )));
                      }
                    },
                    child: Text(
                      'Lets go!',
                      style: TextStyle(
                        color: Color(0xffffffff),
                        fontWeight: FontWeight.w800,
                        fontSize: 25,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(10.0),
                      ),
                      elevation: 10,
                      primary: Color(0xff9B4BFF),
                      padding: EdgeInsets.symmetric(
                          horizontal: MediaQuery.of(context).size.width * 0.36,
                          vertical: MediaQuery.of(context).size.height * 0.012),
                    ),
                  ),
                ),
                Center(
                    child: TextButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      LoginScreen(phoneController)));
                        },
                        child: Text(
                          'Already have an account?',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w800),
                        )))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
