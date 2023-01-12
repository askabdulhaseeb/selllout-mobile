import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../models/app_user.dart';
import '../widgets/custom_widgets/custom_toast.dart';
import 'auth_methods.dart';
import 'notification_service.dart';

class UserAPI {
  static const String _collection = 'users';
  static final FirebaseFirestore _instance = FirebaseFirestore.instance;
  // functions
  Future<void> updateProfile({required AppUser user}) async {
    if (user.uid != AuthMethods.uid) return;
    try {
      await _instance
          .collection(_collection)
          .doc(user.uid)
          .update(user.updateProfile());
    } catch (e) {
      CustomToast.errorToast(message: e.toString());
    }
  }

  Future<void> setDeviceToken(List<String> deviceToken) async {
    try {
      await _instance
          .collection(_collection)
          .doc(AuthMethods.uid)
          .update(<String, dynamic>{'devices_token': deviceToken});
    } catch (e) {
      CustomToast.errorToast(message: 'Something Went Wrong');
    }
  }

  Future<void> supportRequest({
    required AppUser user,
    required AppUser supporter,
    required bool alreadyExist,
  }) async {
    if (user.uid == AuthMethods.uid) return;
    try {
      await _instance
          .collection(_collection)
          .doc(user.uid)
          .update(user.updateSupportRequest(alreadyExist: alreadyExist));
      if (!alreadyExist && (supporter.deviceToken?.isNotEmpty ?? false)) {
        await NotificationsServices().sendSubsceibtionNotification(
          deviceToken: supporter.deviceToken ?? <String>[],
          messageTitle: user.displayName ?? 'App User',
          messageBody: '${user.displayName} want to start supporting you',
          data: <String>['support', 'public', user.uid],
        );
      }
    } catch (e) {
      CustomToast.errorToast(message: e.toString());
    }
  }

  Future<void> support({
    required AppUser user,
    required AppUser me,
    required bool alreadyExist,
  }) async {
    try {
      await _instance.collection(_collection).doc(user.uid).update(
          user.updateSupporter(alreadyExist: alreadyExist, uid: me.uid));
      await _instance.collection(_collection).doc(me.uid).update(
          me.updateSupporting(alreadyExist: alreadyExist, uid: user.uid));
      if (!alreadyExist && (user.deviceToken?.isNotEmpty ?? false)) {
        await NotificationsServices().sendSubsceibtionNotification(
          deviceToken: user.deviceToken ?? <String>[],
          messageTitle: me.displayName ?? 'App User',
          messageBody: '${me.displayName} start supporting you',
          data: <String>['support', 'public', me.uid],
        );
      }
    } catch (e) {
      CustomToast.errorToast(message: e.toString());
    }
  }

  Future<void> unblockTo({required AppUser user}) async {
    try {
      await _instance
          .collection(_collection)
          .doc(user.uid)
          .update(user.unblockTO());
    } catch (e) {
      CustomToast.errorToast(message: e.toString());
    }
  }

  Future<void> unblockBy({required AppUser user}) async {
    try {
      await _instance
          .collection(_collection)
          .doc(user.uid)
          .update(user.unblockBy());
    } catch (e) {
      CustomToast.errorToast(message: e.toString());
    }
  }

  Future<void> blockTo({required AppUser user}) async {
    try {
      await _instance
          .collection(_collection)
          .doc(user.uid)
          .update(user.blockToUpdate());
    } catch (e) {
      CustomToast.errorToast(message: e.toString());
    }
  }

  Future<void> blockBy({required AppUser user}) async {
    try {
      await _instance
          .collection(_collection)
          .doc(user.uid)
          .update(user.blockByUpdate());
    } catch (e) {
      CustomToast.errorToast(message: e.toString());
    }
  }

  Future<void> report({required AppUser user}) async {
    try {
      await _instance
          .collection(_collection)
          .doc(user.uid)
          .update(user.report());
    } catch (e) {
      CustomToast.errorToast(message: e.toString());
    }
  }

  Future<bool> register({required AppUser user}) async {
    try {
      await _instance.collection(_collection).doc(user.uid).set(user.toMap());
      return true;
    } catch (e) {
      CustomToast.errorToast(message: e.toString());
      return false;
    }
  }

  Future<AppUser?> user({required String uid}) async {
    final DocumentSnapshot<Map<String, dynamic>> doc =
        await _instance.collection(_collection).doc(uid).get();
    if (!doc.exists) return null;
    final AppUser appUser = AppUser.fromDoc(doc);
    return appUser;
  }

  Future<List<AppUser>> getAllUsers() async {
    final List<AppUser> appUser = <AppUser>[];
    final QuerySnapshot<Map<String, dynamic>> doc =
        await _instance.collection(_collection).get();

    for (DocumentSnapshot<Map<String, dynamic>> element in doc.docs) {
      appUser.add(AppUser.fromDoc(element));
    }
    return appUser;
  }

  Future<String?> uploadProfilePhoto({required File file}) async {
    try {
      TaskSnapshot snapshot = await FirebaseStorage.instance
          .ref('profile_photos/${AuthMethods.uid}')
          .putFile(file);
      String url = await snapshot.ref.getDownloadURL();
      return url;
    } catch (e) {
      return null;
    }
  }
}
