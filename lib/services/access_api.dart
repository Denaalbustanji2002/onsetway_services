// lib/services/access_api.dart
import 'package:onsetway_services/core/network/http_client.dart';
import 'package:onsetway_services/model/access_model/user_features.dart';

class AccessApi {
  final HttpClient _http;
  AccessApi(this._http);

  Future<UserFeatures> getUserFeatures() async {
    final j = await _http.getJson('/api/user/access/features', auth: true);
    // Your HttpClient.getJson returns Map<String, dynamic>
    return UserFeatures.fromJson(j);
  }
}
