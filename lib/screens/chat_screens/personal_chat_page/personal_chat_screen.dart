import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import '../../../database/chat_api.dart';
import '../../../models/app_user.dart';
import '../../../models/chat/chat.dart';
import '../../../models/chat/message.dart';
import '../../../widgets/chat/chat_message_tile.dart';
import '../../../widgets/chat/message_tile.dart';
import '../../../widgets/custom_widgets/custom_profile_image.dart';
import '../../../widgets/custom_widgets/show_loading.dart';
import '../../others_profile/others_profile.dart';

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
                  return messages.isEmpty
                      ? SizedBox(
                          width: double.infinity,
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
                      : _MessageLists(messages: messages);
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

class _MessageLists extends StatefulWidget {
  const _MessageLists({
    required this.messages,
    Key? key,
  }) : super(key: key);

  final List<Message> messages;

  @override
  State<_MessageLists> createState() => _MessageListsState();
}

class _MessageListsState extends State<_MessageLists>
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
              MessageTile(message: widget.messages[index]),
        ),
      ),
    );
  }
}
