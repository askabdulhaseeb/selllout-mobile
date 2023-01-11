import 'dart:developer';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
// import 'package:timezone/data/latest_all.dart' as tz;
// import 'package:timezone/timezone.dart' as tz;
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

        print('notification payload :${details.payload!} ');
        // print('notification id :${details.id} ');
        print('notification payload :${details.id} ');
        print('notification payload :${details.payload} ');
        // print('notification input :${details.input} ');
        // print('notification action id :${details.actionId} ');
        // print('notification type  :${details.notificationResponseType.name} ');
        // print('notification detail :${details.toString()} ');

        // if (details.id == 1) {
        //   print('1 chala ha');
        // }
      },
      //     onSelectNotification: (String? payload) async {
      //   debugPrint('notification payload: ' + payload!);
      // }
    );

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
      print('Message data: ${message.data}');

      if (message.notification != null) {
        _notificationDetails();
        showNotification(
          title: message.notification!.title!,
          body: message.notification!.body!,
          // payload: message.data['key1'] +
          //     '-' +
          //     message.data['key2'] +
          //     '-' +
          //     message.data['key3'],
          // payload: '',
          payload:
              '${message.data['key1']}-${message.data['key2']}-${message.data['key3']}',
        );
        // print('Message also contained a notification: ${message.notification}');
      }
    });
    _getToken();
    log('NOTIFICATION INIT DONE');
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
    required String payload,
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

Future<List<String>?>? _getToken() async {
  FirebaseMessaging _firebaseMessaging =
      FirebaseMessaging.instance; // Change here
  await _firebaseMessaging.getToken().then((token) {
    print("token is $token");
  });
}
