import 'package:flutter/material.dart';

import '../../../database/chat_api.dart';
import '../../../models/chat/chat.dart';
import '../../../models/chat/message.dart';
import '../../../widgets/chat/chat_message_tile.dart';
import '../../../widgets/chat/messages_list.dart';
import '../../../widgets/chat/no_old_chat_available_widget.dart';
import '../../../widgets/custom_widgets/custom_profile_image.dart';
import '../../../widgets/custom_widgets/show_loading.dart';
import 'group_info_screen.dart';

class GroupChatScreen extends StatelessWidget {
  const GroupChatScreen({required this.chat, Key? key}) : super(key: key);
  final Chat chat;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: InkWell(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute<GroupInfoScreen>(
                builder: (BuildContext context) => GroupInfoScreen(chat: chat),
              ),
            );
          },
          child: Row(
            children: <Widget>[
              CustomProfileImage(imageURL: chat.groupInfo?.imageURL ?? ''),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(chat.groupInfo?.name ?? 'no name'),
                    Text(
                      'Tab here to get group details',
                      style: TextStyle(
                        color: Colors.grey.shade700,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: StreamBuilder<List<Message>>(
              stream: ChatAPI().messages(chat.chatID),
              builder: (BuildContext context,
                  AsyncSnapshot<List<Message>> snapshot) {
                if (snapshot.hasError) {
                  return const Center(child: Text('Facing some error'));
                } else if (snapshot.hasData) {
                  final List<Message> messages = snapshot.data!;
                  return messages.isEmpty
                      ? const NoOldChatAvailableWidget()
                      : MessageLists(messages: messages, chat: chat);
                } else {
                  return const ShowLoading();
                }
              },
            ),
          ),
          ChatMessageTile(chat: chat),
        ],
      ),
    );
  }
}
