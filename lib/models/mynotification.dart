import 'package:cloud_firestore/cloud_firestore.dart';

import '../enums/notification_enum.dart';

class MyNotification {
  MyNotification({
    required this.notificationID,
    required this.postID,
    required this.fromUID,
    required this.toUID,
    required this.type,
    required this.title,
    required this.body,
    required this.timestamp,
  });

  final String notificationID;
  final String postID;
  final String fromUID;
  final String toUID;
  final NotificationType type;
  final String title;
  final String body;
  final int timestamp;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'notification_id': notificationID,
      'post_id': postID,
      'from_uid': fromUID,
      'to_uid': toUID,
      'type': type.json,
      'title': title,
      'body': body,
      'timestamp': timestamp,
    };
  }

  // ignore: sort_constructors_first
  factory MyNotification.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    return MyNotification(
      notificationID: doc.data()?['notification_id'] ?? '',
      postID: doc.data()?['post_id'] ?? '',
      fromUID: doc.data()?['from_uid'] ?? '',
      toUID: doc.data()?['to_uid'] ?? '',
      type: NotificationTypeConvertor.toEnum(
          doc.data()?['type'] ?? NotificationType.message.json),
      title: doc.data()?['title'] ?? '',
      body: doc.data()?['body'] ?? '',
      timestamp: doc.data()?['timestamp'] ?? 0,
    );
  }
}
