import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../database/auth_methods.dart';
import '../../../database/chat_api.dart';
import '../../../enums/chat/group_member_role_enum.dart';
import '../../../enums/chat/message_type_enum.dart';
import '../../../functions/time_date_functions.dart';
import '../../../models/app_user.dart';
import '../../../models/chat/chat.dart';
import '../../../models/chat/chat_group_info.dart';
import '../../../models/chat/chat_group_member.dart';
import '../../../models/chat/message.dart';
import '../../../models/chat/message_attachment.dart';
import '../../../models/chat/message_read_info.dart';
import '../../../providers/user/user_provider.dart';
import '../../../widgets/custom_widgets/custom_profile_image.dart';
import '../../../widgets/custom_widgets/text_field_like_bg.dart';
import '../../main_screen/main_screen.dart';

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
            Builder(
              builder: (BuildContext context) => Align(
                alignment: Alignment.centerRight,
                child: TextButton.icon(
                  onPressed: () {
                    final UserProvider userPro =
                        Provider.of<UserProvider>(context, listen: false);
                    List<String>? supporters =
                        userPro.user(uid: AuthMethods.uid).supporters;
                    List<String> addableSupp = <String>[];
                    List<String> selectedSupp = <String>[];
                    for (String element in supporters!) {
                      if (!chat.persons.contains(element)) {
                        addableSupp.add(element);
                      }
                    }
                    showBottomSheet(
                      context: context,
                      builder: (BuildContext context) {
                        return StatefulBuilder(builder:
                            (BuildContext context, StateSetter setState) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Column(
                              children: <Widget>[
                                if (selectedSupp.isNotEmpty)
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: <Widget>[
                                      ElevatedButton.icon(
                                        onPressed: () async {
                                          final String me = AuthMethods.uid;
                                          final int time =
                                              TimeDateFunctions.timestamp;
                                          for (String element in selectedSupp) {
                                            chat.persons.add(element);
                                            chat.groupInfo!.members.add(
                                              ChatGroupMember(
                                                uid: element,
                                                role:
                                                    GroupMemberRoleEnum.member,
                                                addedBy: me,
                                                invitationAccepted: false,
                                                memberSince: time,
                                              ),
                                            );
                                          }
                                          chat.lastMessage = Message(
                                            messageID: TimeDateFunctions
                                                .timestamp
                                                .toString(),
                                            text: selectedSupp.length == 1
                                                ? 'A new member added'
                                                : '${selectedSupp.length} new members added',
                                            type: MessageTypeEnum.announcement,
                                            attachment: <MessageAttachment>[],
                                            sendBy: me,
                                            sendTo: chat.persons
                                                .map((String e) =>
                                                    MessageReadInfo(uid: e))
                                                .toList(),
                                            timestamp: time,
                                          );
                                          await ChatAPI().addMembers(chat);
                                          Navigator.of(context)
                                              .pushNamedAndRemoveUntil(
                                                  MainScreen.rotueName,
                                                  (Route<dynamic> route) =>
                                                      false);
                                        },
                                        icon: const Icon(Icons.add),
                                        label: Text(
                                            'Add ${selectedSupp.length} members'),
                                      )
                                    ],
                                  ),
                                Expanded(
                                  child: addableSupp.isEmpty
                                      ? const Center(
                                          child: Text(
                                            'All Supports are already in group',
                                          ),
                                        )
                                      : ListView.builder(
                                          itemCount: addableSupp.length,
                                          primary: false,
                                          itemBuilder: (BuildContext context,
                                              int index) {
                                            final AppUser supUser = userPro
                                                .user(uid: addableSupp[index]);
                                            return ListTile(
                                              onTap: () {
                                                if (selectedSupp
                                                    .contains(supUser.uid)) {
                                                  setState(() => selectedSupp
                                                      .remove(supUser.uid));
                                                } else {
                                                  setState(() => selectedSupp
                                                      .add(supUser.uid));
                                                }
                                              },
                                              leading: CustomProfileImage(
                                                  imageURL:
                                                      supUser.imageURL ?? ''),
                                              title: Text(supUser.displayName ??
                                                  'null'),
                                              subtitle: Text(
                                                supUser.bio ?? '',
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              trailing: Icon(
                                                selectedSupp
                                                        .contains(supUser.uid)
                                                    ? Icons.circle
                                                    : Icons.circle_outlined,
                                                color: Theme.of(context)
                                                    .primaryColor,
                                              ),
                                            );
                                          },
                                        ),
                                ),
                              ],
                            ),
                          );
                        });
                      },
                    );
                  },
                  icon: const Icon(Icons.add),
                  label: const Text('Add Member'),
                ),
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
