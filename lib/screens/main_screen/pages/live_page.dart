import 'package:flutter/material.dart';

import '../../live_screens/bid_page/bid_page.dart';

class LivePage extends StatelessWidget {
  const LivePage({Key? key}) : super(key: key);
  static const String routeName = '/live-page';

  static const List<Widget> _tabs = <Widget>[
    Tab(icon: Icon(Icons.live_tv)),
    Tab(icon: Icon(Icons.explore)),
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: _tabs.length,
      child: const TabBarView(
        children: <Widget>[
          BidPage(),
          Center(child: Text('Explore Page')),
        ],
      ),
    );
  }
}
