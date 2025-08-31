import 'package:onsetway_services/core/network/authed_client.dart';
import 'package:onsetway_services/core/network/http_client.dart';
import 'package:onsetway_services/model/auth_model/message_response.dart';
import 'package:onsetway_services/model/profile_model/company_profile.dart';
import 'package:onsetway_services/model/profile_model/person_profile.dart';

class ProfileApi {
  final AuthorizedHttpClient _http;

  /// Option A (factory): keep your main.dart call as `ProfileApi(http)`.
  ProfileApi(HttpClient http) : _http = AuthorizedHttpClient.fromBase(http);

  /// Option B (named param): `ProfileApi.withClient(client: AuthorizedHttpClient(base: http))`
  ProfileApi.withClient({required AuthorizedHttpClient client})
    : _http = client;

  // Person
  Future<PersonProfile> getPerson() async {
    final j = await _http.getJson('/api/user/person-profile');
    return PersonProfile.fromJson(j);
  }

  Future<MessageResponse> updatePerson(UpdatePersonProfileRequest req) async {
    final j = await _http.putJson(
      '/api/user/person-profile',
      body: req.toJson(),
    );
    return MessageResponse.fromJson(j);
  }

  Future<MessageResponse> deletePerson() async {
    final j = await _http.deleteJson('/api/user/person-profile');
    return MessageResponse.fromJson(j);
  }

  // Company
  Future<CompanyProfile> getCompany() async {
    final j = await _http.getJson('/api/user/company-profile');
    return CompanyProfile.fromJson(j);
  }

  Future<MessageResponse> updateCompany(UpdateCompanyProfileRequest req) async {
    final j = await _http.putJson(
      '/api/user/company-profile',
      body: req.toJson(),
    );
    return MessageResponse.fromJson(j);
  }

  Future<MessageResponse> deleteCompany() async {
    final j = await _http.deleteJson('/api/user/company-profile');
    return MessageResponse.fromJson(j);
  }
}
