import 'package:flutter/material.dart';

import 'constants.dart';
import 'theme_controller.dart';
import 'screens/splash_screen.dart';

void main() {
  runApp(const RumbawaApp());
}

class RumbawaApp extends StatelessWidget {
  const RumbawaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: darkModeNotifier,
      builder: (context, isDarkMode, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Rumbawa',

          themeMode: isDarkMode
              ? ThemeMode.dark
              : ThemeMode.light,

          theme: ThemeData(
            brightness: Brightness.light,
            primaryColor: FB_PRIMARY,
            scaffoldBackgroundColor: Colors.white,
            colorScheme: ColorScheme.fromSeed(
              seedColor: FB_PRIMARY,
              brightness: Brightness.light,
            ),
            appBarTheme: const AppBarTheme(
              backgroundColor: FB_PRIMARY,
              foregroundColor: Colors.white,
            ),
          ),

          darkTheme: ThemeData(
            brightness: Brightness.dark,
            primaryColor: FB_PRIMARY,
            scaffoldBackgroundColor:
                const Color(0xFF121212),
            colorScheme: ColorScheme.fromSeed(
              seedColor: FB_PRIMARY,
              brightness: Brightness.dark,
            ),
            appBarTheme: const AppBarTheme(
              backgroundColor: FB_DARK_PRIMARY,
              foregroundColor: Colors.white,
            ),
            cardTheme: const CardThemeData(
              color: Color(0xFF1E1E1E),
            ),
          ),

          home: const SplashScreen(),
        );
      },
    );
  }
}