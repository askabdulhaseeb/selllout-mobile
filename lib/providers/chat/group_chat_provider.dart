import 'dart:io';

import 'package:flutter/material.dart';

import '../../database/auth_methods.dart';
import '../../database/chat_api.dart';
import '../../enums/chat/group_member_role_enum.dart';
import '../../enums/chat/message_type_enum.dart';
import '../../functions/picker_functions.dart';
import '../../functions/time_date_functions.dart';
import '../../functions/unique_id_functions.dart';
import '../../models/chat/chat.dart';
import '../../models/chat/chat_group_info.dart';
import '../../models/chat/chat_group_member.dart';
import '../../models/chat/message.dart';
import '../../models/chat/message_attachment.dart';
import '../../models/chat/message_read_info.dart';

class GroupChatProvider extends ChangeNotifier {
  //
  // ON CHANGE FUNCTION
  //
  onCreateGroup() async {
    if (_key.currentState!.validate()) {
      _isLoading = true;
      notifyListeners();
      final String groupID = UniqueIdFunctions.chatGroupID();
      final int time = TimeDateFunctions.timestamp;
      String url = '';
      if (_imageFile != null) {
        url = await ChatAPI()
                .uploadGroupImage(file: _imageFile!, attachmentID: groupID) ??
            '';
      }
      final ChatGroupInfo info = ChatGroupInfo(
        groupID: groupID,
        name: _name.text.trim(),
        description: _description.text.trim(),
        imageURL: url,
        createdBy: AuthMethods.uid,
        createdDate: time,
        members: _members,
      );
      await ChatAPI().sendMessage(
        Chat(
          chatID: groupID,
          persons: _persons,
          groupInfo: info,
          isGroup: true,
          timestamp: time,
          lastMessage: Message(
            messageID: time.toString(),
            text: 'New Group Created',
            type: MessageTypeEnum.announcement,
            attachment: <MessageAttachment>[],
            sendBy: AuthMethods.uid,
            sendTo: <MessageReadInfo>[],
            timestamp: time,
          ),
        ),
      );
      _reset();
      _isLoading = false;
      notifyListeners();
    }
  }

  onImagePick() async {
    final File? temp = await PickerFunctions().image();
    if (temp == null) return;
    _imageFile = temp;
    notifyListeners();
  }

  addMember(String uid) {
    _members.add(
      ChatGroupMember(
        uid: uid,
        role: GroupMemberRoleEnum.member,
        addedBy: AuthMethods.uid,
        invitationAccepted: false,
        memberSince: TimeDateFunctions.timestamp,
      ),
    );
    notifyListeners();
  }

  _reset() {
    _imageFile = null;
    _isLoading = false;
    _name.clear();
    _description.clear();
    _members.clear();
    _persons.clear();
    _persons.add(AuthMethods.uid);
    _members.add(
      ChatGroupMember(
        uid: AuthMethods.uid,
        role: GroupMemberRoleEnum.admin,
        addedBy: AuthMethods.uid,
        invitationAccepted: true,
        memberSince: 0,
      ),
    );
  }

  //
  // GETTERS
  //
  File? get imageFile => _imageFile;
  bool get isLoading => _isLoading;

  TextEditingController get name => _name;
  TextEditingController get description => _description;

  GlobalKey<FormState> get key => _key;

  List<ChatGroupMember> get members => <ChatGroupMember>[..._members];

  //
  // VARIABLES
  //
  File? _imageFile;
  bool _isLoading = false;

  final TextEditingController _name = TextEditingController();
  final TextEditingController _description = TextEditingController();

  final GlobalKey<FormState> _key = GlobalKey<FormState>();

  final List<String> _persons = <String>[AuthMethods.uid];
  final List<ChatGroupMember> _members = <ChatGroupMember>[
    ChatGroupMember(
      uid: AuthMethods.uid,
      role: GroupMemberRoleEnum.admin,
      addedBy: AuthMethods.uid,
      invitationAccepted: true,
      memberSince: 0,
    ),
  ];
}
