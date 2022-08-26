import 'package:flutter/material.dart';

class CustomTitleText extends StatelessWidget {
  const CustomTitleText({
    required this.title,
    this.padding,
    this.style,
    Key? key,
  }) : super(key: key);
  final String title;
  final EdgeInsetsGeometry? padding;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? const EdgeInsets.only(top: 8),
      child: Text(
        ' $title',
        style: style ??
            const TextStyle(
              fontWeight: FontWeight.bold,
            ),
      ),
    );
  }
}
