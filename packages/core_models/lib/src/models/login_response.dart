import 'user.dart';

/// Respuesta del servicio de login
class LoginResponse {
  final String code;
  final String userId;
  final String token;
  final User? user;

  LoginResponse({
    required this.code,
    required this.userId,
    required this.token,
    this.user,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      code: json['code'] ?? '',
      userId: json['user_id'] ?? '',
      token: json['token'] ?? '',
      user: json['user'] != null ? User.fromJson(json['user']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'user_id': userId,
      'token': token,
      'user': user?.toJson(),
    };
  }
}
