// lib/model/support/quote_request.dart
import 'dart:io';

class CreateQuoteRequest {
  final String serviceName;
  final String name;
  final String email;
  final String phoneNumber;
  final String description;
  final File? file; // optional

  CreateQuoteRequest({
    required this.serviceName,
    required this.name,
    required this.email,
    required this.phoneNumber,
    required this.description,
    this.file,
  });

  /// For multipart (fields only); file is handled separately.
  Map<String, String> toFields() => {
    'serviceName': serviceName,
    'name': name,
    'email': email,
    'phoneNumber': phoneNumber,
    'description': description,
  };
}
