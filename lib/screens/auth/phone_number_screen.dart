import 'package:flutter/material.dart';
import 'package:intl_phone_field/phone_number.dart';
import 'package:provider/provider.dart';

import '../../providers/auth_provider.dart';
import '../../widgets/custom_widgets/custom_elevated_button.dart';
import '../../widgets/custom_widgets/phone_number_field.dart';
import '../main_screen/main_screen.dart';
import 'otp_screen.dart';

class PhoneNumberScreen extends StatefulWidget {
  const PhoneNumberScreen({Key? key}) : super(key: key);
  static const String routeName = '/phone-number-screen';
  @override
  State<PhoneNumberScreen> createState() => _PhoneNumberScreenState();
}

class _PhoneNumberScreenState extends State<PhoneNumberScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.canPop(context)
                ? Navigator.of(context).pop()
                : Navigator.of(context).pushNamedAndRemoveUntil(
                    MainScreen.rotueName, (Route<dynamic> route) => false),
            child: const Text('Skip login for now'),
          ),
        ],
      ),
      body: Consumer<AuthProvider>(
          builder: (BuildContext context, AuthProvider authPro, _) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: <Widget>[
              const Text(
                'Enter your phone number',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Sellout will send an SMS message to varify your phone number, Select your Country and enter your phone number',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
              const SizedBox(height: 16),
              PhoneNumberField(
                initialCountryCode: authPro.phoneNumber?.countryCode ?? 'GB',
                bgColor: Colors.transparent,
                onChange: (PhoneNumber? value) =>
                    authPro.onPhoneNumberChange(value),
              ),
              const Spacer(),
              SizedBox(
                width: 140,
                child: CustomElevatedButton(
                  borderRadius: BorderRadius.circular(12),
                  title: 'Send'.toUpperCase(),
                  onTap: () {
                    authPro.verifyPhone(context);
                    Navigator.of(context).pushNamed(OTPScreen.routeName);
                  },
                ),
              ),
              TextButton(
                onPressed: () => Navigator.canPop(context)
                    ? Navigator.of(context).pop()
                    : Navigator.of(context).pushNamedAndRemoveUntil(
                        MainScreen.rotueName, (Route<dynamic> route) => false),
                child: const Text('Skip login for now'),
              ),
            ],
          ),
        );
      }),
    );
  }
}
