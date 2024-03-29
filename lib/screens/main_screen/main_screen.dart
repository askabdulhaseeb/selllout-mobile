import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../database/auth_methods.dart';
import '../../providers/app_provider.dart';
import '../../providers/user/user_provider.dart';
import '../../utilities/app_image.dart';
import '../live_screens/bid_page/bid_page.dart';
import '../user_screens/search_user_screen.dart';
import '../user_screens/user_blocked_screeb.dart';
import 'main_bottom_navigation_bar.dart';
import 'pages/add_product_page.dart';
import 'pages/explore_page.dart';
import 'pages/chat_page.dart';
import 'pages/home_page.dart';
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
    ExplorePage(),
    BidPage(),
    AddProductPage(),
    ChatPage(),
    ProfilePage(),
  ];
  @override
  Widget build(BuildContext context) {
    int currentIndex = Provider.of<AppProvider>(context).currentTap;
    log('Current User: ${AuthMethods.uid}');
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          leading: Padding(
            padding: const EdgeInsets.all(8),
            child: Image.asset(AppImages.logo),
          ),
          title: GestureDetector(
            onTap: () {
              Navigator.of(context).pushNamed(SearchUserScreen.routeName);
            },
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(CupertinoIcons.search, color: Colors.grey),
            ),
          ),
          actions: <Widget>[
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.notifications_active_outlined,
                color: Colors.grey,
              ),
            ),
            const SizedBox(width: 16),
          ],
        ),
        body: IndexedStack(index: currentIndex, children: _pages),
        bottomNavigationBar: const MainBottomNavigationBar(),
      ),
    );
  }
}
