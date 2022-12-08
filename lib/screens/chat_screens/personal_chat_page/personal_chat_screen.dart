import 'package:flutter/material.dart';

import '../../../database/chat_api.dart';
import '../../../models/app_user.dart';
import '../../../models/chat/chat.dart';
import '../../../models/chat/message.dart';
import '../../../widgets/chat/chat_message_tile.dart';
import '../../../widgets/chat/messages_list.dart';
import '../../../widgets/custom_widgets/custom_profile_image.dart';
import '../../../widgets/custom_widgets/show_loading.dart';
import '../../user_screens/others_profile.dart';

class PersonalChatScreen extends StatelessWidget {
  const PersonalChatScreen({
    required this.chat,
    required this.chatWith,
    Key? key,
  }) : super(key: key);
  final Chat chat;
  final AppUser chatWith;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: false,
          title: InkWell(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute<OthersProfile>(
                  builder: (BuildContext context) =>
                      OthersProfile(user: chatWith),
                ),
              );
            },
            child: Row(
              children: <Widget>[
                CustomProfileImage(imageURL: chatWith.imageURL ?? ''),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(chatWith.displayName ?? 'no name'),
                      Text(
                        'Tab here to open profile',
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
            StreamBuilder<List<Message>>(
              stream: ChatAPI().messages(chat.chatID),
              builder: (BuildContext context,
                  AsyncSnapshot<List<Message>> snapshot) {
                if (snapshot.hasError) {
                  return const Center(child: Text('Facinf some error'));
                } else if (snapshot.hasData) {
                  final List<Message> messages = snapshot.data!;
                  return Expanded(
                    child: messages.isEmpty
                        ? SizedBox(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const <Widget>[
                                Text(
                                  'Say Salam!',
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  'and start conversation',
                                  style: TextStyle(color: Colors.grey),
                                ),
                              ],
                            ),
                          )
                        : MessageLists(messages: messages),
                  );
                } else {
                  return const ShowLoading();
                }
              },
            ),
            ChatMessageTile(chat: chat),
          ],
        ),
      ),
    );
  }
}
