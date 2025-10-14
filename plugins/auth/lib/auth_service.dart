import 'dart:convert';
import 'package:http/http.dart' as http;
import 'models/login_response.dart';

class AuthService {
  final _baseUrl = 'http://192.168.0.103:3000/api/v7/pocketbank';

  Future<LoginResponse?> login(String username, String password) async {
    final url = Uri.parse('$_baseUrl/login');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'username': username,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      return LoginResponse.fromJson(json);
    } else {
      return null;
    }
  }
}
