class SignupCompanyRequest {
  final String email;
  final String password;
  final String phoneNumber;
  final String companyName;
  final String authorizePerson;
  final String commercialRegistrationNumber;
  final String unifiedNumber;
  final String taxNumber;
  final String address;

  SignupCompanyRequest({
    required this.email,
    required this.password,
    required this.phoneNumber,
    required this.companyName,
    required this.authorizePerson,
    required this.commercialRegistrationNumber,
    required this.unifiedNumber,
    required this.taxNumber,
    required this.address,
  });

  Map<String, dynamic> toJson() => {
    'email': email,
    'password': password,
    'phoneNumber': phoneNumber,
    'companyName': companyName,
    'authorizedPerson': authorizePerson, // 👈 صحح هون
    'commercialRegistrationNumber': commercialRegistrationNumber,
    'unifiedNumber': unifiedNumber,
    'taxNumber': taxNumber,
    'address': address,
  };
}
