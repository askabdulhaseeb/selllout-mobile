import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_field/phone_number.dart';

import '../database/auth_methods.dart';
import '../database/user_api.dart';
import '../functions/picker_functions.dart';
import '../functions/time_date_functions.dart';
import '../models/app_user.dart';
import '../models/number_details.dart';
import '../screens/auth/phone_number_screen.dart';
import '../screens/main_screen/main_screen.dart';
import '../widgets/custom_widgets/custom_toast.dart';

class AuthProvider extends ChangeNotifier {
  //
  // REGISTER FUNCTIONS
  //
  Future<void> onRegister(BuildContext context) async {
    if (_phoneNumber == null || AuthMethods.getCurrentUser == null) {
      CustomToast.errorToast(message: 'Enter Phone Number again');
      Navigator.of(context).pushNamedAndRemoveUntil(
        PhoneNumberScreen.routeName,
        (Route<dynamic> route) => false,
      );
    } else if (_registerKey.currentState!.validate()) {
      String? url = '';
      _isRegsiterScreenLoading = true;
      notifyListeners();
      if (_profilePhoto != null) {
        url = await UserAPI().uploadProfilePhoto(file: _profilePhoto!);
      }
      final AppUser appuser = AppUser(
        uid: AuthMethods.uid,
        displayName: _name.text.trim(),
        bio: _bio.text.trim(),
        imageURL: url ?? '',
        isPublicProfile: _isPublicProfile,
        phoneNumber: NumberDetails(
          countryCode: _phoneNumber!.countryCode,
          number: _phoneNumber!.number,
          completeNumber: _phoneNumber!.completeNumber,
          isoCode: _phoneNumber!.countryISOCode,
          timestamp: TimeDateFunctions.timestamp,
        ),
      );

      final bool added = await UserAPI().register(user: appuser);
      _isRegsiterScreenLoading = false;
      notifyListeners();
      if (added) {
        // ignore: use_build_context_synchronously
        Navigator.of(context).pushNamedAndRemoveUntil(
            MainScreen.rotueName, (Route<dynamic> route) => false);
      }
    }
  }

  void pickProfilePhoto() async {
    File? temp = await PickerFunctions().image();
    if (temp == null) return;
    _profilePhoto = temp;
    notifyListeners();
  }

  onvisibilityUpdate(bool value) {
    _isPublicProfile = value;
    notifyListeners();
  }

  onUpdateRegisterLoading(bool value) {
    _isRegsiterScreenLoading = value;
    notifyListeners();
  }

  //
  // OTP FUNCTIONS
  //
  onPhoneNumberChange(PhoneNumber? value) {
    _phoneNumber = value;
    notifyListeners();
  }

  Future<void> verifyPhone(BuildContext context) async {
    if (_phoneNumber == null) return;
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: _phoneNumber!.completeNumber,
      verificationCompleted: (PhoneAuthCredential phoneAuthCredential) async {
        // _smsOTP = phoneAuthCredential.smsCode;
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

  Future<int> varifyOTP(String otp) async {
    if (_verificationId == null) return 0;
    final int num = await AuthMethods().verifyOTP(_verificationId!, otp);
    return num;
  }

  //
  // VARIABLES
  PhoneNumber? _phoneNumber;
  String? _verificationId;
  // String? _smsOTP;
  final GlobalKey<FormState> _registerKey = GlobalKey<FormState>();

  final TextEditingController _name = TextEditingController();
  final TextEditingController _username = TextEditingController();
  final TextEditingController _bio = TextEditingController();

  bool _isPublicProfile = true;
  bool _isRegsiterScreenLoading = false;
  File? _profilePhoto;

  TextEditingController get name => _name;
  TextEditingController get username => _username;
  TextEditingController get bio => _bio;

  GlobalKey<FormState> get registerKey => _registerKey;

  PhoneNumber? get phoneNumber => _phoneNumber;

  bool get isPublicProfile => _isPublicProfile;
  bool get isRegsiterScreenLoadingn => _isRegsiterScreenLoading;

  File? get profilePhoto => _profilePhoto;
}
