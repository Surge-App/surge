import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:testings/services/db.dart';
import 'package:testings/services/razorpay.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  late RP _razorpay;
  String phone = FirebaseAuth.instance.currentUser!.phoneNumber!;
  Db db = Db();
  bool sbool = false;

  void _signOut() {
    FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    _razorpay = Provider.of<RP>(context);
    _razorpay.razorpay
        .on(Razorpay.EVENT_PAYMENT_SUCCESS, RP(context).handlePaymentSuccess);
    _razorpay.razorpay
        .on(Razorpay.EVENT_PAYMENT_ERROR, RP(context).handlePaymentError);
    _razorpay.razorpay
        .on(Razorpay.EVENT_EXTERNAL_WALLET, RP(context).handleExternalWallet);
    return Scaffold(
      backgroundColor: Color(0xff473270),
      body: Column(
        children: [
          SizedBox(
            height: 25,
          ),
          Column(
            children: [
              Container(
                alignment: Alignment.topLeft,
                height: 60.0,
                width: 150.0,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/getsurge.png'),
                    fit: BoxFit.fill,
                  ),
                ),
              ),
              SizedBox(height: 5),
                Text(
                  'Crypto & You',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 25,
                      fontWeight: FontWeight.bold),
                ),
            ],
          ),
          SizedBox(
            height: 20,
          ),
          CircleAvatar(
            radius: 46,
            backgroundImage:
                NetworkImage('https://www.w3schools.com/w3images/avatar2.png'),
          ),
          SizedBox(
            height: 10,
          ),
          FutureBuilder(
              future: db.name,
              builder: (context, snapshot) {
                return RichText(
                  text: TextSpan(
                    text: "Hi, " + snapshot.data.toString(),
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 25,
                        fontWeight: FontWeight.bold),
                  ),
                );
              }),
          SizedBox(
            height: 10,
          ),
          FutureBuilder(
              future: db.email,
              builder: (context, snapshot) {
                return RichText(
                  text: TextSpan(
                    text: snapshot.data.toString(),
                    style: TextStyle(
                      color: Colors.white30,
                      fontSize: 20,
                    ),
                  ),
                );
              }),
          SizedBox(
            height: 30,
          ),
          // Padding(
          //   padding: const EdgeInsets.only(left: 20),
          //   child: Container(
          //     alignment: Alignment.bottomLeft,
          //     child: Text(
          //       'Transactions',
          //       textAlign: TextAlign.start,
          //       style: TextStyle(
          //           color: Color(0xffD19549),
          //           fontSize: 20,
          //           fontWeight: FontWeight.w800),
          //     ),
          //   ),
          // ),
          SizedBox(height: 40),
          ElevatedButton.icon(
              onPressed: _signOut,
              icon: Icon(Icons.logout),
              label: Text('Logout', style: TextStyle(fontWeight: FontWeight.w800),),
            style: ElevatedButton.styleFrom(
              shape: new RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(20.0),
              ),
              elevation: 10,
              primary: Color(0xffD19549),
              padding: EdgeInsets.symmetric(horizontal: 100, vertical: 15),
            ),
          ),
          // ElevatedButton(
          //   onPressed: _signOut,
          //   child: Text(
          //     'Logout',
          //     style: TextStyle(
          //       color: Color(0xff464646),
          //       fontWeight: FontWeight.bold,
          //       fontSize: 20,
          //     ),
          //   ),
          //   style: ElevatedButton.styleFrom(
          //     shape: new RoundedRectangleBorder(
          //       borderRadius: new BorderRadius.circular(20.0),
          //     ),
          //     elevation: 10,
          //     primary: Color(0xffD19549),
          //     padding: EdgeInsets.symmetric(horizontal: 100, vertical: 15),
          //   ),
          // ),
          Spacer(),
          Padding(
            padding: const EdgeInsets.all(18.0),
            child: Row(
              children: [
                Spacer(),
                FloatingActionButton(
                  child: FaIcon(FontAwesomeIcons.whatsapp,
                      color: Colors.white, size: 30),
                  backgroundColor: Color(0xff00E676),
                  foregroundColor: Colors.white,
                  onPressed: () => {},
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
