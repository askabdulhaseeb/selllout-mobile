import '../../functions/time_date_functions.dart';

class MessageReadInfo {
  MessageReadInfo({
    required this.uid,
    this.delivered = true,
    this.seen = true,
    this.deliveryAt,
    this.seenAt,
  });

  final String uid;
  final bool delivered;
  final bool seen;
  final int? deliveryAt;
  final int? seenAt;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uid': uid,
      'delivered': delivered,
      'seen': seen,
      'seen_at': seenAt ?? TimeDateFunctions.timestamp,
      'delivery_at': deliveryAt ?? TimeDateFunctions.timestamp,
    };
  }

  // ignore: sort_constructors_first
  factory MessageReadInfo.fromMap(Map<String, dynamic> map) {
    return MessageReadInfo(
      uid: map['uid'] ?? '',
      delivered: map['delivered'] ?? false,
      seen: map['seen'] ?? false,
      deliveryAt: map['delivery_at'],
      seenAt: map['seen_at'],
    );
  }
}
