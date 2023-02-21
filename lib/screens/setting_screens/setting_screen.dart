import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../database/auth_methods.dart';
import '../../utilities/app_image.dart';
import '../../utilities/dimensions.dart';
import '../../widgets/custom_widgets/custom_app_bar.dart';
import '../../widgets/custom_widgets/sub_app_bar.dart';
import '../../widgets/settings/delete_account_widget.dart';
import '../auth/login_screen.dart';
import '../auth/phone_number_screen.dart';
import '../bids/bids_page.dart';
import '../notification/notification_screen.dart';
import 'contact_screen.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({Key? key}) : super(key: key);
  static const String routeName = '/setting-screen';

  Future<void> _launchUrl({String webURL = 'https://flutter.dev'}) async {
    final Uri url = Uri.parse(webURL);
    if (!await launchUrl(url)) {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(showBackButton: true,),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(Dimensions.paddingSizeDefault, Dimensions.paddingSizeDefault, Dimensions.paddingSizeDefault,0),
          child: Column(
            children: <Widget>[
              const SubAppBar(title: 'Setting'),
              _Tile(
                icon: AppImages.contactIcon,
                title: 'Contacts',
                onTap: () {
                  Navigator.of(context).pushNamed(ContactScreen.routeName);
                },
              ),


              _Tile(
                icon: AppImages.orderIcon,
                title: 'Orders and Receipts',
                onTap: () async {},
              ),

              _Tile(
                icon: AppImages.purchaseIcon,
                title: 'Purchases',
                onTap: () async {},
              ),
              _Tile(
                icon: AppImages.bidsWon,
                title: 'Bids Won',
                onTap: () async {
                  Navigator.push(context, MaterialPageRoute(builder: (_)=> BidsPage()));
                },
              ),
              _Tile(
                icon: AppImages.paymentIcon,
                title: 'Payment',
                onTap: () async {},
              ),

              _Tile(
                icon: AppImages.notificationIcon,
                title: 'Notifications',
                onTap: () async {
                  Navigator.push(context, MaterialPageRoute(builder: (_)=> NotificationPage()));
                },
              ),
              _Tile(
                icon: AppImages.orderIcon,
                title: 'Privacy Policy',
                onTap: () async {
                  await _launchUrl(
                      webURL: 'https://selll-out.firebaseapp.com/privacy');
                },
              ),
              _Tile(
                icon: AppImages.supportIcon,
                title: 'Support',
                onTap: () async {
                  await _launchUrl(
                      webURL: 'https://selll-out.firebaseapp.com/support');
                },
              ),
              _Tile(
                icon: AppImages.aboutIcon,
                title: 'About Us',
                onTap: () async {
                  await _launchUrl(webURL: 'https://selll-out.firebaseapp.com');
                },
              ),
              _Tile(
                icon: AppImages.logoutIcon,
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
                icon: AppImages.logoutIcon,
                title: 'LogIn',
                onTap: () async {
                  Navigator.push(context, MaterialPageRoute(builder: (_)=> const LoginScreen()));
                  // await AuthMethods().signOut(context);
                  // // ignore: use_build_context_synchronously
                  // Navigator.of(context).pushNamedAndRemoveUntil(
                  //   PhoneNumberScreen.routeName,
                  //   (Route<dynamic> route) => false,
                  // );
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

  final String icon;
  final String title;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15.0),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeExtraSmall),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [BoxShadow(color: Theme.of(context).hintColor.withOpacity(.3), spreadRadius: 1, blurRadius: 1, offset: Offset(0,1))]
        ),
        child: ListTile(
          dense: true,
          leading: Padding(
            padding: const EdgeInsets.symmetric(vertical : Dimensions.paddingSizeSmall),
            child: Image.asset(icon, color: Theme.of(context).iconTheme.color),
          ),
          title: Text(title),
          trailing: const Icon(
            Icons.arrow_forward_ios_sharp,
            color: Colors.grey,
            size: 18,
          ),
          onTap: onTap,
        ),
      ),
    );
  }
}
