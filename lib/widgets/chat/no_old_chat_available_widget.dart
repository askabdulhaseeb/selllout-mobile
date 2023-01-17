import 'package:flutter/material.dart';

class NoOldChatAvailableWidget extends StatelessWidget {
  const NoOldChatAvailableWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const <Widget>[
          Text(
            'Say Salam!',
            style: TextStyle(
              color: Colors.grey,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            'and start conversation',
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
