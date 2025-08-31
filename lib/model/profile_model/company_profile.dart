class CompanyProfile {
  final String userId;
  final String role;
  final String email;
  final String phoneNumber;
  final DateTime createdAt;
  final String companyName;
  final String authorizedPerson;
  final String commercialRegistrationNumber;
  final String unifiedNumber;
  final String taxNumber;
  final String address;

  CompanyProfile({
    required this.userId,
    required this.role,
    required this.email,
    required this.phoneNumber,
    required this.createdAt,
    required this.companyName,
    required this.authorizedPerson,
    required this.commercialRegistrationNumber,
    required this.unifiedNumber,
    required this.taxNumber,
    required this.address,
  });

  factory CompanyProfile.fromJson(Map<String, dynamic> j) => CompanyProfile(
    userId: j['userId'] as String? ?? '',
    role: j['role'] as String? ?? '',
    email: j['email'] as String? ?? '',
    phoneNumber: j['phoneNumber'] as String? ?? '',
    createdAt:
        DateTime.tryParse(j['createdAt'] as String? ?? '') ?? DateTime.now(),
    companyName: j['CompanyName'] as String? ?? '',
    authorizedPerson: j['AuthorizedPerson'] as String? ?? '',
    commercialRegistrationNumber:
        j['CommercialRegistrationNumber'] as String? ?? '',
    unifiedNumber: j['UnifiedNumber'] as String? ?? '',
    taxNumber: j['TaxNumber'] as String? ?? '',
    address: j['Address'] as String? ?? '',
  );
}

class UpdateCompanyProfileRequest {
  final String email;
  final String phoneNumber;
  final String companyName;
  final String authorizedPerson;
  final String commercialRegistrationNumber;
  final String unifiedNumber;
  final String taxNumber;
  final String address;

  UpdateCompanyProfileRequest({
    required this.email,
    required this.phoneNumber,
    required this.companyName,
    required this.authorizedPerson,
    required this.commercialRegistrationNumber,
    required this.unifiedNumber,
    required this.taxNumber,
    required this.address,
  });

  Map<String, dynamic> toJson() => {
    'email': email,
    'phoneNumber': phoneNumber,
    'companyName': companyName,
    'authorizedPerson': authorizedPerson, // per backend key
    'commercialRegistrationNumber': commercialRegistrationNumber,
    'unifiedNumber': unifiedNumber,
    'taxNumber': taxNumber,
    'address': address,
  };
}
