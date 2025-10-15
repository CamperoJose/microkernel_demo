/// Respuesta HTTP genérica
class HttpResponse<T> {
  final T data;
  final int statusCode;
  final Map<String, dynamic> headers;

  HttpResponse({
    required this.data,
    required this.statusCode,
    required this.headers,
  });
}

/// Contrato para cliente HTTP
abstract class IHttpClient {
  Future<HttpResponse<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
  });

  Future<HttpResponse<T>> post<T>(
    String path, {
    dynamic data,
    Map<String, String>? headers,
  });

  Future<HttpResponse<T>> put<T>(
    String path, {
    dynamic data,
    Map<String, String>? headers,
  });

  Future<HttpResponse<T>> delete<T>(
    String path, {
    Map<String, String>? headers,
  });
}
