import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:launch_review/launch_review.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:telephony/telephony.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:testings/models/change.dart';
import 'package:testings/screens/Intro_pay.dart';
import 'package:testings/services/db.dart';

import '../main.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final telephony = Telephony.instance;
  String phone = FirebaseAuth.instance.currentUser!.phoneNumber!;
  final ready = BoolChange();
  Db db = Db();
  @override
  void initState() {
    getVersionData();
    updateMessages();
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null) {
        flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                channel.id,
                channel.name,
                channelDescription: channel.description,
                color: Colors.deepPurpleAccent,
                playSound: true,
                icon: '@mipmap/transparent',
              ),
            ));
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('A new onMessageOpenedApp event was published!');
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null) {
        showDialog(
            context: context,
            builder: (_) {
              return AlertDialog(
                title: Text(notification.title!),
                content: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [Text(notification.body!)],
                  ),
                ),
              );
            });
      }
    });
    super.initState();
  }

  // void showNotification() {
  //   flutterLocalNotificationsPlugin.show(
  //       0,
  //       "Title",
  //       "This is notification desc!",
  //       NotificationDetails(
  //           android: AndroidNotificationDetails(
  //               channel.id,
  //               channel.name,
  //               channelDescription: channel.description,
  //               importance: Importance.high,
  //               color: Colors.deepPurpleAccent,
  //               playSound: true,
  //               icon: '@mipmap/transparent'
  //           )
  //       )
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    Future<bool?> _onBackPressed() async {
      // showNotification();
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
        backgroundColor: Color(0xff0473270),
        body: Stack(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: 200,
              color: Color(0xffD19549),
            ),
            SingleChildScrollView(
              child: Column(
                children: [
                  StreamBuilder<DocumentSnapshot>(
                    stream: db.listenToDb,
                    builder:
                        (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                      if (snapshot.hasData) {
                        return Visibility(
                          visible: snapshot.hasData,
                          child: Padding(
                            padding:
                                EdgeInsets.only(left: 20, top: 100, right: 20),
                            child: SizedBox(
                              height: 200,
                              child: Card(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15)),
                                color: Colors.white,
                                child: Column(
                                  children: [
                                    Center(
                                      child: Column(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(20.0),
                                            child: Row(
                                              children: [
                                                Text(
                                                  'Balance',
                                                  style: TextStyle(
                                                      fontSize: 30,
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                Spacer(),
                                                FaIcon(
                                                  FontAwesomeIcons.creditCard,
                                                  size: 30,
                                                  color: Color(0xffD19549),
                                                )
                                              ],
                                            ),
                                          ),
                                          SizedBox(
                                            height: 20,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              CircleAvatar(
                                                radius: 20,
                                                backgroundColor:
                                                    Color(0xffF9A42F),
                                                child: FaIcon(
                                                  FontAwesomeIcons.btc,
                                                  size: 30,
                                                  color: Colors.white,
                                                ),
                                              ),
                                              SizedBox(
                                                width: 20,
                                              ),
                                              Text(
                                                '${snapshot.data!['amount'] ?? '0'}',
                                                style: TextStyle(
                                                    fontSize: 30,
                                                    color: Colors.black,
                                                    fontWeight:
                                                        FontWeight.w400),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      } else {
                        return Container();
                      }
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 0),
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Card(
                        elevation: 5,
                        color: Color(0xff5C4A7F),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        child: StreamBuilder<DocumentSnapshot>(
                          stream: db.listenToDb,
                          builder: (context,
                              AsyncSnapshot<DocumentSnapshot> snapshot) {
                            if (snapshot.hasData) {
                              if (!snapshot.data!['rp_authorized']) {
                                return Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(top: 10),
                                      child: Text('Setup Auto-Invest',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 25,
                                              fontWeight: FontWeight.normal)),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: 20, bottom: 20),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Column(
                                            children: [
                                              CircleAvatar(
                                                radius: 40,
                                                backgroundColor:
                                                    Color(0xffB48861),
                                                child: Icon(
                                                  Icons.security,
                                                  size: 45,
                                                  color: Color(0xff473270),
                                                ),
                                              ),
                                              SizedBox(height: 5),
                                              Text('100% Secure',
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.bold)),
                                              SizedBox(height: 5),
                                              Text('',
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.bold)),
                                            ],
                                          ),
                                          Column(
                                            children: [
                                              CircleAvatar(
                                                radius: 40,
                                                backgroundColor:
                                                    Color(0xffB48861),
                                                child: Icon(
                                                  Icons.change_circle_outlined,
                                                  size: 45,
                                                  color: Color(0xff473270),
                                                ),
                                              ),
                                              SizedBox(height: 5),
                                              Text('Spare charge',
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.bold)),
                                              Text('auto-invested',
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.bold)),
                                            ],
                                          ),
                                          Column(
                                            children: [
                                              CircleAvatar(
                                                radius: 40,
                                                backgroundColor:
                                                    Color(0xffB48861),
                                                child: Icon(
                                                  Icons.maps_home_work_sharp,
                                                  size: 45,
                                                  color: Color(0xff473270),
                                                ),
                                              ),
                                              SizedBox(height: 5),
                                              Text('Supports 13+',
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.bold)),
                                              Text('Banks',
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.bold)),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          bottom: 20, top: 10),
                                      child: ElevatedButton(
                                        onPressed: () async {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      IntroPayScreen()));
                                        },
                                        child: Text('Setup Auto-Invest',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                            )),
                                        style: ElevatedButton.styleFrom(
                                          shape: new RoundedRectangleBorder(
                                            borderRadius:
                                                new BorderRadius.circular(10.0),
                                          ),
                                          elevation: 20,
                                          primary: Color(0xffBD8753),
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 86, vertical: 15),
                                        ),
                                      ),
                                    )
                                  ],
                                );
                              } else {
                                return SizedBox();
                              }
                            } else {
                              return SizedBox();
                            }
                          },
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: StreamBuilder(
                      stream: Db().listenToMessages,
                      builder:
                          (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (!snapshot.hasData) {
                          return Text('data');
                        } else {
                          return Visibility(
                            visible: snapshot.data!.docs.length > 0,
                            child: Column(
                              children: [
                                Center(
                                  child: Text(
                                    'Recent Transactions',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 25,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(2.0),
                                  child: ListView.builder(
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    itemCount: snapshot.data!.docs.length > 5
                                        ? 5
                                        : snapshot.data!.docs.length,
                                    itemBuilder: (context, index) {
                                      var doc = snapshot.data!.docs[index];
                                      Timestamp time = doc['time'];
                                      var parsedDT = time.toDate();
                                      var date =
                                          DateFormat.yMMMd().format(parsedDT);
                                      var tim =
                                          DateFormat.jm().format(parsedDT);
                                      int amount = doc['amount'];
                                      int rounded, invested;
                                      if (amount < 100) {
                                        if (amount % 5 == 0) {
                                          invested = 5;
                                        } else {
                                          rounded = (amount / 5).ceil() * 5;
                                          invested = rounded - amount;
                                        }
                                      } else {
                                        if (amount % 10 == 0) {
                                          invested = 10;
                                        } else {
                                          rounded = (amount / 10).ceil() * 10;
                                          invested = rounded - amount;
                                        }
                                      }
                                      return Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 10, horizontal: 10),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            color: Color(0xff555555),
                                          ),
                                          child: ListTile(
                                            title: Text(
                                              'Spent ₹' + amount.toString(),
                                              style: TextStyle(
                                                  fontSize: 20.0,
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                            subtitle: Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 8.0),
                                              child: Text(
                                                date.toString() +
                                                    " " +
                                                    tim.toString(),
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                            ),
                                            trailing: Container(
                                              height: 35,
                                              width: 95,
                                              decoration: BoxDecoration(
                                                  color: Color(0xff141414),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10)),
                                              child: Center(
                                                child: Text(
                                                  "Invested ₹" +
                                                      invested.toString(),
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      color: Color(0xff14EE80),
                                                      fontSize: 12.0,
                                                      fontWeight:
                                                          FontWeight.w400),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                SizedBox(
                                  height: 30,
                                )
                              ],
                            ),
                          );
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  updateMessages() async {
    final prefs = await SharedPreferences.getInstance();
    int timeStamp =
        prefs.getInt('timestamp') ?? DateTime.now().millisecondsSinceEpoch;
    // ignore: unused_local_variable
    DateTime now = DateTime.now();
    // int timeStamp = DateTime(now.year, now.month, now.day-7, 0, 0).millisecondsSinceEpoch;
    List<SmsMessage> messages = await telephony.getInboxSms(
        columns: [SmsColumn.BODY, SmsColumn.DATE],
        filter: SmsFilter.where(SmsColumn.DATE)
            .greaterThanOrEqualTo(timeStamp.toString()),
        sortOrder: [OrderBy(SmsColumn.DATE, sort: Sort.ASC)]);
    for (var i in messages) {
      if (i.body.toString().contains(new RegExp(r'([Rr]s\.?)')) &&
          i.body.toString().contains(
              new RegExp(r'([Ss]ent)|([Pp]aid)|([Dd]ebited)|DEBITED')) &&
          !(i.body.toString().contains(new RegExp(
              r'([Ff]ailed)|([Cc]redited)|([Rr]received)|[Rr]azorpay|[Uu]nsuccessful|[Pp]ending')))) {
        if (RegExp(r'(?<=([Rr]s)\.* *)[0-9]*')
                .firstMatch(i.body.toString())
                ?.group(0) !=
            null) {
          String? temp = RegExp(r'(?<=([Rr]s))\.? ?[0-9]*')
              .firstMatch(i.body.toString())
              ?.group(0);
          if (temp![0] == ' ' || temp[0] == '.') {
            temp = temp.substring(1);
          }
          print('temp' + i.body.toString());
          try {
            int amount = int.parse(temp);
            if (amount > 10) {
              print(amount);
              print(i.date);
              FirebaseFirestore.instance
                  .collection('users')
                  .doc(FirebaseAuth.instance.currentUser!.phoneNumber!)
                  .collection('messages')
                  .doc(i.date!.toString())
                  .set({
                'amount': amount,
                'time': DateTime.fromMillisecondsSinceEpoch(i.date!)
              });
            }
          } catch (e) {
            print('error in regex');
          }
        }
      }
    }
    prefs.setInt('timestamp', DateTime.now().millisecondsSinceEpoch);
  }

  getVersionData() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String localVersion = packageInfo.buildNumber;
    await FirebaseFirestore.instance
        .collection('minVersion')
        .doc('android')
        .get()
        .then((DocumentSnapshot doc) {
      if (int.parse(localVersion) < int.parse(doc['code'])) {
        buildUpdateDialog(context);
      }
    });
  }

  buildUpdateDialog(BuildContext context) {
    AlertDialog alert = AlertDialog(
      title: const Text("New version available!"),
      content: const Text("Please update the app to continue."),
      actions: [
        TextButton(
          child: const Text(
            "UPDATE",
            style: TextStyle(fontWeight: FontWeight.w800),
          ),
          onPressed: () {
            LaunchReview.launch();
          },
        )
      ],
    );

    showDialog(
      context: context,
      barrierColor: Colors.black87,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return WillPopScope(
          child: alert,
          onWillPop: () => Future.value(false),
        );
      },
    );
  }
}
