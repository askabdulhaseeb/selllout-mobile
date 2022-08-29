import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ChatPersonSearch extends StatefulWidget {
  const ChatPersonSearch({
    required this.onChanged,
    this.hint = 'Search',
    Key? key,
  }) : super(key: key);
  final void Function(String)? onChanged;
  final String hint;

  @override
  // ignore: library_private_types_in_public_api
  _ChatPersonSearchState createState() => _ChatPersonSearchState();
}

class _ChatPersonSearchState extends State<ChatPersonSearch> {
  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: TextFormField(
        onChanged: widget.onChanged,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.all(0),
          hintText: widget.hint,
          prefixIcon: const Icon(CupertinoIcons.search),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }
}
