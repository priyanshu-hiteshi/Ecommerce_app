import 'dart:convert'; // For base64 decoding
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import '../../provider/user_provider.dart';

class JwtHelper {
  /// Decodes a JWT token and extracts the payload.
  static Map<String, dynamic>? decodeJwt(String token) {
    try {
      // Split the token into header, payload, and signature
      final parts = token.split('.');
      if (parts.length != 3) {
        throw Exception('Invalid JWT token');
      }

      // Decode the payload (middle part of the token)
      final payload = parts[1];
      final normalized = base64.normalize(payload); // Handle padding if missing
      final decoded = utf8.decode(base64.decode(normalized));

      // Convert the decoded string to a Map
      return jsonDecode(decoded);
    } catch (e) {
      print('Error decoding JWT: $e');
      return null;
    }
  }

  /// Retrieves the token from shared preferences, decodes it, and updates the UserProvider.
  static Future<String?> logTokenDetails() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token'); // Retrieve the token

    if (token == null) {
      print('No token found in SharedPreferences');
      return null;
    }

    final decodedPayload = decodeJwt(token);

    if (decodedPayload != null) {
      print('Decoded JWT Payload: $decodedPayload');
      if (decodedPayload.containsKey('sub')) {
        // Store the user ID in the UserProvider
        final userId = decodedPayload['sub'].toString();
        await prefs.setString("userId", userId);
        // Provider.of<UserProvider>(context, listen: false).setUserId(userId);
        print('User ID: $userId');
        return userId;
      } else {
        print('User ID not found in the JWT payload');
      }
    }
  }
}
