// lib/services/access_api.dart
// ignore_for_file: unnecessary_cast

import 'package:onsetway_services/core/network/http_client.dart';
import 'package:onsetway_services/model/access_model/user_features.dart';

class AccessApi {
  final HttpClient _http;
  AccessApi(this._http);

  Future<UserFeatures> getUserFeatures() async {
    final j = await _http.getJson('/api/user/access/features', auth: true);

    // Handle both { ... } and { "data": { ... } }
    final map = (j['data'] is Map<String, dynamic>)
        ? j['data'] as Map<String, dynamic>
        : j;

    return UserFeatures.fromJson(map as Map<String, dynamic>);
  }
}
