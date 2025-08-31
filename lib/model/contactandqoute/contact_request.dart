// lib/model/support/contact_request.dart
class AddContactRequest {
  final String name;
  final String email;
  final String phoneNumber;
  final String description;
  final String preferredContactTime; // e.g., "12pm - 2pm"
  final String serviceName; // e.g., "Web development"

  AddContactRequest({
    required this.name,
    required this.email,
    required this.phoneNumber,
    required this.description,
    required this.preferredContactTime,
    required this.serviceName,
  });

  Map<String, dynamic> toJson() => {
    'name': name,
    'email': email,
    'phoneNumber': phoneNumber,
    'description': description,
    'preferredContactTime': preferredContactTime,
    'serviceName': serviceName,
  };
}
