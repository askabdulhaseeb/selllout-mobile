import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/auth_provider.dart';
import '../../providers/provider.dart';
import '../../widgets/custom_widgets/custom_textformfield.dart';
import '../../widgets/custom_widgets/show_loading.dart';
import '../main_screen/main_screen.dart';
import 'register_screen.dart';

class OTPScreen extends StatefulWidget {
  const OTPScreen({Key? key}) : super(key: key);
  static const String routeName = '/otp-screen';

  @override
  State<OTPScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  final TextEditingController _otp = TextEditingController();
  bool _isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('OTP Varification'), centerTitle: true),
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
                // autoFocus: true,
                maxLength: 6,
                onChanged: (String? value) async {
                  if (value!.length == 6) {
                    setState(() {
                      _isLoading = true;
                    });
                    final int num = await authPro.varifyOTP(value);
                    setState(() {
                      _isLoading = false;
                    });
                    if (!mounted) return;
                    if (num == 0) {
                      Navigator.of(context).pushNamedAndRemoveUntil(
                        RegisterScreen.routeName,
                        (Route<dynamic> route) => false,
                      );
                    } else if (num == 1) {
                      Navigator.of(context).pushNamedAndRemoveUntil(
                        MainScreen.rotueName,
                        (Route<dynamic> route) => false,
                      );
                    }
                  }
                },
                textAlign: TextAlign.center,
                showSuffixIcon: false,
                style: const TextStyle(letterSpacing: 20),
              ),
              _isLoading
                  ? const ShowLoading()
                  : Row(
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
              if (_otp.text.length == 6) const ShowLoading(),
            ],
          ),
        );
      }),
    );
  }
}
