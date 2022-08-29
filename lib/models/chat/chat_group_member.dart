import '../../enums/chat/group_member_role_enum.dart';

class ChatGroupMember {
  ChatGroupMember({
    required this.uid,
    required this.role,
    required this.addedBy,
    required this.invitationAccepted,
    required this.memberSince,
  });

  final String uid;
  final GroupMemberRoleEnum role;
  final String addedBy;
  final bool invitationAccepted;
  final int memberSince;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uid': uid,
      'role': GroupMemberRoleEnumConvertor.toJson(role),
      'added_by': addedBy,
      'invitation_accepted': invitationAccepted,
      'member_since': memberSince,
    };
  }

  // ignore: sort_constructors_first
  factory ChatGroupMember.fromMap(Map<String, dynamic> map) {
    return ChatGroupMember(
      uid: map['uid'] ?? '',
      role: GroupMemberRoleEnumConvertor.fromMap(map['role']),
      addedBy: map['added_by'] ?? '',
      invitationAccepted: map['invitation_accepted'] ?? false,
      memberSince: int.parse(map['member_since']?.toString() ?? '0'),
    );
  }
}
