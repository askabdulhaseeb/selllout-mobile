import 'package:flutter/material.dart';

class ComingSoonScreen extends StatelessWidget {
  const ComingSoonScreen({Key? key}) : super(key: key);
  static const String routeName = '/coming-soon-screen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        iconTheme: Theme.of(context).iconTheme,
        elevation: 0,
        centerTitle: false,
        titleSpacing: 0,
        title: Text(
          'Back',
          style: TextStyle(color: Theme.of(context).primaryColor),
        ),
      ),
      body: const SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Padding(
          padding: EdgeInsets.only(left: 60, right: 60, bottom: 120),
          child: FittedBox(
            child: Text('Coming Soon...'),
          ),
        ),
      ),
    );
  }
}
