import 'package:core_models/core_models.dart';

/// Servicio para obtener balance y transacciones
class BalanceService {
  final IHttpClient _httpClient;
  final IAuthService _authService;

  BalanceService(this._httpClient, this._authService);

  /// Obtiene el balance y las últimas 5 transacciones
  Future<BalanceResponse> getBalance() async {
    final token = await _authService.getToken();

    if (token == null) {
      throw Exception('No hay token de autenticación');
    }

    final response = await _httpClient.get<Map<String, dynamic>>(
      '/balance',
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return BalanceResponse.fromJson(response.data);
    } else {
      throw Exception('Error al obtener balance: ${response.statusCode}');
    }
  }
}
