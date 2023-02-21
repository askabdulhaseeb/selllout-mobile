import 'package:flutter/material.dart';

import 'screens/auth/otp_screen.dart';
import 'screens/auth/phone_number_screen.dart';
import 'screens/auth/register_screen.dart';
import 'screens/chat_screens/group_chat_page/create_group_screen.dart';
import 'screens/wallet_screen.dart';
import 'screens/live_screens/bid_page/go_live_page.dart';
import 'screens/main_screen/main_screen.dart';
import 'screens/setting_screens/contact_screen.dart';
import 'screens/user_screens/user_blocked_screeb.dart';
import 'screens/setting_screens/setting_screen.dart';

final Map<String, WidgetBuilder> routes = <String, WidgetBuilder>{
  //
  // AUTH
  PhoneNumberScreen.routeName: (_) => const PhoneNumberScreen(),
  OTPScreen.routeName: (_) => const OTPScreen(),
  RegisterScreen.routeName: (_) => const RegisterScreen(),
  //
  // MAIN SCRENN
  MainScreen.rotueName: (_) => const MainScreen(),
  CreateChatGroupScreen.routeName: (_) => const CreateChatGroupScreen(),
  //
  // BID
  GoLivePage.routeName: (_) => const GoLivePage(),
  // Settings
  SettingScreen.routeName: (_) => const SettingScreen(),
  ContactScreen.routeName: (_) => const ContactScreen(),
  //
  WalletScreen.routeName: (_) => const WalletScreen(),
  UserBlockedScreen.routeName: (_) => const UserBlockedScreen(),
};
