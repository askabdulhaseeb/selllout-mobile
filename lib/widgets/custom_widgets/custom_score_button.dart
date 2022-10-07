import 'package:flutter/material.dart';
import '../../utilities/utilities.dart';

class CustomScoreButton extends StatelessWidget {
  const CustomScoreButton({
    required this.score,
    required this.title,
    required this.onTap,
    Key? key,
  }) : super(key: key);
  final VoidCallback onTap;
  final String score;
  final String title;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(Utilities.borderRadius / 2),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            score,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).primaryColor,
              fontSize: 20,
            ),
          ),
          Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 12),
          ),
        ],
      ),
    );
  }
}
