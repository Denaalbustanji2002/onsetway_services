import 'dart:io';
import 'package:onsetway_services/core/network/http_client.dart';
import 'package:onsetway_services/model/support_model/report_models.dart';

class ReportApi {
  ReportApi(this._http);
  final HttpClient _http;

  Future<CreateReportResponse> create({
    required String subject,
    required String description,
    File? image,
  }) async {
    final j = await _http.postMultipart(
      '/api/problem-reports',
      fields: {'subject': subject, 'description': description},
      files: {'image': image}, // nullable
      auth: true,
    );
    return CreateReportResponse.fromJson(j);
  }

  Future<ReportItem> getById(String id) async {
    final j = await _http.getJson('/api/problem-reports/$id', auth: true);
    return ReportItem.fromJson(j);
  }

  Future<List<ReportItem>> getAll() async {
    final list = await _http.getJsonList('/api/problem-reports', auth: true);
    return list
        .map((e) => ReportItem.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
