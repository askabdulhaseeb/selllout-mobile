import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../database/auth_methods.dart';
import '../auth/phone_number_screen.dart';

class UserBlockedScreen extends StatelessWidget {
  const UserBlockedScreen({Key? key}) : super(key: key);
  static const String routeName = '/user-blocked-screen';
  Future<void> _launchUrl() async {
    final Uri url = Uri.parse('https://selll-out.web.app/#/');
    if (!await launchUrl(url)) {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              const SizedBox(height: 40),
              Text(
                'Block Access',
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              const SizedBox(height: 30),
              RichText(
                text: TextSpan(
                  style: TextStyle(
                    color: Theme.of(context).textTheme.bodyLarge!.color,
                  ),
                  children: <TextSpan>[
                    const TextSpan(
                      text: '''We've detected suspicious activity on your ''',
                    ),
                    TextSpan(
                      text: '''SellOut account ''',
                      recognizer: TapGestureRecognizer()
                        ..onTap = () => _launchUrl(),
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const TextSpan(
                      text:
                          '''and have temporarily locked it as a security precaution.''',
                    ),
                  ],
                ),
              ),
              const Text(
                '''We've detected suspicious activity on your SellOut account and have temporarily locked it as a security precaution.''',
              ),
              const SizedBox(height: 20),
              const Text('you can Contact on'),
              Text(
                'support@selllout.com',
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: <Widget>[
                  Expanded(child: Container(height: 1, color: Colors.grey)),
                  const Text('   OR   '),
                  Expanded(child: Container(height: 1, color: Colors.grey)),
                ],
              ),
              const SizedBox(height: 20),
              TextButton(
                onPressed: () async {
                  await AuthMethods().signOut(context);
                  // ignore: use_build_context_synchronously
                  Navigator.of(context).pushNamedAndRemoveUntil(
                      PhoneNumberScreen.routeName,
                      (Route<dynamic> route) => false);
                },
                child: const Text('Login With another account'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
