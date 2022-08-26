import 'package:flutter/material.dart';

class TextBetweenLines extends StatelessWidget {
  const TextBetweenLines({required this.title, Key? key}) : super(key: key);
  final String title;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Flexible(
          child: Container(
            width: double.infinity,
            height: 1,
            color: Colors.grey[300],
          ),
        ),
        Text(
          '  $title  '.toUpperCase(),
          style: TextStyle(color: Colors.grey[400]),
        ),
        Flexible(
          child: Container(
            width: double.infinity,
            height: 1,
            color: Colors.grey[300],
          ),
        ),
      ],
    );
  }
}
