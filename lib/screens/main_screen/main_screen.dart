import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/app_provider.dart';
import 'main_bottom_navigation_bar.dart';
import 'pages/add_product_page/add_product_page.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);
  static const String rotueName = '/MainScrenn';
  @override
  // ignore: library_private_types_in_public_api
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  static const List<Widget> _pages = <Widget>[
    Center(child: Text('HomePage(),')),
    Center(child: Text('BetScreen(),')),
    AddProductPage(),
    Center(child: Text('MessagePage(),')),
    Center(child: Text('MyProdilePage(),')),
  ];
  @override
  Widget build(BuildContext context) {
    int currentIndex = Provider.of<AppProvider>(context).currentTap;
    // Provider.of<UserProvider>(context).init();
    // Provider.of<ProdProvider>(context).init();
    return Scaffold(
      body: _pages[currentIndex],
      bottomNavigationBar: const MainBottomNavigationBar(),
    );
  }
}
