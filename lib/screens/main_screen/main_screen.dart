import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:selllout/screens/cart/cart_screen.dart';

import '../../database/auth_methods.dart';
import '../../database/notification_service.dart';
import '../../database/user_api.dart';
import '../../models/app_user.dart';
import '../../models/device_token.dart';
import '../../providers/app_provider.dart';
import '../../providers/user/user_provider.dart';
import '../user_screens/user_blocked_screeb.dart';
import 'main_bottom_navigation_bar.dart';
import 'pages/add_product_page.dart';
import 'pages/chat_page.dart';
import 'pages/home_page.dart';
import 'pages/live_page.dart';
import 'pages/profile_page.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);
  static const String rotueName = '/main-screen';
  @override
  // ignore: library_private_types_in_public_api
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  void didChangeDependencies() {
    if (Provider.of<UserProvider>(context, listen: false)
            .user(uid: AuthMethods.uid)
            .isBlock ??
        false) {
      Navigator.of(context).pushNamedAndRemoveUntil(
          UserBlockedScreen.routeName, (Route<dynamic> route) => false);
    }
    super.didChangeDependencies();
  }

  static const List<Widget> _pages = <Widget>[
    HomePage(),
    CartPage(),
    LivePage(),
    AddProductPage(),
    ChatPage(),
    ProfilePage(),
  ];
  @override
  Widget build(BuildContext context) {
    int currentIndex = Provider.of<AppProvider>(context).currentTap;
    log('Current User: ${AuthMethods.uid}');
    return Scaffold(
      body: IndexedStack(index: currentIndex, children: _pages),
      bottomNavigationBar: const MainBottomNavigationBar(),
    );
  }
}
