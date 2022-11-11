import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coingecko_dart/coingecko_dart.dart';
import 'package:coingecko_dart/dataClasses/coins/PricedCoin.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:testings/services/db.dart';

class WithdrawScreen extends StatefulWidget {
  final btcBal;
  const WithdrawScreen({Key? key, this.btcBal}) : super(key: key);

  @override
  _WithdrawScreenState createState() => _WithdrawScreenState();
}

CoinGeckoApi cgApi = CoinGeckoApi();

Future<double?> getPrice() async {
  CoinGeckoResult<List<PricedCoin>> result = await cgApi.simplePrice(
    ids: ["bitcoin"],
    vs_currencies: ["inr"],
  );
  return result.data[0].data["inr"];
}

FocusNode focusNode = FocusNode();
TextEditingController textEditingController = TextEditingController();
double? _inputVal;

class _WithdrawScreenState extends State<WithdrawScreen> {
  Db db = Db();
  @override
  void initState() {
    textEditingController.text = '0';
    _inputVal = 0;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xff0473270),
        body: SingleChildScrollView(
          child: SafeArea(
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(Icons.arrow_back, color: Colors.white)),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20.0),
                        child: Text(
                          'Withdraw',
                          style: TextStyle(color: Colors.white, fontSize: 25),
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Center(
                          child: CircleAvatar(
                            radius: 15,
                            backgroundColor: Color(0xffF9A42F),
                            child: FaIcon(
                              FontAwesomeIcons.btc,
                              size: 20,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 20.0),
                            child: Text(
                              '${widget.btcBal} available',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 50.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Center(
                            child: CircleAvatar(
                              radius: 25,
                              backgroundColor: Color(0xffF9A42F),
                              child: FaIcon(
                                FontAwesomeIcons.btc,
                                size: 35,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          SizedBox(width: 10),
                          SizedBox(
                            width: 200,
                            child: TextField(
                              keyboardType: TextInputType.number,
                              textAlign: TextAlign.center,
                              maxLength: 8,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 30,
                                  fontWeight: FontWeight.w700,
                              ),
                              onChanged: (value){
                                setState(() {
                                  _inputVal = double.parse(value);
                                });
                              },
                              controller: textEditingController,
                              autofocus: true,
                              decoration: InputDecoration(
                                counterText: '',
                                border: OutlineInputBorder(),
                                isDense: true,
                                contentPadding: EdgeInsets.only(
                                    left: 10, bottom: 11, top: 11, right: 10),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 25,),
                    Padding(
                      padding: const EdgeInsets.only(left: 25),
                      child: Container(
                        alignment: Alignment.bottomLeft,
                        child: Text(
                          'Final value',
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
                                                      ).format(_inputVal! * double.parse(data.toString())),
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
                    Padding(
                      padding: const EdgeInsets.only(top: 50.0),
                      child: ElevatedButton(
                        onPressed: () async {
                          if(double.parse(textEditingController.text)>double.parse(widget.btcBal)){
                            Fluttertoast.showToast(
                                msg: "Withdraw amount can not be greater than available balance",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.TOP,
                                timeInSecForIosWeb: 1,
                                backgroundColor: Colors.red.shade400,
                                textColor: Colors.white,
                                fontSize: 16.0
                            );
                          } else if(double.parse(textEditingController.text) == 0){
                            Fluttertoast.showToast(
                                msg: "Withdraw amount too low",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.TOP,
                                timeInSecForIosWeb: 1,
                                backgroundColor: Colors.red.shade400,
                                textColor: Colors.white,
                                fontSize: 16.0
                            );
                          } else{
                            CoinGeckoResult<List<PricedCoin>> result = await cgApi.simplePrice(
                              ids: ["bitcoin"],
                              vs_currencies: ["inr"],
                            );
                            double? price = result.data[0].data["inr"];
                            FirebaseFirestore.instance.collection('users')
                                .doc(FirebaseAuth.instance.currentUser!.phoneNumber!)
                                .update({
                              'amount': double.parse((double.parse(widget.btcBal)-double.parse(textEditingController.text)).toStringAsFixed(6)).toString(),
                            });
                            FirebaseFirestore.instance.collection('users')
                                .doc(FirebaseAuth.instance.currentUser!.phoneNumber!).collection('withdraw').doc()
                                .set({
                              'btc':
                                      double.parse(textEditingController.text)
                                  .toString(),
                              'amount': _inputVal! * double.parse(price.toString()),
                              'time': DateTime.now()
                            });
                            Navigator.pop(context);
                            Fluttertoast.showToast(
                                msg: "Withdraw successful",
                                toastLength: Toast.LENGTH_LONG,
                                gravity: ToastGravity.TOP,
                                timeInSecForIosWeb: 1,
                                backgroundColor: Colors.black54,
                                textColor: Colors.white,
                                fontSize: 16.0
                            );
                          }
                        },
                        child: Text(
                          'WITHDRAW',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                            fontSize: 20,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          shape: new RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(10.0),
                          ), backgroundColor: Color(0xff14EE80),
                          elevation: 10,
                          padding: EdgeInsets.symmetric(horizontal: 100, vertical: 15),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ));
  }
}
