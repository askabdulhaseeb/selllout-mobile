import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import '../../models/chat/chat.dart';
import '../../models/chat/message.dart';
import 'message_tile.dart';

class MessageLists extends StatefulWidget {
  const MessageLists({required this.messages, this.chat, Key? key})
      : super(key: key);

  final List<Message> messages;
  final Chat? chat;

  @override
  State<MessageLists> createState() => MessageListsState();
}

class MessageListsState extends State<MessageLists>
    with WidgetsBindingObserver {
  final ScrollController _controller = ScrollController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      _controller.jumpTo(_controller.position.maxScrollExtent);
    });
    return Expanded(
      child: Container(
        constraints: const BoxConstraints(
          minWidth: 100,
        ),
        child: ListView.builder(
          shrinkWrap: true,
          controller: _controller,
          itemCount: widget.messages.length,
          itemBuilder: (BuildContext context, int index) =>
              MessageTile(message: widget.messages[index], chat: widget.chat),
        ),
      ),
    );
  }
}
