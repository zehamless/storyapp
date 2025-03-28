import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:storyapp/model/response.dart' as model;

class AuthRepository {
  final String stateKey = "token";
  final http.Client _client;
  static final String _baseUrl = "https://story-api.dicoding.dev/v1";
  static final String _loginUrl = "$_baseUrl/login";
  static final String _registerUrl = "$_baseUrl/register";

  AuthRepository({http.Client? client}) : _client = client ?? http.Client();

  Future<bool> isLoggedIn() async {
    final preferences = await SharedPreferences.getInstance();
    return (preferences.getString(stateKey) != null);
  }

  Future<bool> login(String email, String password) async {
    final preferences = await SharedPreferences.getInstance();
    final http.Response response = await _client.post(
      Uri.parse(_loginUrl),
      body: {"email": email, "password": password},
    );
    if (response.statusCode == 200) {
      final loginResponse = model.Response.fromJson(jsonDecode(response.body));
      final token = loginResponse.loginResult?.token;
      await preferences.setString(stateKey, token!);
      return true;
    } else {
      return false;
    }
  }

  Future<bool> register(String email, String password, String name) async {
    final http.Response response = await _client.post(
      Uri.parse(_registerUrl),
      body: {"email": email, "password": password, "name": name},
    );
    if (response.statusCode == 201) {
      await login(email, password);
      return true;
    } else {
      return false;
    }
  }

  Future<bool> logout() async {
    final preferences = await SharedPreferences.getInstance();
    return preferences.remove(stateKey);
  }
}
