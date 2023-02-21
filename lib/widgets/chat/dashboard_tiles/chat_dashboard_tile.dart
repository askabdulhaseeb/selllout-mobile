import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../database/auth_methods.dart';
import '../../../database/chat_api.dart';
import '../../../functions/time_date_functions.dart';
import '../../../models/app_user.dart';
import '../../../models/chat/chat.dart';
import '../../../providers/user/user_provider.dart';
import '../../../screens/chat_screens/personal_chat_page/personal_chat_screen.dart';
import '../../custom_widgets/custom_profile_image.dart';

class ChatDashboardTile extends StatelessWidget {
  const ChatDashboardTile({required this.chat, Key? key}) : super(key: key);
  final Chat chat;

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(
        builder: (BuildContext context, UserProvider userPro, _) {
      final AppUser user =
          userPro.user(uid: ChatAPI.othersUID(chat.persons)[0]);
      return ListTile(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute<PersonalChatScreen>(
              builder: (_) => PersonalChatScreen(chatWith: user, chat: chat),
            ),
          );
        },
        dense: true,
        leading: CustomProfileImage(imageURL: user.imageURL ?? ''),
        title: Text(
          user.displayName ?? 'issue',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          chat.lastMessage?.text ?? '',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: Text(
          TimeDateFunctions.timeInDigits(chat.timestamp),
          style: const TextStyle(fontSize: 12),
        ),
      );
    });
  }
}
