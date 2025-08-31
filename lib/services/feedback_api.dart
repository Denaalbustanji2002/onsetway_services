import 'package:onsetway_services/core/network/http_client.dart';
import 'package:onsetway_services/model/support_model/feedback_models.dart';

class FeedbackApi {
  FeedbackApi(this._http);
  final HttpClient _http;

  Future<CreateFeedbackResponse> sendFeedback(CreateFeedbackRequest req) async {
    final j = await _http.postJson(
      '/api/feedback',
      body: req.toJson(),
      auth: true,
    );
    return CreateFeedbackResponse.fromJson(j);
  }

  Future<FeedbackItem> getById(String id) async {
    final j = await _http.getJson('/api/feedback/$id', auth: true);
    return FeedbackItem.fromJson(j);
  }

  Future<List<FeedbackItem>> getAll() async {
    final list = await _http.getJsonList('/api/feedback', auth: true);
    return list
        .map((e) => FeedbackItem.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
