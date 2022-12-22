import 'dart:developer';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
// import 'package:timezone/data/latest_all.dart' as tz;
// import 'package:timezone/timezone.dart' as tz;
import 'package:flutter/foundation.dart';

class NotificationsServices {
  static final FlutterLocalNotificationsPlugin localNotificationPlugin =
      FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
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
    await localNotificationPlugin.initialize(initializationSettings);
    // await localNotificationPlugin.initialize(
    //   initializationSettings,
    //       onSelectNotification: (String? payload) async {
    //     debugPrint('notification payload: ' + payload!);
    //   }
    // );

    // tz.initializeTimeZones();
    // final String locationName = await FlutterNativeTimezone.getLocalTimezone();
    // tz.setLocalLocation(tz.getLocation(locationName));

    await localNotificationPlugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      // print('Got a message whilst in the foreground!');
      //print('Message data: ${message.data}');

      if (message.notification != null) {
        _notificationDetails();
        showNotification(
            title: message.notification!.title!,
            body: message.notification!.body!);
        // print('Message also contained a notification: ${message.notification}');
      }
    });
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
    int id = 0,
    String? payload,
  }) async {
    await localNotificationPlugin.show(id, title, body, _notificationDetails());
  }

  static Future<void> cancelNotification(int id) async {
    await localNotificationPlugin.cancel(id);
  }

  static Future<void> cancelAllNotifications() async {
    await localNotificationPlugin.cancelAll();
  }
}
