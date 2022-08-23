import 'package:firebase_auth/firebase_auth.dart';
import '../widgets/custom_widgets/custom_toast.dart';
import 'user_api.dart';

class AuthMethods {
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  static User? get getCurrentUser => _auth.currentUser;
  static String get uid => _auth.currentUser?.uid ?? '';

  Future<int> verifyOTP(String verificationId, String otp) async {
    try {
      PhoneAuthCredential phoneAuthCredential = PhoneAuthProvider.credential(
          verificationId: verificationId, smsCode: otp);
      final UserCredential authCredential =
          await _auth.signInWithCredential(phoneAuthCredential);

      if (authCredential.user != null) {
        return 1;
      }
      return -1;
    } catch (ex) {
      CustomToast.errorToast(message: ex.toString());
      return -1;
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
}
