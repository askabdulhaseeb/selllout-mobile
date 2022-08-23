import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/auth_provider.dart';
import '../../widgets/custom_widgets/custom_textformfield.dart';

class OTPScreen extends StatefulWidget {
  const OTPScreen({Key? key}) : super(key: key);
  static const String routeName = '/otp-screen';

  @override
  State<OTPScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  final TextEditingController _otp = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar:
            AppBar(title: const Text('OTP Varification'), centerTitle: true),
        body: Consumer<AuthProvider>(
            builder: (BuildContext context, AuthProvider authPro, _) {
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: <Widget>[
                if (authPro.phoneNumber != null)
                  Text(
                    'Code is send to ${authPro.phoneNumber!.completeNumber}',
                    style: const TextStyle(color: Colors.grey),
                  ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Edit Number'),
                ),
                CustomTextFormField(
                  controller: _otp,
                  onChanged: (String? value) async {
                    if (value!.length == 6) {
                      await authPro.varifyOTP(value);
                    }
                  },
                  textAlign: TextAlign.center,
                  showSuffixIcon: false,
                  style: const TextStyle(letterSpacing: 20),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const Text('''Didn't received the OTP?'''),
                    TextButton(
                      child: Text(
                        'Resend OTP',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onPressed: () async => authPro.verifyPhone(context),
                    ),
                  ],
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
