import 'package:flutter/material.dart';

import '../../database/auth_methods.dart';
import '../../widgets/settings/delete_account_widget.dart';
import '../auth/phone_number_screen.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({Key? key}) : super(key: key);
  static const String routeName = '/setting-screen';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: <Widget>[
              _Tile(
                icon: Icons.contacts_rounded,
                title: 'Contacts',
                onTap: () async {},
              ),
              _Tile(
                icon: Icons.shop,
                title: 'Orders and Receipts',
                onTap: () async {},
              ),
              _Tile(
                icon: Icons.privacy_tip,
                title: 'Privacy Policy',
                onTap: () async {},
              ),
              _Tile(
                icon: Icons.contact_support_rounded,
                title: 'Support',
                onTap: () async {},
              ),
              _Tile(
                icon: Icons.e_mobiledata_rounded,
                title: 'About Us',
                onTap: () async {},
              ),
              _Tile(
                icon: Icons.delete_sweep_sharp,
                title: 'Delete Account',
                onTap: () async {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) => const Dialog(
                      child: DeleteAccountWidget(),
                    ),
                  );
                },
              ),
              _Tile(
                icon: Icons.logout,
                title: 'Log Out',
                onTap: () async {
                  await AuthMethods().signOut();
                  // ignore: use_build_context_synchronously
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    PhoneNumberScreen.routeName,
                    (Route<dynamic> route) => false,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Tile extends StatelessWidget {
  const _Tile({
    required this.icon,
    required this.title,
    required this.onTap,
    Key? key,
  }) : super(key: key);

  final IconData icon;
  final String title;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        dense: true,
        leading: Icon(icon, color: Theme.of(context).iconTheme.color),
        title: Text(title),
        trailing: const Icon(
          Icons.arrow_forward_ios_sharp,
          color: Colors.grey,
          size: 18,
        ),
        onTap: onTap,
      ),
    );
  }
}
