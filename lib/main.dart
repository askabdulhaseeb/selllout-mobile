import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';
import 'providers/app_provider.dart';
import 'providers/app_theme.dart';
import 'routies.dart';
import 'screens/auth/login_screen.dart';

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
        ChangeNotifierProvider<AppProvider>(
          create: (BuildContext context) => AppProvider(),
        ),
        ChangeNotifierProvider<AppThemeProvider>(
          create: (BuildContext context) => AppThemeProvider(),
        ),
      ],
      child: Consumer<AppThemeProvider>(
        builder: (BuildContext context, AppThemeProvider theme,_) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Selllout',
            theme: AppThemes.light,
            darkTheme: AppThemes.dark,
            themeMode: theme.themeMode,
            home: const LoginScreen(),
            routes: routes,
          );
        }
      ),
    );
  }
}

// Platform  Firebase App Id
// android   1:278140333975:android:32494f3707d3caebc15ed2
// ios       1:278140333975:ios:ab0854391d0cd79fc15ed2