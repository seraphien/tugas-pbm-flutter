import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

import '../utils/api.dart';

class AuthService {
  final storage = const FlutterSecureStorage();

  Future<bool> login({
    required String username,
    required String password,
  }) async {
    final url = Uri.parse("${Api.baseUrl}/auth/login");

    final response = await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
      },
      body: jsonEncode({"username": username, "password": password}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      String token = data['data']['token'];

      await storage.write(key: "token", value: token);

      return true;
    }

    return false;
  }

  Future<String?> getToken() async {
    return await storage.read(key: "token");
  }

  Future<void> logout() async {
    await storage.delete(key: "token");
  }
}
