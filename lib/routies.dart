import 'package:flutter/material.dart';

import 'screens/auth/otp_screen.dart';
import 'screens/auth/phone_number_screen.dart';
import 'screens/auth/register_screen.dart';
import 'screens/chat_screens/group_chat_page/create_group_screen.dart';
import 'screens/main_screen/main_screen.dart';

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
};
