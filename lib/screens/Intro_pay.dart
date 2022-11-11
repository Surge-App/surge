import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
//import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:telephony/telephony.dart';
//import 'package:testings/main.dart';
import 'package:testings/models/change.dart';
import 'package:testings/services/db.dart';
import 'package:testings/services/razorpay.dart';
import 'package:testings/services/razorpay_post.dart';

class IntroPayScreen extends StatefulWidget {
  const IntroPayScreen({Key? key}) : super(key: key);

  @override
  _IntroPayScreenState createState() => _IntroPayScreenState();
}

class _IntroPayScreenState extends State<IntroPayScreen> {
  final telephony = Telephony.instance;
  final ready = BoolChange();
  late RP _razorpay;
  String phone = FirebaseAuth.instance.currentUser!.phoneNumber!;
  Db db = Db();
  final controller = PageController();
  final phoneController = TextEditingController();
  int currentPage = 0;
  @override
  void dispose() {
    controller.dispose();
    super.dispose();
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
        body: Container(
          color: Color(0xff190F25),
          child: Stack(
            children: [
              Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: PageView(
                  controller: controller,
                  onPageChanged: (value){
                    setState(() {
                      currentPage = value;
                    });
                  },
                  children: [
                    buildPage(
                      urlImage: 'assets/000.png',
                    ),
                    buildPage(
                      urlImage: 'assets/001.png',
                    ),
                    buildPage(
                      urlImage: 'assets/002.png',
                    ),
                    buildPage(
                      urlImage: 'assets/003.png',
                    ),
                    buildPage(
                      urlImage: 'assets/004.png',
                    ),
                    buildPage(
                      urlImage: 'assets/005.png',
                    ),
                    buildPage(
                      urlImage: 'assets/006.png',
                    ),
                    buildPage(
                      urlImage: 'assets/007.png',
                    ),
                  ],
                ),
              ),
              Positioned(
                bottom: 10,
                left: 0,
                right: 0,
                child: Column(
                  children: [
                    Container(
                      color: Colors.transparent,
                      height: MediaQuery.of(context).size.height * 0.05,
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // TextButton(
                          //     onPressed: () => controller.jumpToPage(5),
                          //     child: Text('Skip',
                          //         style: TextStyle(
                          //             fontWeight: FontWeight.bold, fontSize: 18))),
                          Center(
                            child: SmoothPageIndicator(
                              controller: controller,
                              count: 8,
                              effect: WormEffect(
                                dotHeight: 10,
                                dotWidth: 10,
                                activeDotColor: Colors.deepPurple,
                                dotColor: Colors.white,
                                spacing: 10,
                              ),
                              onDotClicked: (index) => controller.animateToPage(
                                  index,
                                  duration: Duration(milliseconds: 500),
                                  curve: Curves.easeIn),
                            ),
                          ),
                          // TextButton(
                          //     onPressed: () => controller.nextPage(
                          //         duration: Duration(milliseconds: 500),
                          //         curve: Curves.easeInOut),
                          //     child: Text('Next',
                          //         style: TextStyle(
                          //             fontWeight: FontWeight.bold, fontSize: 18))),
                        ],
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        if(currentPage<7){
                          controller.animateToPage(
                              currentPage+1,
                              duration: Duration(milliseconds: 400),
                              curve: Curves.easeIn
                          );
                        } else{
                          var cust = await RazorPayAPIpost().createCustomer(
                              await db.name, phone, await db.email);
                          Db().addCustomerId(cust.custId!);
                          var order = await RazorPayAPIpost()
                              .createAuthOrder(cust.custId!);
                          print(order.orderId);
                          _razorpay.checkout(await db.name, phone, await db.email,
                              order.orderId!, cust.custId!);
                        }
                      },
                      child: Text(
                        currentPage<7?'NEXT':'Setup Auto-Invest',
                        style: TextStyle(
                          color: Color(0xffffffff),
                          fontWeight: FontWeight.w400,
                          fontSize: 20,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        shape: new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(10.0),
                        ),
                        elevation: 10,
                        primary: Color(0xffD19549),
                        padding: EdgeInsets.symmetric(
                            horizontal:
                                MediaQuery.of(context).size.width * 0.25,
                            vertical:
                                MediaQuery.of(context).size.height * 0.012),
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

  Widget buildPage({
    required String urlImage,
  }) =>
      Column(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.02,
          ),
          Container(
            height: MediaQuery.of(context).size.height * 0.85,
            width: MediaQuery.of(context).size.width,
            child: Image.asset(urlImage, fit: BoxFit.fill),
          ),
        ],
      );
}
