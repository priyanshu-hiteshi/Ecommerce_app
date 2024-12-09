import 'dart:convert';
import 'dart:ffi';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import '../services/authService.dart';

class LoginProvider with ChangeNotifier {
  bool _isLoading = false;
  String _errorMsg = ' ';
  String _token = '';

  bool get isLoading => _isLoading;
  String get errorMsg => _errorMsg;

  String get token => _token;

  final Authservice _authservice = Authservice();

  Future<void> login(String username, String password) async {
    if (username.isEmpty || password.isEmpty) {
      _errorMsg = "Please fill all the input field";
      notifyListeners();
      return;
    }

    _isLoading = true;

    notifyListeners();

    try {
      final res = await _authservice.postRequest(
          "auth/login", {"username": username, "password": password});
      _token = jsonDecode(res.body)["token"] as String;

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', _token);

      _errorMsg = " ";
    } catch (e) {
      print(errorMsg);
    }
  }
}
