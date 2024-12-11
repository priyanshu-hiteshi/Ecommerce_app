import 'package:ecommerce/utils/helper-function/token_decode.dart';
import 'package:flutter/material.dart';
import '../services/authService.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class LoginProvider with ChangeNotifier {
  bool _isLoading = false;
  String _errorMsg = '';
  String _token = '';

  bool get isLoading => _isLoading;
  String get errorMsg => _errorMsg;
  String get token => _token;

  final Authservice _authservice = Authservice();

  Future<void> login(String username, String password) async {
    if (username.isEmpty || password.isEmpty) {
      _errorMsg = "Please fill all the input fields";
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
      JwtHelper.logTokenDetails();

      _errorMsg = '';
    } catch (e) {
      _errorMsg = 'Login failed. Please try again.';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void resetState() {
    _isLoading = false;
    _errorMsg = '';
    notifyListeners();
  }
}
