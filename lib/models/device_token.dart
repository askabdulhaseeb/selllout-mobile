// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../functions/time_date_functions.dart';

class MyDeviceToken {
  MyDeviceToken({
    required this.token,
    this.failNotificationByUID,
    this.registerTimestamp,
  });

  final String token;
  final List<String>? failNotificationByUID;
  final int? registerTimestamp;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'token': token,
      'fail_notification_by_uid': failNotificationByUID ?? <String>[],
      'register_timestamp': registerTimestamp ?? TimeDateFunctions.timestamp,
    };
  }

  factory MyDeviceToken.fromMap(Map<String, dynamic> map) {
    return MyDeviceToken(
      token: map['token'] ?? '',
      failNotificationByUID: map['fail_notification_by_uid'] != null
          ? List<String>.from((map['fail_notification_by_uid'])?? <String>[])
          : <String>[],
      registerTimestamp: map['register_timestamp'] as int,
    );
  }
}
