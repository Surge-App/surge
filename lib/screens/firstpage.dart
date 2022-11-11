import 'package:flutter/material.dart';
import 'package:testings/screens/auth/login.dart';

import 'auth/register.dart';

class FirstPg extends StatefulWidget {
  const FirstPg({Key? key}) : super(key: key);

  @override
  _FirstPgState createState() => _FirstPgState();
}

class _FirstPgState extends State<FirstPg> {
  final phoneController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Color(0xff060427),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            width: size.width * 0.75,
            height: size.height * 0.5,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/nn.png'),
                fit: BoxFit.contain,
              ),
            ),
          ),
          SizedBox(
            height: 50,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Flexible(
              child: RichText(
                text: TextSpan(
                    text: 'Invest in the ',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 50,
                        fontWeight: FontWeight.w500),
                    children: [
                      TextSpan(
                        text: "Future",
                        style: TextStyle(
                            color: Colors.yellowAccent,
                            fontSize: 50,
                            fontWeight: FontWeight.w500),
                      ),
                    ]),
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              'Lorem ipsum dolor sit amet. Sit quae totam in iusto enim et eius cumque et enim laborum!.',
              style: TextStyle(color: Colors.white, fontSize: 25),
            ),
          ),
          SizedBox(
            height: 36,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => RegisterScreen(phoneController)));
              },
              child: Text(
                'Get Started',
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
                    'Login',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w800),
                  )))
        ],
      ),
    );
  }
}
