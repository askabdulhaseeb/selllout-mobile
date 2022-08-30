import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../enums/chat/group_member_role_enum.dart';
import '../../../models/app_user.dart';
import '../../../models/chat/chat.dart';
import '../../../models/chat/chat_group_info.dart';
import '../../../providers/user_provider.dart';
import '../../../widgets/custom_widgets/custom_network_image.dart';
import '../../../widgets/custom_widgets/custom_profile_image.dart';
import '../../../widgets/custom_widgets/custom_textformfield.dart';
import '../../../widgets/custom_widgets/text_field_like_bg.dart';

class GroupInfoScreen extends StatelessWidget {
  const GroupInfoScreen({required this.chat, Key? key}) : super(key: key);
  final Chat chat;

  @override
  Widget build(BuildContext context) {
    final ChatGroupInfo info = chat.groupInfo!;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Group Info',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: <Widget>[
            CustomProfileImage(imageURL: info.imageURL, radius: 80),
            const SizedBox(height: 8),
            Text(
              info.name,
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 3),
            Text(
              info.members.length <= 1
                  ? 'Group - ${info.members.length} member'
                  : 'Group - ${info.members.length} members',
              style: const TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 10),
            TextFieldLikeBG(child: Text(info.description, maxLines: 5)),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.add),
                label: const Text('Add Member'),
              ),
            ),
            Expanded(
              child: TextFieldLikeBG(
                padding: const EdgeInsets.all(0),
                child: Consumer<UserProvider>(
                    builder: (BuildContext context, UserProvider userPro, _) {
                  return ListView.builder(
                      itemCount: info.members.length,
                      itemBuilder: (BuildContext context, int index) {
                        final AppUser user =
                            userPro.user(uid: info.members[index].uid);
                        return ListTile(
                          leading:
                              CustomProfileImage(imageURL: user.imageURL ?? ''),
                          title: Text(user.displayName ?? ''),
                          subtitle: Text(
                            GroupMemberRoleEnumConvertor.toJson(
                                info.members[index].role),
                          ),
                        );
                      });
                }),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
