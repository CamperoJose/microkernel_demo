/// Modelo de usuario
class User {
  final String id;
  final String name;
  final String? email;

  User({required this.id, required this.name, this.email});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? json['user_id'] ?? '',
      name: json['name'] ?? json['userName'] ?? '',
      email: json['email'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'email': email};
  }
}
