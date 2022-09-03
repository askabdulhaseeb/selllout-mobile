import 'package:flutter/material.dart';

class TitleAndDetailWidget extends StatelessWidget {
  const TitleAndDetailWidget({
    required this.title,
    required this.subtitle,
    super.key,
  });
  final String title;
  final String subtitle;
  @override
  Widget build(BuildContext context) {
    TextStyle boldTextStyle = TextStyle(
      fontWeight: FontWeight.bold,
      color: Theme.of(context).textTheme.labelLarge!.color,
    );
    TextStyle simpleTextStyle = TextStyle(
      color: Theme.of(context).textTheme.labelLarge!.color,
      fontWeight: FontWeight.w500,
    );
    return RichText(
      text: TextSpan(
        children: <TextSpan>[
          TextSpan(text: '$title: ', style: boldTextStyle),
          TextSpan(
            text: subtitle,
          ),
        ],
        style: simpleTextStyle,
      ),
    );
  }
}
