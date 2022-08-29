import 'package:flutter/material.dart';
import '../../../functions/time_date_functions.dart';
import '../../../models/chat/chat.dart';
import '../../../screens/chat_screens/group_chat_page/group_chat_screen.dart';
import '../../custom_widgets/custom_profile_image.dart';

class GroupChatDashboardTile extends StatelessWidget {
  const GroupChatDashboardTile({required this.chat, Key? key})
      : super(key: key);
  final Chat chat;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute<GroupChatScreen>(
            builder: (_) => GroupChatScreen(chat: chat),
          ),
        );
      },
      dense: true,
      leading: CustomProfileImage(imageURL: chat.groupInfo!.imageURL),
      title: Text(
        chat.groupInfo!.name,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: Text(
        chat.lastMessage!.text ?? '',
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: Text(
        TimeDateFunctions.timeInDigits(chat.timestamp),
        style: const TextStyle(fontSize: 12),
      ),
    );
  }
}
