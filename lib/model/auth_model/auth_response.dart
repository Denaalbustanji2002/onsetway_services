class AuthResponse {
  final String token;
  final String email;
  final String role;
  AuthResponse({required this.token, required this.email, required this.role});

  factory AuthResponse.fromJson(Map<String, dynamic> json) => AuthResponse(
    token: json['token'] as String,
    email: (json['user']?['email'] ?? '') as String,
    role: (json['user']?['role'] ?? '') as String,
  );
}
