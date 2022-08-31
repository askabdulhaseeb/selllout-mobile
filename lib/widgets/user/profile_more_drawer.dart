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
        Container(
          height: 6,
          width: 100,
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color:
                Theme.of(context).textTheme.bodyText1!.color!.withOpacity(0.1),
          ),
        ),
        const Padding(
          padding: EdgeInsets.all(10),
          child: Text(
            'More',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        const Divider(thickness: 0.2),
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
