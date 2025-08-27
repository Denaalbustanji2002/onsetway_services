// ignore_for_file: depend_on_referenced_packages

import 'package:meta/meta.dart';
import 'package:onsetway_services/model/auth_model/auth_response.dart';
import 'package:onsetway_services/model/auth_model/login_request.dart';
import 'package:onsetway_services/model/auth_model/message_response.dart';
import 'package:onsetway_services/model/auth_model/signup_company_request.dart';
import 'package:onsetway_services/model/auth_model/signup_person_request.dart';
import '../../../core/network/http_client.dart';

@immutable
class AuthApi {
  final HttpClient _http;
  const AuthApi(this._http);

  Future<MessageResponse> signupPerson(SignupPersonRequest req) async {
    final json = await _http.postJson(
      '/api/auth/signup/person',
      body: req.toJson(),
    );
    return MessageResponse.fromJson(json);
  }

  Future<MessageResponse> signupCompany(SignupCompanyRequest req) async {
    final json = await _http.postJson(
      '/api/auth/signup/company',
      body: req.toJson(),
    );
    return MessageResponse.fromJson(json);
  }

  Future<AuthResponse> login(LoginRequest req) async {
    final json = await _http.postJson('/api/auth/login', body: req.toJson());
    // API might also return { message: "..."} with 200? (you said errors are proper codes)
    return AuthResponse.fromJson(json);
  }

  Future<MessageResponse> forgotPassword(String email) async {
    final json = await _http.postJson(
      '/api/auth/forgot-password',
      body: {'email': email},
    );
    return MessageResponse.fromJson(json);
  }
}
