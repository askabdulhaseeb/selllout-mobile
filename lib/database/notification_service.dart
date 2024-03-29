import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/foundation.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:rxdart/rxdart.dart';

import '../models/app_user.dart';
import '../models/device_token.dart';
import '../utilities/utilities.dart';
import 'auth_methods.dart';
import 'user_api.dart';

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
          debugPrint('notification payload :${details.payload!} ');
          debugPrint('notification payload :${details.id} ');
          debugPrint('notification payload :${details.payload} ');
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
        debugPrint('Message data: ${message.data}');
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
    required List<MyDeviceToken> deviceToken,
    required String messageTitle,
    required String messageBody,
    required List<String> data,
  }) async {
    // String value3 = data.length == 2 ? '' : data[2];
    // HttpsCallable func =
    //     FirebaseFunctions.instance.httpsCallable('notifySubscribers');
    // // ignore: always_specify_types
    // final HttpsCallableResult res = await func.call(
    //   <String, dynamic>{
    //     'targetDevices': deviceToken,
    //     'messageTitle': messageTitle,
    //     'messageBody': messageBody,
    //     'value1': data[0],
    //     'value2': data[1],
    //     'value3': value3,
    //   },
    // );
    // if (res.data as bool) {
    //   return true;
    try {
      for (int i = 0; i < deviceToken.length; i++) {
        log('Receiver Devive Token: ${deviceToken[i].token}');
        final Map<String, String> headers = <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'key=${Utilities.firebaseServerID}',
        };
        final http.Request request = http.Request(
          'POST',
          Uri.parse('https://fcm.googleapis.com/fcm/send'),
        );
        request.body = json.encode(<String, dynamic>{
          'to': deviceToken[i].token,
          'priority': 'high',
          'notification': <String, String>{
            'body': messageBody,
            'title': messageTitle,
          }
        });
        request.headers.addAll(headers);
        final http.StreamedResponse response = await request.send();
        if (response.statusCode == 200) {
          if (kDebugMode) {
            debugPrint(await response.stream.bytesToString());
          }
          log('Notification send to: ${deviceToken[i].token}');
        } else {
          log('ERROR in FCM');
        }
      }
      return true;
    } catch (e) {
      log('ERROR in FCM: ${e.toString()}');
      return false;
    }
  }

  static Future<String?> getToken() async {
    FirebaseMessaging firebaseMessaging =
        FirebaseMessaging.instance; // Change here
    final String? dToken =
        await firebaseMessaging.getToken().then((String? token) {
      if (kDebugMode) {
        debugPrint('token is $token');
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

  Future<void> verifyTokenIsUnique({
    required List<AppUser> allUsersValue,
    required String deviceTokenValue,
  }) async {
    final String meUID = AuthMethods.uid;
    for (AppUser element in allUsersValue) {
      if (tokenAlreadyExist(
              devicesValue: (element.deviceToken ?? <MyDeviceToken>[]),
              tokenValue: deviceTokenValue) &&
          element.uid != meUID) {
        element.deviceToken?.removeWhere(
            (MyDeviceToken element) => element.token == deviceTokenValue);
        await UserAPI()
            .setDeviceToken(element.deviceToken ?? <MyDeviceToken>[]);
      }
    }
  }

  bool tokenAlreadyExist({
    required List<MyDeviceToken> devicesValue,
    required String tokenValue,
  }) {
    for (MyDeviceToken element in devicesValue) {
      if (element.token == tokenValue) return true;
    }
    return false;
  }
}
