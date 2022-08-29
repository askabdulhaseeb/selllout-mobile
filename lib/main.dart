import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'database/auth_methods.dart';
import 'firebase_options.dart';
import 'providers/app_provider.dart';
import 'providers/app_theme.dart';
import 'providers/auth_provider.dart';
import 'providers/chat/chat_page_provider.dart';
import 'providers/product/app_product_provider.dart';
import 'providers/product/product_category_provider.dart';
import 'providers/product/product_provider.dart';
import 'providers/user_provider.dart';
import 'routies.dart';
import 'screens/auth/phone_number_screen.dart';
import 'screens/main_screen/main_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      // ignore: always_specify_types
      providers: [
        ChangeNotifierProvider<AppThemeProvider>(
          create: (BuildContext context) => AppThemeProvider(),
        ),
        ChangeNotifierProvider<AuthProvider>(
          create: (BuildContext context) => AuthProvider(),
        ),
        ChangeNotifierProvider<AppProvider>(
          create: (BuildContext context) => AppProvider(),
        ),
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
        //
        // CHAT
        //
        ChangeNotifierProvider<ChatPageProvider>(
          create: (BuildContext context) => ChatPageProvider(),
        ),
      ],
      child: Consumer<AppThemeProvider>(
        builder: (BuildContext context, AppThemeProvider theme, _) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Selllout',
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
  // Product Tile to Other Profile Screen HERO Issue
  // TODO:  Dependencies need to add
  // Dropdown version update

// Platform  Firebase App Id
// android   1:278140333975:android:32494f3707d3caebc15ed2
// ios       1:278140333975:ios:ab0854391d0cd79fc15ed2