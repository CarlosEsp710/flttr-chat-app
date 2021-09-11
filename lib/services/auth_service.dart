import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:chat/models/login_response.dart';
import 'package:chat/models/user.dart';
import 'package:chat/global/enviroments.dart';

class AuthService with ChangeNotifier {
  late User user;
  bool _authenticating = false;
  final _storage = const FlutterSecureStorage();

  // Auth Status ((Getters & Setters)
  bool get authenticating => _authenticating;
  set authenticating(bool value) {
    _authenticating = value;
    notifyListeners();
  }

  // Token (Getteres)
  static Future<String> getToken() async {
    const _storage = FlutterSecureStorage();
    final token = await _storage.read(key: 'token');
    return token.toString();
  }

  static Future<void> deleteToken() async {
    const _storage = FlutterSecureStorage();
    await _storage.delete(key: 'token');
  }

  Future<bool> login(String email, String password) async {
    authenticating = true;

    final data = {'email': email, 'password': password};

    final uri = Uri.parse('${Enviroment.apiUrl}/login/');

    final response = await http.post(uri, body: jsonEncode(data), headers: {
      'Accept': 'application/json',
      'Content-Type': 'application/json'
    });

    authenticating = false;
    if (response.statusCode == 200) {
      final loginResponse = loginResponseFromJson(response.body);
      user = loginResponse.user;
      await _saveToken(loginResponse.token);
      return true;
    } else {
      return false;
    }
  }

  Future register(String name, String email, String password) async {
    authenticating = true;

    final data = {'name': name, 'email': email, 'password': password};

    final uri = Uri.parse('${Enviroment.apiUrl}/login/new/');

    final response = await http.post(uri, body: jsonEncode(data), headers: {
      'Accept': 'application/json',
      'Content-Type': 'application/json'
    });

    authenticating = false;
    if (response.statusCode == 200) {
      final loginResponse = loginResponseFromJson(response.body);
      user = loginResponse.user;
      await _saveToken(loginResponse.token);
      return true;
    } else {
      final error = jsonDecode(response.body);
      return error['msg'];
    }
  }

  Future<bool> isLoggedIn() async {
    final token = await _storage.read(key: 'token');

    final uri = Uri.parse('${Enviroment.apiUrl}/login/renew/');

    final response = await http.get(uri, headers: {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'x-token': token.toString()
    });

    if (response.statusCode == 200) {
      final loginResponse = loginResponseFromJson(response.body);
      user = loginResponse.user;
      await _saveToken(loginResponse.token);
      return true;
    } else {
      _logout();
      return false;
    }
  }

  Future _saveToken(String token) async {
    return await _storage.write(key: 'token', value: token);
  }

  Future _logout() async {
    return await _storage.delete(key: 'token');
  }
}
