import 'dart:io';
import 'package:onsetway_services/core/network/http_client.dart';
import 'package:onsetway_services/model/auth_model/message_response.dart';

class SupportApi {
  final HttpClient _http;
  SupportApi(this._http);

  /// POST /api/contact  (JSON)
  /// Body: { name, email, phoneNumber, description, preferredContactTime, serviceName }
  Future<MessageResponse> addContact({
    required String name,
    required String email,
    required String phoneNumber,
    required String description,
    required String preferredContactTime,
    required String serviceName,
  }) async {
    final json = await _http.postJson(
      '/api/contact',
      auth: true,
      body: {
        'name': name,
        'email': email,
        'phoneNumber': phoneNumber,
        'description': description,
        'preferredContactTime': preferredContactTime,
        'serviceName': serviceName,
      },
    );
    return MessageResponse.fromJson(json);
  }

  /// POST /api/quotes  (multipart)
  /// Fields: serviceName, name, email, phoneNumber, description, file?
  Future<MessageResponse> createQuote({
    required String serviceName,
    required String name,
    required String email,
    required String phoneNumber,
    required String description,
    File? file,
  }) async {
    final json = await _http.postMultipart(
      '/api/quotes',
      auth: true,
      fields: {
        'serviceName': serviceName,
        'name': name,
        'email': email,
        'phoneNumber': phoneNumber,
        'description': description,
      },
      files: {'file': file},
    );
    return MessageResponse.fromJson(json);
  }

  /// POST /api/feedback  (JSON)
  Future<MessageResponse> submitFeedback({required String feedbackText}) async {
    final json = await _http.postJson(
      '/api/feedback',
      auth: true,
      body: {'feedbackText': feedbackText},
    );
    return MessageResponse.fromJson(json);
  }

  /// POST /api/problem-reports  (multipart)
  Future<MessageResponse> reportProblem({
    required String subject,
    required String description,
    File? image,
  }) async {
    final json = await _http.postMultipart(
      '/api/problem-reports',
      auth: true,
      fields: {'subject': subject, 'description': description},
      files: {'image': image},
    );
    return MessageResponse.fromJson(json);
  }
}
