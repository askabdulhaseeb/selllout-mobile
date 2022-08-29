import '../../enums/chat/message_type_enum.dart';
import 'message_attachment.dart';
import 'message_read_info.dart';

class Message {
  Message({
    required this.messageID,
    required this.text,
    required this.type,
    required this.attachment,
    required this.sendBy,
    required this.sendTo,
    required this.timestamp,
    this.replyOf,
  });

  final String messageID;
  final String? text;
  final MessageTypeEnum type;
  final List<MessageAttachment> attachment;
  final String sendBy;
  final List<MessageReadInfo> sendTo;
  final int timestamp;
  final Message? replyOf;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'message_id': messageID,
      'text': text,
      'type': MessageTypeEnumConvertor.toJson(type),
      'attachment': attachment.map((MessageAttachment x) => x.toMap()).toList(),
      'send_by': sendBy,
      'send_to': sendTo.map((MessageReadInfo x) => x.toMap()).toList(),
      'timestamp': timestamp,
      'reply_of': replyOf?.toMap(),
    };
  }

  // ignore: sort_constructors_first
  factory Message.fromMap(Map<String, dynamic> map) {
    return Message(
      messageID: map['message_id'] ?? '',
      text: map['text'],
      type: MessageTypeEnumConvertor.toEnum(map['type'] ?? 'text'),
      attachment: List<MessageAttachment>.from(
          // ignore: always_specify_types
          map['attachment']?.map((x) => MessageAttachment.fromMap(x))),
      sendBy: map['send_by'] ?? '',
      sendTo: List<MessageReadInfo>.from(map['send_to']?.map(
        (dynamic x) => MessageReadInfo.fromMap(x),
      )),
      timestamp: map['timestamp']?.toInt() ?? 0,
      replyOf:
          map['reply_of'] != null ? Message.fromMap(map['reply_of']) : null,
    );
  }
}
