import 'package:flutter/material.dart';

class TextFieldLikeBG extends StatelessWidget {
  const TextFieldLikeBG({
    required this.child,
    this.width,
    this.padding,
    this.bgColor,
    this.borderRadius,
    Key? key,
  }) : super(key: key);

  final double? width;
  final EdgeInsetsGeometry? padding;
  final Color? bgColor;
  final BorderRadiusGeometry? borderRadius;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width ?? double.infinity,
      padding: padding ?? const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bgColor ??
            Theme.of(context).textTheme.bodyText1!.color!.withOpacity(0.1),
        borderRadius: borderRadius ?? BorderRadius.circular(12),
      ),
      child: child,
    );
  }
}
