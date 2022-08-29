import 'package:flutter/material.dart';

import '../../models/chat/chat.dart';
import 'chat_text_field.dart';

class ChatMessageTile extends StatefulWidget {
  const ChatMessageTile({required this.chat, Key? key}) : super(key: key);
  final Chat chat;
  @override
  State<ChatMessageTile> createState() => _ChatMessageTileState();
}

class _ChatMessageTileState extends State<ChatMessageTile> {
  static const double borderRadius = 12;
  bool isVoiceMessage = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor.withOpacity(0.3),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(borderRadius * 2),
          topRight: Radius.circular(borderRadius * 2),
        ),
      ),
      child: isVoiceMessage
          ? const SizedBox()
          // ChatVoiceMessage(
          //     chat: widget.chat,
          //     onCancelRecoding: () => setState(() {
          //       isVoiceMessage = false;
          //     }),
          //   )
          : ChatTextField(
              chat: widget.chat,
              // onStartRecoding: () => setState(() {
              //   isVoiceMessage = true;
              // }),
              onStartRecoding: () {},
            ),
    );
  }
}
