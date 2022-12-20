import 'dart:developer';

import 'package:flutter/material.dart';

import '../../database/auth_methods.dart';
import '../../database/user_api.dart';
import '../../functions/push_notification.dart';
import '../../models/app_user.dart';
import '../../models/number_details.dart';
import '../../models/reports/report_user.dart';
import '../../widgets/custom_widgets/custom_toast.dart';

class UserProvider extends ChangeNotifier {
  UserProvider() {
    init();
  }
  List<AppUser> _user = <AppUser>[];
  List<String> _deviceToken = <String>[];
  List<String> get deviceToken => _deviceToken;
  void init() async {
    if (_user.isNotEmpty) return;
    _user.addAll(await UserAPI().getAllUsers());
    //log('App_Provider.dart: No of Users: ${_user.length}');
    for (int i = 0; i < _user.length; i++) {
      for (int j = 0; j < _user[i].deviceToken!.length; j++) {
        _deviceToken.add(_user[i].deviceToken![j]);
      }
    }
    List<String> getToken =
        await PushNotification().init(devicesToken: deviceToken) ?? [];
    //print('get Token ' + getToken[0]);
   // await PushNotification().sendnotification('diSjz0qZRzOnkOrGuvhBI8:APA91bFMFQQCXA_YzvXVau2yrhel_A5QLUlk0KJ7nkgkLlv1kOl8avepjRkpinGqhDPPSKfUrLKgdO01oqwleGH9tjSAdrghbUmt8-X2GLDzEfQQjtxFHiWKVIOQmkhIptB-e531nslQ');
    //print(_deviceToken[0]);
  }

  Future<void> refresh() async {
    _user = await UserAPI().getAllUsers();
    notifyListeners();
  }

  block(AppUser user) async {
    int index = _indexOf(user.uid);
    int myIndex = _indexOf(AuthMethods.uid);
    if (index < 0 || myIndex < 0) return;
    if (_user[index].blockedBy != null ||
        (_user[index].blockedBy?.contains(AuthMethods.uid) ?? false)) {
      _user[index].blockedBy?.remove(AuthMethods.uid);
      _user[myIndex].blockTo?.remove(_user[index].uid);
      CustomToast.successToast(message: 'Unblocked');
      final AppUser by = _user[index];
      final AppUser to = _user[myIndex];
      by.blockedBy?.clear();
      to.blockTo?.clear();
      by.blockedBy?.add(AuthMethods.uid);
      to.blockTo?.add(by.uid);
      await UserAPI().unblockBy(user: by);
      await UserAPI().unblockTo(user: to);
    } else {
      log('blocking');
      _user[index].blockedBy?.add(AuthMethods.uid);
      _user[myIndex].blockTo?.add(_user[index].uid);
      CustomToast.successToast(message: 'Blocked');
      await UserAPI().blockBy(user: _user[index]);
      await UserAPI().blockTo(user: _user[myIndex]);
    }
    await refresh();
  }

  report(AppUser user, ReportUser repo) async {
    int index = _indexOf(user.uid);
    if (index < 0) return;
    _user[index].reports?.add(repo);
    notifyListeners();
    await UserAPI().report(user: _user[index]);
  }

  updateProfile(AppUser value) async {
    if (value.uid != AuthMethods.uid) return;
    int index = _indexOf(value.uid);
    if (index < 0) return;
    _user[index] = value;
    notifyListeners();
    await UserAPI().updateProfile(user: _user[index]);
  }

  List<AppUser> supporters({required String uid}) {
    List<AppUser> supporters = <AppUser>[];
    int index = _indexOf(uid);
    final AppUser tempUser = _user[index];
    if (index >= 0) {
      for (String element in tempUser.supporters!) {
        supporters.add(_user[_indexOf(element)]);
      }
    }
    return supporters;
  }

  List<AppUser> usersFromListOfString({required List<String> uidsList}) {
    List<AppUser> tempList = <AppUser>[];
    for (String element in uidsList) {
      tempList.add(_user[_indexOf(element)]);
    }
    return tempList;
  }

  List<AppUser> supportings({required String uid}) {
    List<AppUser> supporting = <AppUser>[];
    int index = _indexOf(uid);
    final AppUser tempUser = _user[index];
    if (index >= 0) {
      for (String element in tempUser.supporting!) {
        supporting.add(_user[_indexOf(element)]);
      }
    }
    return supporting;
  }

  Future<void> support({required String uid}) async {
    int index = _indexOf(uid);
    int meIndex = _indexOf(AuthMethods.uid);
    if (index < 0 || meIndex < 0) return;
    final AppUser tempUser = _user[index];
    final AppUser me = _user[meIndex];
    final bool alreadyExist = tempUser.supporters?.contains(me.uid) ?? false;
    if (alreadyExist) {
      tempUser.supporters?.remove(me.uid);
      me.supporting?.remove(tempUser.uid);
    } else {
      tempUser.supporters?.add(me.uid);
      me.supporting?.add(tempUser.uid);
    }
    _user[index] = tempUser;
    _user[meIndex] = me;
    notifyListeners();
    await UserAPI().support(user: tempUser, me: me, alreadyExist: alreadyExist);
  }

  Future<void> supportRequrest({required String uid}) async {
    int index = _indexOf(uid);
    final AppUser tempUser = _user[index];
    final String me = AuthMethods.uid;
    final bool alreadyExist = tempUser.supportRequest?.contains(me) ?? false;
    if (alreadyExist) {
      tempUser.supportRequest?.remove(me);
    } else {
      tempUser.supportRequest?.add(me);
    }
    _user[index] = tempUser;
    notifyListeners();
    await UserAPI().supportRequest(user: tempUser, alreadyExist: alreadyExist);
  }

  List<AppUser> get users => <AppUser>[..._user];

  AppUser user({required String uid}) {
    int index = _indexOf(uid);
    return index < 0 ? _null : _user[index];
  }

  AppUser? userByPhone({required String value}) {
    int index = _user.indexWhere(
        (AppUser element) => value.contains(element.phoneNumber.number));
    return index < 0 ? null : _user[index];
  }

  bool usernameExist({required String value}) {
    final int index = _user.indexWhere((AppUser element) =>
        element.username?.toLowerCase() == value.toLowerCase());
    if (index < 0) return false;
    if (_user[index].uid == AuthMethods.uid) return false;
    return true;
  }

  int _indexOf(String uid) {
    int index = _user.indexWhere((AppUser element) => element.uid == uid);
    return index;
  }

  static AppUser get _null => AppUser(
        uid: 'null',
        displayName: 'null',
        phoneNumber: NumberDetails(
          countryCode: 'null',
          number: 'null',
          completeNumber: 'null',
          isoCode: 'null',
          timestamp: 0,
        ),
      );
}
