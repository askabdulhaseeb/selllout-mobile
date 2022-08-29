import '../../enums/chat/message_type_enum.dart';

class MessageAttachment {
  MessageAttachment({
    required this.url,
    required this.type,
  });

  final String url;
  final MessageTypeEnum type;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'url': url,
      'type': MessageTypeEnumConvertor.enumToString(type),
    };
  }

  // ignore: sort_constructors_first
  factory MessageAttachment.fromMap(Map<String, dynamic> map) {
    return MessageAttachment(
      url: map['url'] ?? '',
      type: MessageTypeEnumConvertor.toEnum(map['type']),
    );
  }
}