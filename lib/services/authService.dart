import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

class Authservice {
  String baseUrl = "https://fakestoreapi.com/";
  Map<String, String> headers = {'Content-Type': 'application/json'};

  Future<Response> getRequest(String endPoint) async {
    final response = await http.get(
      Uri.parse('$baseUrl$endPoint'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      return response;
    } else {
      throw Exception("Something went wrong !");
    }
  }

  Future<Response> postRequest(
      String endPoint, Map<String, dynamic> body) async {
    final response = await http.post(
      Uri.parse('$baseUrl$endPoint'),
      headers: headers,
      body: jsonEncode(body),
    );

    if (response.statusCode == 200) {
      return response;
    } else {
      throw Exception("Something went wrong !");
    }
  }
}
