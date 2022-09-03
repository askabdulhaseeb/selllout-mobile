import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../database/auth_methods.dart';
import '../../enums/chat/message_type_enum.dart';
import '../../functions/time_date_functions.dart';
import '../../models/app_user.dart';
import '../../models/chat/chat.dart';
import '../../models/chat/message.dart';
import '../../models/chat/message_attachment.dart';
import '../../providers/user/user_provider.dart';
import '../../screens/chat_screens/message_attachment_screen.dart';
import '../../screens/user_screens/others_profile.dart';
import '../custom_widgets/custom_network_image.dart';
import '../custom_widgets/network_video_player.dart';

class MessageTile extends StatelessWidget {
  const MessageTile({required this.message, this.chat, Key? key})
      : super(key: key);
  final Message message;
  final Chat? chat;

  static const double _borderRadius = 12;
  @override
  Widget build(BuildContext context) {
    final bool isMe = message.sendBy == AuthMethods.uid;
    return message.type == MessageTypeEnum.announcement
        ? Center(
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 24),
              margin: const EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(
                color: Theme.of(context)
                    .textTheme
                    .bodyText1!
                    .color!
                    .withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                message.text ?? '- waiting for message -',
                style: TextStyle(color: Theme.of(context).primaryColor),
              ),
            ),
          )
        : Row(
            mainAxisAlignment:
                isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
            children: <Widget>[
              ClipRRect(
                borderRadius: BorderRadius.circular(_borderRadius),
                child: Container(
                  margin: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(_borderRadius),
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 1,
                        blurRadius: 6,
                        offset: const Offset(1, 1),
                      ),
                    ],
                    color: isMe
                        ? Theme.of(context).primaryColor.withOpacity(0.6)
                        : Theme.of(context).scaffoldBackgroundColor,
                  ),
                  alignment:
                      isMe ? Alignment.centerRight : Alignment.centerLeft,
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            if (message.type != MessageTypeEnum.announcement &&
                                !isMe &&
                                (chat?.isGroup ?? false) == true)
                              Consumer<UserProvider>(
                                builder: (BuildContext context,
                                    UserProvider userPro, _) {
                                  final AppUser senderInfo =
                                      userPro.user(uid: message.sendBy);
                                  return InkWell(
                                    onTap: () {
                                      Navigator.of(context).push(
                                          MaterialPageRoute<OthersProfile>(
                                        builder: (BuildContext context) =>
                                            OthersProfile(user: senderInfo),
                                      ));
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 4),
                                      child: Text(
                                        senderInfo.displayName ?? 'null',
                                        textAlign: TextAlign.left,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            if (message.attachment.isNotEmpty)
                              DisplayAttachment(
                                isMe: isMe,
                                borderRadius: _borderRadius,
                                attachments: message.attachment,
                              ),
                            if (message.text != null &&
                                message.text!.isNotEmpty)
                              ConstrainedBox(
                                constraints: BoxConstraints(
                                  maxWidth:
                                      MediaQuery.of(context).size.width * 0.70,
                                  minWidth: 100,
                                ),
                                child: Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 2),
                                  child: SelectableText(
                                    message.text ?? 'no message',
                                    textAlign: TextAlign.left,
                                    style: isMe
                                        ? const TextStyle(color: Colors.black)
                                        : null,
                                  ),
                                ),
                              ),
                          ],
                        ),
                        Text(
                          TimeDateFunctions.timeInDigits(message.timestamp),
                          style: const TextStyle(color: Colors.grey),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
  }
}

class DisplayAttachment extends StatelessWidget {
  const DisplayAttachment({
    required this.attachments,
    required double borderRadius,
    required bool isMe,
    Key? key,
  })  : _isMe = isMe,
        _borderRadius = borderRadius,
        super(key: key);

  final bool _isMe;
  final double _borderRadius;
  final List<MessageAttachment> attachments;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 150,
      width: 150,
      child: Padding(
        padding: const EdgeInsets.all(6),
        child: ClipRRect(
          borderRadius: _isMe
              ? BorderRadius.only(
                  topRight: Radius.circular(_borderRadius),
                )
              : BorderRadius.only(
                  topLeft: Radius.circular(_borderRadius),
                ),
          child: GestureDetector(
            onTap: () => Navigator.of(context)
                .push(MaterialPageRoute<MessageAttachmentScreen>(
                    builder: (BuildContext context) => MessageAttachmentScreen(
                          attachments: attachments,
                        ))),
            child: attachments.length == 1
                ? _display(attachments[0])
                : Stack(
                    children: <Widget>[
                      Positioned(
                        top: 0,
                        left: 0,
                        right: 0,
                        bottom: 16,
                        child: _display(attachments[0]),
                      ),
                      Positioned(
                        top: 16,
                        left: 16,
                        right: 0,
                        bottom: 0,
                        child: _display(attachments[1]),
                      ),
                      if (attachments.length > 2)
                        Positioned(
                          top: 0,
                          left: 0,
                          right: 0,
                          bottom: 0,
                          child: Container(
                            color: Colors.black54,
                            alignment: Alignment.center,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  '${attachments.length - 2}+',
                                  style: const TextStyle(
                                    color: Colors.white70,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 40,
                                  ),
                                ),
                                const Text(
                                  'Tap to view all',
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 11,
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }

  _display(MessageAttachment attachment) {
    return attachment.type == MessageTypeEnum.image
        ? CustomNetworkImage(
            imageURL: attachment.url,
            fit: BoxFit.cover,
          )
        : NetworkVideoPlayer(url: attachment.url, isPlay: false);
  }
}
