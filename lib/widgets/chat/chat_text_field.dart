import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../database/auth_methods.dart';
import '../../database/chat_api.dart';
import '../../enums/chat/message_type_enum.dart';
import '../../functions/picker_functions.dart';
import '../../functions/time_date_functions.dart';
import '../../models/app_user.dart';
import '../../models/chat/chat.dart';
import '../../models/chat/message.dart';
import '../../models/chat/message_attachment.dart';
import '../../models/chat/message_read_info.dart';
import '../../providers/provider.dart';
import '../custom_widgets/asset_video_player.dart';

class ChatTextField extends StatefulWidget {
  const ChatTextField({
    required this.chat,
    required this.onStartRecoding,
    Key? key,
  }) : super(key: key);
  final Chat chat;
  final VoidCallback onStartRecoding;
  @override
  State<ChatTextField> createState() => _ChatTextFieldState();
}

class _ChatTextFieldState extends State<ChatTextField> {
  final TextEditingController _text = TextEditingController();
  List<File> files = <File>[];
  static const double borderRadius = 12;
  bool isLoading = false;
  MessageTypeEnum types = MessageTypeEnum.text;

  void _onListen() => setState(() {});

  @override
  void initState() {
    _text.addListener(_onListen);
    super.initState();
  }

  @override
  void dispose() {
    _text.dispose();
    _text.removeListener(_onListen);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        if (files.isNotEmpty)
          Container(
            height: 80,
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor.withOpacity(0.1),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(borderRadius),
                topRight: Radius.circular(borderRadius),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(borderRadius),
                    ),
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: files.length,
                      itemBuilder: (BuildContext context, int index) {
                        return SizedBox(
                          height: 80,
                          width: 80,
                          child: types == MessageTypeEnum.image
                              ? Image.file(files[index], fit: BoxFit.cover)
                              : AssetVideoPlayer(path: files[index].path),
                        );
                      },
                    ),
                  ),
                ),
                SizedBox(
                  width: 50,
                  height: 80,
                  child: IconButton(
                    onPressed: () {
                      setState(() {
                        files.clear();
                      });
                    },
                    splashRadius: 16,
                    icon: const Icon(Icons.cancel),
                  ),
                )
              ],
            ),
          ),
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              _TextHintButton(hint: 'Hi', chat: widget.chat),
              _TextHintButton(hint: 'ok', chat: widget.chat),
              _TextHintButton(hint: 'haha', chat: widget.chat),
              _TextHintButton(hint: 'Thanks', chat: widget.chat),
            ],
          ),
        ),
        Row(
          children: <Widget>[
            IconButton(
              onPressed: () async {
                showModalBottomSheet(
                  context: context,
                  isDismissible: true,
                  builder: (BuildContext context) => Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      ListTile(
                        leading: const Icon(Icons.camera_alt_outlined),
                        title: const Text('Camera'),
                        onTap: () async {
                          //   Navigator.of(context).pop();
                          //   types = MessageTypeEnum.image;
                          //   final XFile? _file =
                          //       await FilePickerFunctions().camera();
                          //   if (_file == null) return;
                          //   setState(() {
                          //     files.clear();
                          //     files.add(File(_file.path));
                          //   });
                        },
                      ),
                      ListTile(
                        leading: const Icon(Icons.photo_library_outlined),
                        title: const Text('Photos'),
                        onTap: () async {
                          Navigator.of(context).pop();
                          types = MessageTypeEnum.image;
                          final List<File> file =
                              await PickerFunctions().images();
                          if (file.isEmpty) return;
                          setState(() {
                            files = file;
                          });
                        },
                      ),
                      ListTile(
                        leading: const Icon(Icons.video_collection_outlined),
                        title: const Text('Videos'),
                        onTap: () async {
                          Navigator.of(context).pop();
                          types = MessageTypeEnum.video;
                          final List<File> file =
                              await PickerFunctions().videos();
                          if (file.isEmpty) return;
                          setState(() {
                            files = file;
                          });
                        },
                      ),
                    ],
                  ),
                );
              },
              splashRadius: 16,
              icon: const Icon(Icons.add),
            ),
            Flexible(
              child: TextFormField(
                controller: _text,
                textInputAction: TextInputAction.newline,
                keyboardType: TextInputType.multiline,
                maxLines: 4,
                minLines: 1,
                decoration: const InputDecoration(
                  hintText: 'Write a message...',
                  border: InputBorder.none,
                ),
              ),
            ),
            _text.text.isNotEmpty
                ? IconButton(
                    onPressed: () async {
                      if ((_text.text.trim().isEmpty && files.isEmpty) ||
                          isLoading) {
                        return;
                      }
                      setState(() {
                        isLoading = true;
                      });
                      final UserProvider userPro =
                          Provider.of<UserProvider>(context, listen: false);
                      final List<String> allUsers = widget.chat.persons;
                      final String otherUID = ChatAPI.othersUID(allUsers)[0];
                      final AppUser receiver = userPro.user(uid: otherUID);
                      final AppUser sender = userPro.user(uid: AuthMethods.uid);
                      final int time = TimeDateFunctions.timestamp;
                      List<MessageAttachment> attachments =
                          <MessageAttachment>[];
                      if (files.isNotEmpty) {
                        for (File element in files) {
                          final String? url = await ChatAPI().uploadAttachment(
                            file: element,
                            attachmentID:
                                '${time.toString()}-${TimeDateFunctions.timestamp}',
                          );
                          if (url != null) {
                            attachments.add(MessageAttachment(
                              url: url,
                              type: types,
                            ));
                          }
                        }
                      }
                      setState(() {
                        files = <File>[];
                        isLoading = false;
                      });
                      final Message msg = Message(
                        messageID: time.toString(),
                        text: _text.text.trim(),
                        type: _text.text.isNotEmpty
                            ? MessageTypeEnum.text
                            : attachments[0].type,
                        attachment: attachments,
                        sendBy: AuthMethods.uid,
                        sendTo: <MessageReadInfo>[
                          MessageReadInfo(uid: receiver.uid)
                        ],
                        timestamp: time,
                      );
                      widget.chat.timestamp = time;
                      widget.chat.lastMessage = msg;
                      _text.clear();
                      await ChatAPI().sendMessage(
                        chat: widget.chat,
                        receiver: receiver,
                        sender: sender,
                      );
                    },
                    splashRadius: 16,
                    icon: Icon(
                      Icons.send,
                      color: isLoading
                          ? Colors.grey
                          : Theme.of(context).iconTheme.color,
                    ),
                  )
                : IconButton(
                    onPressed: widget.onStartRecoding,
                    splashRadius: 1,
                    icon: const Icon(Icons.send, color: Colors.grey),
                  ),
          ],
        ),
      ],
    );
  }
}

class _TextHintButton extends StatelessWidget {
  const _TextHintButton({required this.hint, required this.chat, Key? key})
      : super(key: key);
  final String hint;
  final Chat chat;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        final int time = TimeDateFunctions.timestamp;
        final String otherUID = ChatAPI.othersUID(chat.persons)[0];
        final UserProvider userPro =
            Provider.of<UserProvider>(context, listen: false);
        final AppUser receiver = userPro.user(uid: otherUID);
        final AppUser sender = userPro.user(uid: AuthMethods.uid);
        final Message msg = Message(
          messageID: time.toString(),
          text: hint,
          type: MessageTypeEnum.text,
          attachment: <MessageAttachment>[],
          sendBy: AuthMethods.uid,
          sendTo: <MessageReadInfo>[MessageReadInfo(uid: receiver.uid)],
          timestamp: time,
        );
        chat.lastMessage = msg;
        chat.timestamp = time;
        await ChatAPI()
            .sendMessage(chat: chat, receiver: receiver, sender: sender);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          hint,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
