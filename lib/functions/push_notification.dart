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
    required List<String> data,
  }) async {
    String value3 = data.length == 2 ? '' : data[2];
    HttpsCallable func =
        FirebaseFunctions.instance.httpsCallable('notifySubscribers');
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
    print(res.data);
    if (res.data as bool) {
      return true;
    } else {
      return false;
    }
  }

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

  handleNotification(BuildContext context) async {
    print('es main war giya ha');
    RemoteMessage? message =
        await FirebaseMessaging.instance.getInitialMessage();
    if (message != null) _handleNotificationData(message.data, context);
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('ya message listen chala ha');
      print('message ' + message.data['Key1']);
      _handleNotificationData(message.data, context);
    });
  }

  _handleNotificationData(
      Map<String, dynamic> data, BuildContext context) async {
    print('it is clicked');
    print('Key 1 is : ' + data['key1']);
    if (data['key1'] == 'newpost') {}
    // if(data['key1'])
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
