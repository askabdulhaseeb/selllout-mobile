import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/app_provider.dart';
import '../../providers/product/product_provider.dart';
import '../../providers/user_provider.dart';
import 'main_bottom_navigation_bar.dart';
import 'pages/add_product_page/add_product_page.dart';
import 'pages/chat_page.dart';
import 'pages/home_page/home_page.dart';
import 'pages/profile_page.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);
  static const String rotueName = '/MainScrenn';
  @override
  // ignore: library_private_types_in_public_api
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  static const List<Widget> _pages = <Widget>[
    HomePage(),
    Center(child: Text('BetScreen(),')),
    AddProductPage(),
    ChatPage(),
    ProfilePage(),
  ];
  @override
  Widget build(BuildContext context) {
    int currentIndex = Provider.of<AppProvider>(context).currentTap;
    Provider.of<UserProvider>(context).init();
    Provider.of<ProductProvider>(context).init();
    return Scaffold(
      body: IndexedStack(index: currentIndex, children: _pages),
      bottomNavigationBar: const MainBottomNavigationBar(),
    );
  }
}
