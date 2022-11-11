import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:telephony/telephony.dart';
import 'package:testings/models/change.dart';

class AutoPayWalkThrough extends StatefulWidget {
  const AutoPayWalkThrough({Key? key}) : super(key: key);

  @override
  _AutoPayWalkThroughState createState() => _AutoPayWalkThroughState();
}

class _AutoPayWalkThroughState extends State<AutoPayWalkThrough> {
  final telephony = Telephony.instance;
  final ready = BoolChange();
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
                        Navigator.pop(context);
                      }
                    },
                    child: Text(
                      currentPage<7?'NEXT':'GOT IT!',
                      style: TextStyle(
                        color: Color(0xffffffff),
                        fontWeight: FontWeight.w400,
                        fontSize: 20,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(10.0),
                      ), backgroundColor: Color(0xffD19549),
                      elevation: 10,
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
