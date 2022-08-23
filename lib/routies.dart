import 'package:flutter/material.dart';

import 'screens/auth/otp_screen.dart';
import 'screens/auth/phone_number_screen.dart';
import 'screens/main_screen/main_screen.dart';

final Map<String, WidgetBuilder> routes = <String, WidgetBuilder>{
  // AuthTypeScreen.routeName: (_) => const AuthTypeScreen(),
  PhoneNumberScreen.routeName: (_) => const PhoneNumberScreen(),
  OTPScreen.routeName: (_) => const OTPScreen(),
  // ForgetPasswordScreen.routeName: (_) => const ForgetPasswordScreen(),
  // RegisterScreen.routeName: (_) => const RegisterScreen(),
  MainScreen.rotueName: (_) => const MainScreen(),
  // CreateChatGroupScreen.routeName: (_) => const CreateChatGroupScreen(),
  // EditProfileScreen.routeName: (_) => const EditProfileScreen(),
  // AddMediaStoryScreen.routeName: (_) => const AddMediaStoryScreen(),
  // // Bit Screen
  // BetScreen.routeName: (_) => const BetScreen(),
  // GoLivePage.routeName: (_) => const GoLivePage(),
  // ProdFilterScreen.routeName: (_) => const ProdFilterScreen(),
  // // Notification Screen
  // NotificationScreen.routeName: (_) => const NotificationScreen(),
};
