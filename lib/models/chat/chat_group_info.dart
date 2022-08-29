import 'chat_group_member.dart';

class ChatGroupInfo {
  ChatGroupInfo({
    required this.groupID,
    required this.name,
    required this.description,
    required this.imageURL,
    required this.createdBy,
    required this.createdDate,
    required this.members,
  });
  final String groupID;
  final String name;
  final String description;
  final String imageURL;
  final String createdBy;
  final int createdDate;
  final List<ChatGroupMember> members;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'group_id': groupID,
      'name': name,
      'description': description,
      'image_url': imageURL,
      'created_by': createdBy,
      'created_date': createdDate,
      'members': members.map((ChatGroupMember x) => x.toMap()).toList(),
    };
  }

  // ignore: sort_constructors_first
  factory ChatGroupInfo.fromMap(Map<String, dynamic> map) {
    return ChatGroupInfo(
      groupID: map['group_id'] ?? '',
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      imageURL: map['image_url'] ?? '',
      createdBy: map['created_by'] ?? '',
      createdDate: int.parse(map['created_date']?.toString() ?? '0'),
      members: List<ChatGroupMember>.from(map['members']?.map(
        (dynamic x) => ChatGroupMember.fromMap(x),
      )),
    );
  }
}
