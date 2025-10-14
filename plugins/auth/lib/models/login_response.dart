class LoginResponse {
  final String code;
  final String userId;
  final String token;

  LoginResponse({
    required this.code,
    required this.userId,
    required this.token,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      code: json['code'] ?? '',
      userId: json['user_id'] ?? '',
      token: json['token'] ?? '',
    );
  }
}
