import 'dart:convert';
import 'dart:developer';

import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

//import '../database/app_user/user_api.dart';
import '../database/user_api.dart';
import '../models/app_user.dart';
import '../providers/user/user_provider.dart';
import '../widgets/custom_widgets/custom_toast.dart';
import 'package:http/http.dart' as http;

class PushNotification {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  static final PushNotification instance = PushNotification();

  String? _token;
  String? get token => _token;

  Future<List<String>?>? init({required List<String> devicesToken}) async {
    final NotificationSettings? settings = await _requestPermission();
    //print(settings?.authorizationStatus);
    if (settings!.authorizationStatus == AuthorizationStatus.authorized) {
      // print('Permission mil gie ay ');
    }

    if (settings != null &&
        (settings.authorizationStatus == AuthorizationStatus.provisional ||
            settings.authorizationStatus == AuthorizationStatus.authorized)) {
      List<String>? updatedDevicesToken = await _getToken(devicesToken);
      if (updatedDevicesToken != null && updatedDevicesToken.isNotEmpty) {
        return updatedDevicesToken;
      }
    } else {
      CustomToast.errorToast(
          message: 'Permissions are neccessary for notifications');
    }
    return null;
  }

  Future<List<String>?>? _getToken(List<String> devicesToken) async {
    _token = await _firebaseMessaging.getToken();
    if (_token == null) {
      log('Token is null');
      CustomToast.errorToast(message: 'Unable to fetch Data, Tryagain Later');
      return null;
    }
    //log('Token is ${token}');
    if (devicesToken.contains(_token)) return null;
    devicesToken.add(_token!);
    UserAPI().setDeviceToken(devicesToken);
    return devicesToken;
  }

  Future<bool> sendNotification({
    required List<String> deviceToken,
    required String messageTitle,
    required String messageBody,
  }) async {
  
    HttpsCallable func =
        FirebaseFunctions.instance.httpsCallable('notifySubscribers');
    final HttpsCallableResult res = await func.call(
      <String, dynamic>{
        'targetDevices': deviceToken,
        'messageTitle': messageTitle,
        'messageBody': messageBody,
        
      },
    );
    print(res.data);
    if (res.data as bool) {
      return true;
    } else {
      return false;
    }
  }

  // handleNotification(BuildContext context) async {
  //   RemoteMessage? message =
  //       await FirebaseMessaging.instance.getInitialMessage();
  //   if (message != null) _handleNotificationData(message.data, context);
  //   FirebaseMessaging.onMessageOpenedApp.listen((message) {
  //     _handleNotificationData(message.data, context);
  //   });
  // }

  Future<NotificationSettings?> _requestPermission() async {
    try {
      NotificationSettings notificationSettings =
          await _firebaseMessaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        announcement: false,
      );

      return notificationSettings;
    } catch (e) {
      CustomToast.errorToast(
          message: 'Permissions are necessary to show notifications');
    }
    return null;
  }

  static const Map<String, String> _headers = {
    'Content-Type': 'application/json',
    'Authorization':
        'key=AAAAQMJ0r5c:APA91bH5D1WnjJYGwk3GMTVy7or-Wh3N5QQRYqhIoDnQEMBJ5EyiMU_qTcR-cFfTllm518sUZ__IePwsEmC5UZOeXo9WzznjlNLKhfv8kNPt4YG0HJ_1DY1Nq6xYlGzNScdsn3hoTW5h'
  };
  Future<void> sendnotification(String token) async {
    Uri url = Uri.parse('https://fcm.googleapis.com/fcm/send');
    dynamic bodydata = jsonEncode(<String, dynamic>{
      'data': {
        'title': 'New Text Message',
        'image': 'https://firebase.google.com/images/social.png',
        'message': 'Hello how are you?'
      },
      'to': token
    });
    //print('Url = $url');
    try {
      final http.Response response =
          await http.post(url, headers: _headers, body: bodydata);
      if (response.statusCode == 200) {
        try {
          // If server returns an OK response, parse the JSON.
          //print('ok chal ha');
          dynamic a = response.body.runtimeType;
        } catch (e) {
          return;
        }
      } else {
        return;
      }
    } catch (e) {
      return;
    }
  }
 handleNotification(BuildContext context) async {
    RemoteMessage? message =
        await FirebaseMessaging.instance.getInitialMessage();
    if (message != null) _handleNotificationData(message.data, context);
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      _handleNotificationData(message.data, context);
    });
  }

  _handleNotificationData(
      Map<String, dynamic> data, BuildContext context) async {
    // print('it is clicked');
    // switch (data['key1']) {
    //   case 'follow_request':
    //     String uid = data['key2'];
    //     AppUser? user = await UserApi().user(uid: uid);
    //     if (user == null) break;
    //     AppUser? me = await UserApi().user(uid: AuthMethods.uid);
    //     Provider.of<UserProvider>(context, listen: false).refresh();
    //     print('running till now');
    //     // Navigator.push(context,
    //     //     MaterialPageRoute(builder: (_) => OthersProfileScreen(user: user)));
    //     break;
    //   case 'new_post':
    //     String postPid = data['key2'];
    //     SalamSocialPost? post = await SalamSocialAPI().getSpecificPost(postPid);
    //     if (post == null) break;
    //     Navigator.push(context,
    //         MaterialPageRoute(builder: (_) => PostFullScreenView(post: post)));
    //     break;
    //   case 'post_comment':
    //     String postPid = data['key2'];
    //     String commentCid = data['key3'];
    //     SalamSocialPost? post = await SalamSocialAPI().getSpecificPost(postPid);
    //     Provider.of<SalamSocialProvider>(context, listen: false)
    //         .setPushNotificationVar(cid: commentCid);
    //     if (post == null) break;
    //     print('all good');
    //     Navigator.push(
    //       context,
    //       MaterialPageRoute(
    //         builder: (_) => PostFullScreenView(
    //           post: post,
    //         ),
    //       ),
    //     );
    //     break;
    //   case 'post_reaction':
    //     String postPid = data['key2'];
    //     SalamSocialPost? post = await SalamSocialAPI().getSpecificPost(postPid);
    //     if (post == null) break;
    //     Navigator.push(
    //       context,
    //       MaterialPageRoute(
    //         builder: (_) => PostFullScreenView(
    //           post: post,
    //           openReactionSreen: true,
    //         ),
    //       ),
    //     );
    // }
  }
}
