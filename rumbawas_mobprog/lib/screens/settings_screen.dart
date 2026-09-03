import 'package:flutter/material.dart';

import '../constants.dart';
import '../theme_controller.dart';
import '../services/auth_service.dart';
import 'login_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() =>
      _SettingsScreenState();
}

class _SettingsScreenState
    extends State<SettingsScreen> {
  final AuthService _authService = AuthService();

  bool notifications = true;

  Future<void> _signOut() async {
    await _authService.logout();

    if (!mounted) return;

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (_) => const LoginScreen(),
      ),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: darkModeNotifier.value
            ? FB_DARK_PRIMARY
            : FB_PRIMARY,
        foregroundColor: Colors.white,
      ),

      body: ValueListenableBuilder<bool>(
        valueListenable: darkModeNotifier,
        builder: (
          context,
          isDarkMode,
          child,
        ) {
          return ListView(
            children: [

              SwitchListTile(
                title: const Text('Notifications'),
                subtitle: const Text(
                  'Enable notifications',
                ),
                value: notifications,
                onChanged: (value) {
                  setState(() {
                    notifications = value;
                  });
                },
              ),

              SwitchListTile(
                title: const Text('Dark Mode'),
                subtitle: const Text(
                  'Change application appearance',
                ),
                value: isDarkMode,
                onChanged: (value) {
                  darkModeNotifier.value = value;
                },
              ),

              const Divider(),

              ListTile(
                leading: const Icon(
                  Icons.logout,
                  color: Colors.red,
                ),
                title: const Text(
                  'Sign Out',
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onTap: _signOut,
              ),
            ],
          );
        },
      ),
    );
  }
}