class PersonProfile {
  final String userId;
  final String role;
  final String email;
  final String phoneNumber;
  final DateTime createdAt;
  final String firstName;
  final String lastName;

  PersonProfile({
    required this.userId,
    required this.role,
    required this.email,
    required this.phoneNumber,
    required this.createdAt,
    required this.firstName,
    required this.lastName,
  });

  factory PersonProfile.fromJson(Map<String, dynamic> j) => PersonProfile(
    userId: j['userId'] as String? ?? '',
    role: j['role'] as String? ?? '',
    email: j['email'] as String? ?? '',
    phoneNumber: j['phoneNumber'] as String? ?? '',
    createdAt:
        DateTime.tryParse(j['createdAt'] as String? ?? '') ?? DateTime.now(),
    firstName: j['firstName'] as String? ?? '',
    lastName: j['lastName'] as String? ?? '',
  );
}

class UpdatePersonProfileRequest {
  final String email;
  final String phoneNumber;
  final String firstName;
  final String lastName;

  UpdatePersonProfileRequest({
    required this.email,
    required this.phoneNumber,
    required this.firstName,
    required this.lastName,
  });

  Map<String, dynamic> toJson() => {
    'email': email,
    'phoneNumber': phoneNumber,
    'firstName': firstName,
    'lastName': lastName,
  };
}
