import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:package_info_plus/package_info_plus.dart';
//import 'package:testings/screens/about_walkthrough.dart';
import 'package:testings/screens/autopay_walkthrough.dart';
import 'package:testings/screens/firstpage.dart';
import 'package:testings/services/db.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  String phone = FirebaseAuth.instance.currentUser!.phoneNumber!;
  Db db = Db();
  bool sbool = true;
  String version = 'Loading...';

  void _signOut() {
    FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    PackageInfo.fromPlatform().then((PackageInfo packageInfo) {
      setState(() {
        version = packageInfo.version;
      });
    });
    makeListTile(Icon icon, String title, Function() func) => ListTile(
        onTap: func,
        contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        leading: Container(
            padding: EdgeInsets.only(right: 12.0),
            decoration: new BoxDecoration(
                border: new Border(
                    right: new BorderSide(width: 1.0, color: Colors.white24))),
            child: icon),
        title: Text(
          title,
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        // subtitle: Text("Intermediate", style: TextStyle(color: Colors.white)),
        trailing:
            Icon(Icons.keyboard_arrow_right, color: Colors.white, size: 30.0));

    makeSwitchTile(Icon icon, String title, Function() func) => ListTile(
        onTap: func,
        contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        leading: Container(
            padding: EdgeInsets.only(right: 12.0),
            decoration: new BoxDecoration(
                border: new Border(
                    right: new BorderSide(width: 1.0, color: Colors.white24))),
            child: icon),
        title: Text(
          title,
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        subtitle: Text("If no spends are detected in a day", style: TextStyle(color: Colors.white)),
        trailing:
        Switch(
            activeColor: Colors.yellow.shade800,
            value: sbool,
            onChanged: (bool sb) {
              Fluttertoast.showToast(
                  msg: "Coming soon.",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.TOP,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Colors.black87,
                  textColor: Colors.white,
                  fontSize: 16.0);
              setState(() {
                sbool = true;
              });
            }));

    makeCard(Icon icon, String title, Function() func) => Card(
          elevation: 8.0,
          margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
          child: Container(
            decoration: BoxDecoration(color: Color(0xff5C4A7F)),
            child: makeListTile(icon, title, func),
          ),
        );

    Future<bool?> _onBackPressed() async {
      return showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Do you want to exit?'),
              actions: <Widget>[
                TextButton(
                  child: Text('NO'),
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                ),
                TextButton(
                  child: Text('YES'),
                  onPressed: () {
                    Navigator.of(context).pop(true);
                  },
                ),
              ],
            );
          });
    }

    return WillPopScope(
      onWillPop: () async {
        bool? result = await _onBackPressed();
        if (result == null) {
          result = false;
        }
        return result;
      },
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
            child: FaIcon(FontAwesomeIcons.whatsapp,
                color: Colors.white, size: 30),
            backgroundColor: Color(0xff00E676),
            foregroundColor: Colors.white,
            onPressed: () async {
              String phoneNumber = '+919885000923';
              var url = 'https://wa.me/$phoneNumber?text=Hi%20Surge!%20';
              await launch(url);
            }),
        backgroundColor: Color(0xff473270),
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 25,
              ),
              SizedBox(
                height: 20,
              ),
              CircleAvatar(
                backgroundColor: Colors.grey[600],
                radius: 50,
                child: Icon(
                  Icons.person,
                  size: 40,
                  color: Colors.white,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              FutureBuilder(
                  future: db.name,
                  builder: (context, snapshot) {
                    return RichText(
                      text: TextSpan(
                        text: snapshot.data.toString(),
                        style: TextStyle(
                            fontFamily: 'Poppins',
                            color: Colors.white,
                            fontSize: 25,
                            fontWeight: FontWeight.bold),
                      ),
                    );
                  }),
              SizedBox(
                height: 0,
              ),
              FutureBuilder(
                  future: db.email,
                  builder: (context, snapshot) {
                    return RichText(
                      text: TextSpan(
                        text: snapshot.data.toString(),
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          color: Colors.white30,
                          fontSize: 20,
                        ),
                      ),
                    );
                  }),
              RichText(
                text: TextSpan(
                  text: FirebaseAuth.instance.currentUser!.phoneNumber
                      .toString()
                      .substring(3),
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    color: Colors.white30,
                    fontSize: 20,
                  ),
                ),
              ),
              SizedBox(
                height: 20,
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
              Card(
                elevation: 8.0,
                margin:
                    new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
                child: Container(
                  decoration: BoxDecoration(color: Color(0xff5C4A7F)),
                  child: makeSwitchTile(
                      Icon(
                        Icons.monetization_on_rounded,
                        size: 25,
                        color: Color(0xffE4A951),
                      ),
                      'Auto Invest ₹10',
                      () {}),
                ),
              ),
              makeCard(
                  Icon(Icons.description, color: Colors.white), 'How it works',
                  () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => FirstPg()));
              }),
              makeCard(
                  Icon(
                    Icons.help_outline,
                    color: Colors.white,
                  ),
                  'Auto Invest guide', () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AutoPayWalkThrough()));
              }),
              makeCard(
                  Icon(
                    Icons.article_outlined,
                    color: Colors.white,
                  ),
                  'Terms and conditions',
                  _launchURLTC),
              makeCard(
                  Icon(
                    Icons.privacy_tip_outlined,
                    color: Colors.white,
                  ),
                  'Privacy Policy',
                  _launchURLPP),
              SizedBox(
                height: 40,
              ),
              ElevatedButton.icon(
                onPressed: _signOut,
                icon: Icon(Icons.logout),
                label: Text(
                  'Logout',
                  style: TextStyle(fontWeight: FontWeight.w800),
                ),
                style: ElevatedButton.styleFrom(
                  shape: new RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(10.0),
                  ),
                  elevation: 10,
                  primary: Color(0xffD19549),
                  padding: EdgeInsets.symmetric(horizontal: 60, vertical: 8),
                ),
              ),
              SizedBox(
                height: 40,
              ),
              Row(children: <Widget>[
                Expanded(
                  child: Divider(
                    height: 20,
                    color: Colors.grey,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 8.0),
                  child: Text(
                    'v $version',
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
                Expanded(
                  child: Divider(
                    height: 20,
                    color: Colors.grey,
                  ),
                ),
              ]),
              // ElevatedButton.icon(
              //   onPressed: _launchURLTC,
              //   icon: Icon(Icons.article_outlined),
              //   label: Text(
              //     'Terms and conditions',
              //     style: TextStyle(fontWeight: FontWeight.w800),
              //   ),
              //   style: ElevatedButton.styleFrom(
              //     shape: new RoundedRectangleBorder(
              //       borderRadius: new BorderRadius.circular(20.0),
              //     ),
              //     elevation: 10,
              //     primary:Colors.deepPurpleAccent,
              //     padding: EdgeInsets.symmetric(horizontal: 35, vertical: 8),
              //   ),
              // ),
              // ElevatedButton.icon(
              //   onPressed: _launchURLPP,
              //   icon: Icon(Icons.privacy_tip_outlined),
              //   label: Text(
              //     'Privacy Policy',
              //     style: TextStyle(fontWeight: FontWeight.w800),
              //   ),
              //   style: ElevatedButton.styleFrom(
              //     shape: new RoundedRectangleBorder(
              //       borderRadius: new BorderRadius.circular(20.0),
              //     ),
              //     elevation: 10,
              //     primary: Colors.deepPurpleAccent,
              //     padding: EdgeInsets.symmetric(horizontal: 60, vertical: 8),
              //   ),
              // ),
              SizedBox(height: 30),
              // ElevatedButton.icon(
              //   onPressed: _signOut,
              //   icon: Icon(Icons.logout),
              //   label: Text(
              //     'Logout',
              //     style: TextStyle(fontWeight: FontWeight.w800),
              //   ),
              //   style: ElevatedButton.styleFrom(
              //     shape: new RoundedRectangleBorder(
              //       borderRadius: new BorderRadius.circular(20.0),
              //     ),
              //     elevation: 10,
              //     primary: Color(0xffD19549),
              //     padding: EdgeInsets.symmetric(horizontal: 90, vertical: 15),
              //   ),
              // ),
              // Spacer(),
              // Padding(
              //   padding: const EdgeInsets.all(18.0),
              //   child: Row(
              //     children: [
              //       Spacer(),
              //       FloatingActionButton(
              //           child: FaIcon(FontAwesomeIcons.whatsapp,
              //               color: Colors.white, size: 30),
              //           backgroundColor: Color(0xff00E676),
              //           foregroundColor: Colors.white,
              //           onPressed: () async {
              //             String phoneNumber = '+919652354388';
              //             var url =
              //                 'https://wa.me/$phoneNumber?text=Hi%20Surge!%20';
              //             await launch(url);
              //           }),
              //     ],
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}

void _launchURLTC() async {
  const url = 'https://www.getsurgeapp.com/terms-conditions';
  if (!await launch(url)) throw 'Could not launch $url';
}

void _launchURLPP() async {
  const url = 'https://www.getsurgeapp.com/privacy-policy';
  if (!await launch(url)) throw 'Could not launch $url';
}
