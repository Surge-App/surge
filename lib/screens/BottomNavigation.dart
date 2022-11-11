// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:testings/screens/locker.dart';
import 'package:testings/screens/profile.dart';
import 'package:testings/screens/transaction.dart';
import 'package:testings/screens/home.dart';

class BottomBar extends StatefulWidget {
  const BottomBar({Key? key}) : super(key: key);

  @override
  State<BottomBar> createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  List pages = [HomeScreen(), Transaction(), Locker(), Profile()];

  int currentIndex = 0;
  void OnTap(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff060427),
      bottomNavigationBar: BottomNavigationBar(
        unselectedFontSize: 0,
        selectedFontSize: 0,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Color(0xff060427),
        onTap: OnTap,
        currentIndex: currentIndex,
        selectedItemColor: Color(0XFF9B4BFF),
        unselectedItemColor: Colors.white,
        showUnselectedLabels: false,
        showSelectedLabels: false,
        elevation: 0,
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined), title: Text("Home")),
          BottomNavigationBarItem(
              icon: Icon(Icons.event_note_outlined),
              title: Text("Transaction")),
          BottomNavigationBarItem(
              icon: Icon(Icons.account_balance_wallet_outlined),
              title: Text("wallet")),
          BottomNavigationBarItem(
              icon: Icon(Icons.settings), title: Text("Profile")),
        ],
      ),
      body: pages[currentIndex],
    );
  }
}


// class _BottomBarState extends State<BottomBar> {
//   PageController pageController = PageController();
//   int _selectedIndex = 0;

//   // static const TextStyle optionStyle =
//   // TextStyle(fontSize: 30, fontWeight: FontWeight.w600);
//   static List<Widget> _widgetOptions = <Widget>[
//     HomeScreen(),
//     Transaction(),
//     Locker(),
//     Profile()
//   ];

//   // void _onTapped(int index) {
//   //   setState(() {
//   //     _selectedIndex = index;
//   //   });
//   //   pageController.jumpToPage(index);
//   // }

//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Scaffold(
//         backgroundColor: Color(0xff0D104E),
//         // bottomNavigationBar: ClipRRect(
//         //   borderRadius: BorderRadius.only(topLeft: Radius.circular(40.0), topRight: Radius.circular(40.0), ),
//         //   child: BottomNavigationBar(
//         //     items: const <BottomNavigationBarItem>[
//         //       BottomNavigationBarItem(
//         //         icon: Icon(Icons.home,color: Color(0xff473270),),
//         //         label: '',
//         //       ),
//         //       BottomNavigationBarItem(
//         //         icon: Icon(Icons.change_circle_outlined,color: Color(0xff473270)),
//         //         label: '',
//         //       ),
//         //       BottomNavigationBarItem(
//         //         icon: Icon(Icons.lock,color: Color(0xff473270)),
//         //         label: '',
//         //       ),
//         //       BottomNavigationBarItem(
//         //         icon: Icon(Icons.person,color: Color(0xff473270)),
//         //         label: '',
//         //       ),
//         //     ],
//         //     currentIndex: _selectedIndex,
//         //     onTap: _onTapped,
//         //     type: BottomNavigationBarType.fixed,
//         //     backgroundColor: Color(0xffE4A951),
//         //   ),
//         // ),
//         bottomNavigationBar: Container(
//           decoration: BoxDecoration(
//             // borderRadius: BorderRadius.only(
//             //     topLeft: Radius.circular(40), topRight: Radius.circular(40)),
//             color: Colors.white,
//             boxShadow: [
//               BoxShadow(
//                 blurRadius: 20,
//                 color: Colors.black.withOpacity(.1),
//               )
//             ],
//           ),
//           child: SafeArea(
//             child: Padding(
//               padding:
//                   const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8),
//               child: GNav(
//                 rippleColor: Colors.deepPurpleAccent,
//                 hoverColor: Colors.deepPurpleAccent,
//                 gap: 8,
//                 activeColor: Colors.deepPurpleAccent,
//                 iconSize: 24,
//                 padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
//                 duration: Duration(milliseconds: 400),
//                 tabBackgroundColor: Colors.deepPurple.shade100,
//                 color: Colors.black,
//                 tabs: [
//                   GButton(
//                     icon: Icons.home,
//                     text: 'Home',
//                   ),
//                   GButton(
//                     icon: Icons.receipt,
//                     text: 'History',
//                   ),
//                   GButton(
//                     icon: Icons.verified_user_rounded,
//                     text: 'Locker',
//                   ),
//                   GButton(
//                     icon: Icons.person,
//                     text: 'Profile',
//                   ),
//                 ],
//                 selectedIndex: _selectedIndex,
//                 onTabChange: (index) {
//                   setState(() {
//                     _selectedIndex = index;
//                   });
//                 },
//               ),
//             ),
//           ),
//         ),
//         // body: PageView(
//         //   controller: pageController,
//         //   children: [
//         //     HomeScreen(),
//         //     Transaction(),
//         //     Locker(),
//         //     Profile(),
//         //   ],
//         //   physics: NeverScrollableScrollPhysics(),
//         // ),
//         body: Center(
//           child: _widgetOptions.elementAt(_selectedIndex),
//         ),
//       ),
//     );
//   }
// }
