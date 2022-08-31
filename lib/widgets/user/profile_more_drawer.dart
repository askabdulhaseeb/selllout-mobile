import 'package:flutter/material.dart';

import '../../database/auth_methods.dart';
import '../../screens/auth/phone_number_screen.dart';

class ProfileMoreDrawer extends StatelessWidget {
  const ProfileMoreDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        ListTile(
          onTap: () {},
          leading: const Icon(Icons.settings),
          title: const Text('Settings'),
        ),
        ListTile(
          onTap: () async {
            await AuthMethods().signOut();
            // ignore: use_build_context_synchronously
            Navigator.of(context).pushNamedAndRemoveUntil(
                PhoneNumberScreen.routeName, (Route<dynamic> route) => false);
          },
          leading: const Icon(Icons.logout),
          title: const Text('Logout'),
        ),
      ],
    );
  }
}
