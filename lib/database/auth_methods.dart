import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/app_user.dart';
import '../models/device_token.dart';
import '../providers/provider.dart';
import '../widgets/custom_widgets/custom_toast.dart';
import 'notification_service.dart';
import 'user_api.dart';

class AuthMethods {
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  static User? get getCurrentUser => _auth.currentUser;
  static String get uid => _auth.currentUser?.uid ?? '';
  static String get phoneNumber => _auth.currentUser?.phoneNumber ?? '';

  Future<int> verifyOTP(String verificationId, String otp) async {
    try {
      PhoneAuthCredential phoneAuthCredential = PhoneAuthProvider.credential(
          verificationId: verificationId, smsCode: otp);
      final UserCredential authCredential =
          await _auth.signInWithCredential(phoneAuthCredential);

      if (authCredential.user != null) {
        final AppUser? appUser =
            await UserAPI().user(uid: authCredential.user!.uid);
        if (appUser == null) return 0; // User is New on App
        return 1; // User Already Exist NO new info needed
      }
      return -1; // ERROR while Entering OTP
    } catch (ex) {
      CustomToast.errorToast(message: ex.toString());
      return -1;
    }
  }

  Future<void> deleteAccount() async {
    await FirebaseFirestore.instance.collection('users').doc(uid).delete();
    final QuerySnapshot<Map<String, dynamic>> products = await FirebaseFirestore
        .instance
        .collection('products')
        .where('uid', isEqualTo: uid)
        .get();
    if (products.docs.isNotEmpty) {
      for (DocumentSnapshot<Map<String, dynamic>> doc in products.docs) {
        await FirebaseFirestore.instance
            .collection('products')
            .doc(doc.data()?['pid'])
            .delete();
      }
      await FirebaseStorage.instance.ref('products/$uid').delete();
    }
    await _auth.currentUser!.delete();
  }

  Future<void> signOut(BuildContext context) async {
    final AppUser me = Provider.of<UserProvider>(context, listen: false)
        .user(uid: AuthMethods.uid);
    final String? token = await NotificationsServices.getToken();
    me.deviceToken!.remove(token ?? '');
    await UserAPI().setDeviceToken(me.deviceToken ?? <MyDeviceToken>[]);
    await _auth.signOut();
  }
}
