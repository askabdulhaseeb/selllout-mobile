import 'dart:developer';

import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/foundation.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:rxdart/rxdart.dart';

class NotificationsServices {
  static final FlutterLocalNotificationsPlugin localNotificationPlugin =
      FlutterLocalNotificationsPlugin();
  static final BehaviorSubject<String?> onNotification =
      BehaviorSubject<String?>();
  static Future<void> init() async {
    log('NOTIFICATION INIT START');
    await Permission.notification.request();
    AndroidInitializationSettings initializationSettingsAndroid =
        const AndroidInitializationSettings('@mipmap/ic_launcher');
    DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings(
            requestAlertPermission: true,
            requestBadgePermission: true,
            requestSoundPermission: true,
            defaultPresentSound: true,
            onDidReceiveLocalNotification: (int id, String? title, String? body,
                String? payload) async {});
    InitializationSettings initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
    // await localNotificationPlugin.initialize(initializationSettings);
    await FlutterLocalNotificationsPlugin().initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse details) {
        onNotification.add(details.payload);
        if (kDebugMode) {
          print('notification payload :${details.payload!} ');
          print('notification payload :${details.id} ');
          print('notification payload :${details.payload} ');
        }
      },
    );
    await localNotificationPlugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (kDebugMode) {
        print('Message data: ${message.data}');
      }
      if (message.notification != null) {
        _notificationDetails();
        showNotification(
          title: message.notification!.title!,
          body: message.notification!.body!,
          payload:
              '${message.data['key1']}-${message.data['key2']}-${message.data['key3']}',
        );
      }
    });
    getToken();
    log('NOTIFICATION INIT DONE');
  }

  Future<bool> sendSubsceibtionNotification({
    required List<String> deviceToken,
    required String messageTitle,
    required String messageBody,
    required List<String> data,
  }) async {
    String value3 = data.length == 2 ? '' : data[2];
    HttpsCallable func =
        FirebaseFunctions.instance.httpsCallable('notifySubscribers');
    // ignore: always_specify_types
    final HttpsCallableResult res = await func.call(
      <String, dynamic>{
        'targetDevices': deviceToken,
        'messageTitle': messageTitle,
        'messageBody': messageBody,
        'value1': data[0],
        'value2': data[1],
        'value3': value3,
      },
    );
    if (res.data as bool) {
      return true;
    } else {
      return false;
    }
  }

  static Future<String?> getToken() async {
    FirebaseMessaging firebaseMessaging =
        FirebaseMessaging.instance; // Change here
    final String? dToken =
        await firebaseMessaging.getToken().then((String? token) {
      if (kDebugMode) {
        print('token is $token');
      }
      return token;
    });
    return dToken;
  }

  static NotificationDetails _notificationDetails() {
    return const NotificationDetails(
      android: AndroidNotificationDetails('channel Id', 'channel Name',
          playSound: true, importance: Importance.max),
      iOS: DarwinNotificationDetails(
        presentAlert: true,
        presentSound: true,
        presentBadge: true,
      ),
    );
  }

  static showNotification({
    required String title,
    required String body,
    required String payload,
    int id = 0,
  }) async {
    await localNotificationPlugin.show(id, title, body, _notificationDetails(),
        payload: payload);
  }

  static Future<void> cancelNotification(int id) async {
    await localNotificationPlugin.cancel(id);
  }

  static Future<void> cancelAllNotifications() async {
    await localNotificationPlugin.cancelAll();
  }
}
