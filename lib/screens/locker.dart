import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coingecko_dart/coingecko_dart.dart';
import 'package:coingecko_dart/dataClasses/coins/PricedCoin.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:testings/screens/withdraw.dart';
import 'package:testings/services/db.dart';

class Locker extends StatefulWidget {
  const Locker({Key? key}) : super(key: key);

  @override
  _LockerState createState() => _LockerState();
}

class _LockerState extends State<Locker> {
  Db db = Db();

  CoinGeckoApi cgApi = CoinGeckoApi();

  Future<double?> getPrice() async {
    CoinGeckoResult<List<PricedCoin>> result = await cgApi.simplePrice(
      ids: ["bitcoin"],
      vs_currencies: ["inr"],
    );
    return result.data[0].data["inr"];
  }

  @override
  Widget build(BuildContext context) {
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
      backgroundColor: Color(0xff0473270),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Text(
                'Locker',
                style: TextStyle(
                    fontSize: 40,
                    color: Color(0xffE4A951),
                    fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 15),
            Text(
              'Live Sell Price',
              style: TextStyle(
                  fontSize: 25, color: Colors.white, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 15,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width/10*5.2,
                  height: 50,
                  decoration: BoxDecoration(
                      color: Color(0xff533B6D),
                      borderRadius: BorderRadius.all(Radius.circular(20))),
                  child: Center(
                    child: FutureBuilder(
                      builder: (ctx, snapshot) {
                        if (snapshot.connectionState == ConnectionState.done) {
                          if (snapshot.hasError) {
                            return Center(
                              child: Text(
                                '${snapshot.error} occurred',
                                style: TextStyle(fontSize: 18),
                              ),
                            );
                          } else if (snapshot.hasData) {
                            final data = snapshot.data;
                            return Center(
                              child: Text(
                                  NumberFormat.currency(
                                    symbol: '₹ ',
                                    locale: "HI"
                                  ).format(data),
                                  style: TextStyle(
                                      fontSize: 25,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold
                                  )
                              ),
                            );
                          }
                        }
                        return SizedBox(
                          height: 20,
                          width: 20,
                          child: Center(
                            child: CircularProgressIndicator(color: Colors.white),
                          ),
                        );
                      },
                      future: getPrice(),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                Text(
                  '/BTC',
                  style: TextStyle(
                      fontSize: 25,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.center,
            //   children: [
            //     Text(
            //       'Price Valid for',
            //       style: TextStyle(
            //           fontSize: 18,
            //           color: Colors.white,
            //           fontWeight: FontWeight.bold),
            //     ),
            //     SizedBox(
            //       width: 5,
            //     ),
            //     Text(
            //       '6:30PM',
            //       style: TextStyle(
            //           fontSize: 18,
            //           color: Colors.redAccent,
            //           fontWeight: FontWeight.bold),
            //     ),
            //   ],
            // ),
            SizedBox(
              height: 10,
            ),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            //   children: [
            //     Text(
            //       'Available to sell',
            //       style: TextStyle(
            //           fontSize: 25,
            //           color: Colors.white,
            //           fontWeight: FontWeight.bold),
            //     ),
            //     SizedBox(width: 20),
            //     Container(
            //       width: 120,
            //       height: 50,
            //       decoration: BoxDecoration(
            //           color: Color(0xff533B6D),
            //           borderRadius: BorderRadius.all(Radius.circular(20))),
            //       child: Center(
            //         child: Text(
            //           '14 BTC',
            //           style: TextStyle(
            //               fontSize: 25,
            //               color: Colors.white,
            //               fontWeight: FontWeight.bold),
            //         ),
            //       ),
            //     ),
            //   ],
            // ),
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.only(left: 25),
              child: Container(
                alignment: Alignment.bottomLeft,
                child: Text(
                  'Bitcoin balance',
                  textAlign: TextAlign.start,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w800),
                ),
              ),
            ),
            StreamBuilder<DocumentSnapshot>(
              stream: db.listenToDb,
              builder:
                  (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                if (snapshot.hasData) {
                  return Column(
                    children: [
                      Center(
                        child: Column(
                          children: [
                            Card(
                              color: Color(0xff533B6D),
                              shape:
                              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                              margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    CircleAvatar(
                                      radius: 15,
                                      backgroundColor: Color(0xffF9A42F),
                                      child: FaIcon(
                                        FontAwesomeIcons.btc,
                                        size: 20,
                                        color: Colors.white,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 20,
                                    ),
                                    Text(
                                      '${snapshot.data!['amount'] ?? '0'}',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                } else {
                  return SizedBox();
                }
              },
            ),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 25),
              child: Container(
                alignment: Alignment.bottomLeft,
                child: Text(
                  'Current value',
                  textAlign: TextAlign.start,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w800),
                ),
              ),
            ),
            StreamBuilder<DocumentSnapshot>(
              stream: db.listenToDb,
              builder:
                  (context, AsyncSnapshot<DocumentSnapshot> snapshot1) {
                if (snapshot1.hasData) {
                  return FutureBuilder(
                    builder: (ctx, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        if (snapshot.hasError) {
                          return Center(
                            child: Text(
                              '${snapshot.error} occurred',
                              style: TextStyle(fontSize: 18),
                            ),
                          );
                        } else if (snapshot.hasData) {
                          final data = snapshot.data;
                          return Column(
                            children: [
                              Center(
                                child: Column(
                                  children: [
                                    Card(
                                      color: Color(0xff533B6D),
                                      shape:
                                      RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            CircleAvatar(
                                              radius: 15,
                                              backgroundColor: Color(0xffF00B85B),
                                              child: FaIcon(
                                                FontAwesomeIcons.rupeeSign,
                                                size: 20,
                                                color: Color(0xff533B6D),
                                              ),
                                            ),
                                            SizedBox(
                                              width: 20,
                                            ),
                                            Text(
                                              NumberFormat.currency(
                                                  symbol: '₹ ',
                                                  locale: "HI"
                                              ).format(double.parse(snapshot1.data!['amount']) * double.parse(data.toString() )),
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          );
                        }
                      }
                      return SizedBox(
                        height: 20,
                        width: 20,
                        child: Center(
                          child: CircularProgressIndicator(color: Colors.white),
                        ),
                      );
                    },
                    future: getPrice(),
                  );
                } else {
                  return SizedBox();
                }
              },
            ),
            SizedBox(
              height: 50,
            ),
            StreamBuilder<DocumentSnapshot>(
              stream: db.listenToDb,
              builder:
                  (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                if (snapshot.hasData) {
                  return ElevatedButton(
                    onPressed: () {
                      if(snapshot.data!['amount']=='0'|| snapshot.data!['amount']=='0.0'){
                        Fluttertoast.showToast(
                            msg: "Bitcoin balance too low",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.TOP,
                            timeInSecForIosWeb: 1,
                            backgroundColor: Colors.red.shade400,
                            textColor: Colors.white,
                            fontSize: 16.0
                        );
                      } else{
                        Navigator.push(context, MaterialPageRoute(builder: (context)=> WithdrawScreen(btcBal: snapshot.data!['amount'],)));
                      }
                    },
                    child: Text(
                      'WITHDRAW',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(10.0),
                      ),
                      elevation: 10,
                      primary: Color(0xff14EE80),
                      padding: EdgeInsets.symmetric(horizontal: 100, vertical: 15),
                    ),
                  );
                } else {
                  return SizedBox();
                }
              },
            ),
            SizedBox(
              height: 60,
            ),
            // ElevatedButton(
            //   onPressed: () {},
            //   child: Text(
            //     'History',
            //     style: TextStyle(
            //       color: Color(0xff464646),
            //       fontWeight: FontWeight.bold,
            //       fontSize: 20,
            //     ),
            //   ),
            //   style: ElevatedButton.styleFrom(
            //     shape: new RoundedRectangleBorder(
            //       borderRadius: new BorderRadius.circular(10.0),
            //     ),
            //     elevation: 10,
            //     primary: Color(0xffD19549),
            //     padding: EdgeInsets.symmetric(horizontal: 100, vertical: 15),
            //   ),
            // ),
          ],
        ),
      ),
    ));
  }
}