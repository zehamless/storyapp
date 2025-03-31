import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:storyapp/model/login_model.dart';
import 'package:storyapp/model/response_model.dart' as model;
import 'package:storyapp/model/story_model.dart';

class AuthRepository {
  final String tokenKey = "token";
  final String userIdKey = "userId";
  final String nameKey = "name";
  final http.Client _client;
  static const String _baseUrl = "https://story-api.dicoding.dev/v1";
  static const String _loginUrl = "$_baseUrl/login";
  static const String _registerUrl = "$_baseUrl/register";

  AuthRepository({http.Client? client}) : _client = client ?? http.Client();

  Future<bool> isLoggedIn() async {
    final preferences = await SharedPreferences.getInstance();
    return preferences.getString(tokenKey) != null;
  }

  Future<bool> login(String email, String password) async {
    final preferences = await SharedPreferences.getInstance();
    final response = await _client.post(
      Uri.parse(_loginUrl),
      body: {"email": email, "password": password},
    );
    if (response.statusCode == 200) {
      final loginResponse = model.Response.fromJson(jsonDecode(response.body));
      final LoginResult? loginResult = loginResponse.loginResult;
      if (loginResult != null) {
        await preferences.setString(tokenKey, loginResult.token ?? "");
        await preferences.setString(userIdKey, loginResult.userId ?? "");
        await preferences.setString(nameKey, loginResult.name ?? "");
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
    return preferences.remove(tokenKey);
  }

  Future<List<Story>> fetchAllStories({int? page, int? size}) async {
    final preferences = await SharedPreferences.getInstance();
    final token = preferences.getString(tokenKey);

    final queryParams = {
      if (page != null) 'page': page.toString(),
      if (size != null) 'size': size.toString(),
    };

    final uri = Uri.parse(
      "$_baseUrl/stories",
    ).replace(queryParameters: queryParams);

    final response = await _client.get(
      uri,
      headers: {"Authorization": "Bearer $token"},
    );

    if (response.statusCode == 200) {
      final storyResponse = model.Response.fromJson(jsonDecode(response.body));
      return storyResponse.listStory ?? [];
    }
    return [];
  }

  Future<Story?> fetchStory(String storyId) async {
    final preferences = await SharedPreferences.getInstance();
    final token = preferences.getString(tokenKey);

    final response = await _client.get(
      Uri.parse("$_baseUrl/stories/$storyId"),
      headers: {"Authorization": "Bearer $token"},
    );

    if (response.statusCode == 200) {
      final storyResponse = model.Response.fromJson(jsonDecode(response.body));
      return storyResponse.story;
    }
    return null;
  }
}
