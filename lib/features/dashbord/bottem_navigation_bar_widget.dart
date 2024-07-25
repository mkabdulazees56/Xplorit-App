// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors, unused_local_variable

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:xplorit/features/athuntication/screens/mode_selection.dart';
import 'package:xplorit/features/athuntication/screens/onborading.dart';
import 'package:xplorit/utils/constants/colors.dart';

class MyBottomNavigationBar extends StatefulWidget {
  @override
  State<MyBottomNavigationBar> createState() => _MyBottomNavigationBarState();
}

class _MyBottomNavigationBarState extends State<MyBottomNavigationBar> {
  get bottomNavBarCurrentIndex => null;

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: bottomNavBarCurrentIndex,
      unselectedItemColor: TColors.darkGrey,
      selectedItemColor: TColors.primary,
      backgroundColor: TColors.secondary,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.search),
          label: 'Search',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.notifications),
          label: 'Alerts',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.all_inbox),
          label: 'Inbox',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.account_circle),
          label: 'Account',
        ),
      ],
      onTap: (index) {
        setState(() {
          var bottomNavBarCurrentIndex = index;
        });
        switch (index) {
          case 0:
            Get.to(OnBoadingScreen());
            break;
          case 1:
            Get.to(ModeSelection(
              userStatus: true,
            ));

            break;
          case 2:
            Navigator.pushNamed(context, '/alerts');
            break;
          case 3:
            Navigator.pushNamed(context, '/myBookings');
            break;
          case 4:
            Navigator.pushNamed(context, '/account');
            break;
        }
      },
    );
  }
}
