import 'package:core_models/core_models.dart';

/// Implementación del servicio de autenticación
class AuthServiceImpl implements IAuthService {
  final IHttpClient _httpClient;
  final IStorageService _storage;
  
  static const String _tokenKey = 'auth_token';
  static const String _userIdKey = 'user_id';
  static const String _userNameKey = 'user_name';

  AuthServiceImpl(this._httpClient, this._storage);

  @override
  Future<LoginResponse> login(String username, String password) async {
    final response = await _httpClient.post<Map<String, dynamic>>(
      '/login',
      data: {
        'username': username,
        'password': password,
      },
    );

    if (response.statusCode == 200) {
      final loginResponse = LoginResponse.fromJson(response.data);
      
      // Guardar token y datos de usuario
      await _storage.write(_tokenKey, loginResponse.token);
      await _storage.write(_userIdKey, loginResponse.userId);
      // Guardar el nombre si viene en la respuesta
      if (loginResponse.user != null) {
        await _storage.write(_userNameKey, loginResponse.user!.name);
      }
      
      return loginResponse;
    } else {
      throw Exception('Error en login: ${response.statusCode}');
    }
  }

  @override
  Future<void> logout() async {
    await _storage.delete(_tokenKey);
    await _storage.delete(_userIdKey);
    await _storage.delete(_userNameKey);
  }

  @override
  Future<bool> isAuthenticated() async {
    final token = await _storage.read(_tokenKey);
    return token != null && token.isNotEmpty;
  }

  @override
  Future<String?> getToken() async {
    return await _storage.read(_tokenKey);
  }

  @override
  Future<User?> getCurrentUser() async {
    final userId = await _storage.read(_userIdKey);
    final userName = await _storage.read(_userNameKey);
    
    if (userId != null) {
      return User(
        id: userId,
        name: userName ?? '',
      );
    }
    
    return null;
  }
}
