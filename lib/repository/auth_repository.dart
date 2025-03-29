import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:storyapp/model/response_model.dart' as model;

class AuthRepository {
  final String stateKey = "token";
  final http.Client _client;
  static const String _baseUrl = "https://story-api.dicoding.dev/v1";
  static const String _loginUrl = "$_baseUrl/login";
  static const String _registerUrl = "$_baseUrl/register";

  AuthRepository({http.Client? client}) : _client = client ?? http.Client();

  Future<bool> isLoggedIn() async {
    final preferences = await SharedPreferences.getInstance();
    return preferences.getString(stateKey) != null;
  }

  Future<bool> login(String email, String password) async {
    final preferences = await SharedPreferences.getInstance();
    final response = await _client.post(
      Uri.parse(_loginUrl),
      body: {"email": email, "password": password},
    );
    if (response.statusCode == 200) {
      final loginResponse = model.Response.fromJson(jsonDecode(response.body));
      final token = loginResponse.loginResult?.token;
      if (token != null) {
        await preferences.setString(stateKey, token);
        return true;
      }
    }
    return false;
  }

  Future<bool> register(String email, String password, String name) async {
    final response = await _client.post(
      Uri.parse(_registerUrl),
      body: {"email": email, "password": password, "name": name},
    );
    if (response.statusCode == 201) {
      return await login(email, password);
    }
    return false;
  }

  Future<bool> logout() async {
    final preferences = await SharedPreferences.getInstance();
    return preferences.remove(stateKey);
  }
}
