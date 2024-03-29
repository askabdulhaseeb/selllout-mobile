import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'database/auth_methods.dart';
import 'database/notification_service.dart';
import 'firebase_options.dart';
import 'providers/provider.dart';
import 'routies.dart';
import 'screens/auth/phone_number_screen.dart';
import 'screens/main_screen/main_screen.dart';

Future<void> _firebaseMessBackgroundHand(RemoteMessage message) async {
  RemoteNotification? notification = message.notification;
  if (notification == null) return;
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseMessaging.onBackgroundMessage(_firebaseMessBackgroundHand);
  NotificationsServices.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      // ignore: always_specify_types
      providers: [
        //
        // USER
        //
        ChangeNotifierProvider<UserProvider>(
          create: (BuildContext context) => UserProvider(),
        ),
        //
        // PRODUCT
        //
        ChangeNotifierProvider<ProdCatProvider>(
          create: (BuildContext context) => ProdCatProvider(),
        ),
        ChangeNotifierProvider<AddProductProvider>(
          create: (BuildContext context) => AddProductProvider(),
        ),
        ChangeNotifierProvider<ProductProvider>(
          create: (BuildContext context) => ProductProvider(),
        ),
        ChangeNotifierProvider<AppThemeProvider>(
          create: (BuildContext context) => AppThemeProvider(),
        ),
        ChangeNotifierProvider<AuthProvider>(
          create: (BuildContext context) => AuthProvider(),
        ),
        ChangeNotifierProvider<AppProvider>(
          create: (BuildContext context) => AppProvider(),
        ),
        // Bid
        ChangeNotifierProvider<AuctionProvider>(
          create: (BuildContext context) => AuctionProvider(),
        ),
        //
        // CHAT
        //
        ChangeNotifierProvider<ChatPageProvider>(
          create: (BuildContext context) => ChatPageProvider(),
        ),
        ChangeNotifierProvider<GroupChatProvider>(
          create: (BuildContext context) => GroupChatProvider(),
        ),
      ],
      child: Consumer2<AppThemeProvider, UserProvider>(
        builder: (BuildContext context, AppThemeProvider theme,
            UserProvider userPro, _) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Sellout',
            theme: AppThemes.light,
            darkTheme: AppThemes.dark,
            themeMode: theme.themeMode,
            home: AuthMethods.getCurrentUser == null
                ? const PhoneNumberScreen()
                : const MainScreen(),
            routes: routes,
          );
        },
      ),
    );
  }
}


  // TODO: BUGES
  // Blocked User can not able to access
  // Blocked user can not able to see the photos
  // selloutltd
  

  // Product Tile to Other Profile Screen HERO Issue
  // Product detail screen CONTACT BUTTONS
  // Product Buy Screen
  // Video issue solution
  // Live Bid time limit