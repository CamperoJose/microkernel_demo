import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:core_models/core_models.dart';

/// Implementación del cliente HTTP usando package:http
class HttpClientImpl implements IHttpClient {
  final http.Client _client = http.Client();
  final String baseUrl = 'http://192.168.0.103:3000/api/v7/pocketbank';

  @override
  Future<HttpResponse<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
  }) async {
    final uri = Uri.parse('$baseUrl$path').replace(queryParameters: queryParameters);
    final response = await _client.get(uri, headers: headers);

    return HttpResponse<T>(
      data: jsonDecode(response.body) as T,
      statusCode: response.statusCode,
      headers: response.headers.map((key, value) => MapEntry(key, value)),
    );
  }

  @override
  Future<HttpResponse<T>> post<T>(
    String path, {
    dynamic data,
    Map<String, String>? headers,
  }) async {
    final uri = Uri.parse('$baseUrl$path');
    final defaultHeaders = {'Content-Type': 'application/json'};
    final mergedHeaders = {...defaultHeaders, ...?headers};

    final response = await _client.post(
      uri,
      headers: mergedHeaders,
      body: jsonEncode(data),
    );

    return HttpResponse<T>(
      data: jsonDecode(response.body) as T,
      statusCode: response.statusCode,
      headers: response.headers.map((key, value) => MapEntry(key, value)),
    );
  }

  @override
  Future<HttpResponse<T>> put<T>(
    String path, {
    dynamic data,
    Map<String, String>? headers,
  }) async {
    final uri = Uri.parse('$baseUrl$path');
    final defaultHeaders = {'Content-Type': 'application/json'};
    final mergedHeaders = {...defaultHeaders, ...?headers};

    final response = await _client.put(
      uri,
      headers: mergedHeaders,
      body: jsonEncode(data),
    );

    return HttpResponse<T>(
      data: jsonDecode(response.body) as T,
      statusCode: response.statusCode,
      headers: response.headers.map((key, value) => MapEntry(key, value)),
    );
  }

  @override
  Future<HttpResponse<T>> delete<T>(
    String path, {
    Map<String, String>? headers,
  }) async {
    final uri = Uri.parse('$baseUrl$path');
    final response = await _client.delete(uri, headers: headers);

    return HttpResponse<T>(
      data: jsonDecode(response.body) as T,
      statusCode: response.statusCode,
      headers: response.headers.map((key, value) => MapEntry(key, value)),
    );
  }
}
