import 'dart:io';
import 'package:flutter/material.dart';

class CustomFileImageBox extends StatelessWidget {
  const CustomFileImageBox({
    required this.onTap,
    this.title = 'Upload Image',
    this.size = 80,
    this.file,
    this.padding,
    this.iconColor,
    Key? key,
  }) : super(key: key);
  final File? file;
  final String title;
  final VoidCallback onTap;
  final EdgeInsetsGeometry? padding;
  final Color? iconColor;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: <Widget>[
          GestureDetector(
            onTap: onTap,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Container(
                height: size,
                width: size,
                color: Theme.of(context).primaryColor,
                child: file == null
                    ? Padding(
                        padding: padding ?? EdgeInsets.zero,
                        child: FittedBox(
                          child: Icon(
                            Icons.person,
                            color: iconColor ?? Colors.white,
                          ),
                        ),
                      )
                    : SizedBox(
                        height: double.infinity,
                        width: double.infinity,
                        child: Image.file(
                          File(file!.path),
                          fit: BoxFit.cover,
                        ),
                      ),
              ),
            ),
          ),
          TextButton(
            onPressed: onTap,
            style: TextButton.styleFrom(padding: const EdgeInsets.all(0)),
            child: Text(title, style: const TextStyle(height: 1)),
          ),
        ],
      ),
    );
  }
}
