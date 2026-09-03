// lib/services/auth_service.dart

import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../constants.dart';

class AuthService {
  Future<bool> login(
    String username,
    String password,
  ) async {
    final response = await http.post(
      Uri.parse('$API_URL/auth/login'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'username': username,
        'password': password,
        'expiresInMins': 30,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      final prefs =
          await SharedPreferences.getInstance();

      await prefs.setBool(
        'isLoggedIn',
        true,
      );

      // Save User ID
      if (data['id'] != null) {
        await prefs.setInt(
          'userId',
          (data['id'] as num).toInt(),
        );
      }

      // Save Username
      await prefs.setString(
        'username',
        data['username']?.toString() ?? username,
      );

      // Save First Name
      await prefs.setString(
        'firstName',
        data['firstName']?.toString() ?? '',
      );

      // Save Last Name
      await prefs.setString(
        'lastName',
        data['lastName']?.toString() ?? '',
      );

      // Save Full Name
      final firstName =
          data['firstName']?.toString() ?? '';

      final lastName =
          data['lastName']?.toString() ?? '';

      final fullName =
          '$firstName $lastName'.trim();

      await prefs.setString(
        'fullName',
        fullName,
      );

      // Save Access Token
      if (data['accessToken'] != null) {
        await prefs.setString(
          'accessToken',
          data['accessToken'].toString(),
        );
      }

      // Save Refresh Token
      if (data['refreshToken'] != null) {
        await prefs.setString(
          'refreshToken',
          data['refreshToken'].toString(),
        );
      }

      return true;
    }

    return false;
  }

  Future<bool> isLoggedIn() async {
    final prefs =
        await SharedPreferences.getInstance();

    return prefs.getBool('isLoggedIn') ?? false;
  }

  Future<int?> getUserId() async {
    final prefs =
        await SharedPreferences.getInstance();

    return prefs.getInt('userId');
  }

  Future<String?> getUsername() async {
    final prefs =
        await SharedPreferences.getInstance();

    return prefs.getString('username');
  }

  Future<String?> getFirstName() async {
    final prefs =
        await SharedPreferences.getInstance();

    return prefs.getString('firstName');
  }

  Future<String?> getLastName() async {
    final prefs =
        await SharedPreferences.getInstance();

    return prefs.getString('lastName');
  }

  Future<String?> getFullName() async {
    final prefs =
        await SharedPreferences.getInstance();

    return prefs.getString('fullName');
  }

  Future<String?> getToken() async {
    final prefs =
        await SharedPreferences.getInstance();

    return prefs.getString('accessToken');
  }

  Future<void> logout() async {
    final prefs =
        await SharedPreferences.getInstance();

    await prefs.clear();
  }
}