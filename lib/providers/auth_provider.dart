import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_field/phone_number.dart';

import '../database/auth_methods.dart';

class AuthProvider extends ChangeNotifier {
  PhoneNumber? _phoneNumber;
  String? _verificationId;
  String? _smsOTP;

  PhoneNumber? get phoneNumber => _phoneNumber;

  onPhoneNumberChange(PhoneNumber? value) {
    _phoneNumber = value;
    notifyListeners();
  }

  Future<void> verifyPhone(BuildContext context) async {
    if (_phoneNumber == null) return;
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: _phoneNumber!.completeNumber,
      verificationCompleted: (PhoneAuthCredential phoneAuthCredential) async {
        _smsOTP = phoneAuthCredential.smsCode;
        _verificationId = phoneAuthCredential.verificationId;
      },
      verificationFailed: (FirebaseAuthException verificationFailed) async {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(verificationFailed.message!)));
      },
      codeSent: (String verificationId, int? resendingToken) async {
        _verificationId = verificationId;
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
    notifyListeners();
  }

  varifyOTP(String otp) async {
    if (_verificationId == null) return;
    final int num = await AuthMethods().verifyOTP(_verificationId!, otp);
    log(num.toString());
  }
}
