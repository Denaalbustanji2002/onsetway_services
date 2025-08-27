class SignupPersonRequest {
  final String email;
  final String password;
  final String phoneNumber;
  final String firstName;
  final String lastName;
  SignupPersonRequest({
    required this.email,
    required this.password,
    required this.phoneNumber,
    required this.firstName,
    required this.lastName,
  });

  Map<String, dynamic> toJson() => {
    'email': email,
    'password': password,
    'phoneNumber': phoneNumber,
    'firstName': firstName,
    'lastName': lastName,
  };
}
