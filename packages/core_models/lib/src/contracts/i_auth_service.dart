import '../models/user.dart';
import '../models/login_response.dart';

/// Contrato para servicio de autenticación
abstract class IAuthService {
  Future<LoginResponse> login(String username, String password);
  Future<void> logout();
  Future<bool> isAuthenticated();
  Future<String?> getToken();
  Future<User?> getCurrentUser();
}
