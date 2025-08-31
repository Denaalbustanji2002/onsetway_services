class CreateReportResponse {
  final String message;
  final String reportId;
  CreateReportResponse({required this.message, required this.reportId});
  factory CreateReportResponse.fromJson(Map<String, dynamic> j) =>
      CreateReportResponse(
        message: (j['message'] ?? '') as String,
        reportId: (j['reportId'] ?? '') as String,
      );
}

class ReportItem {
  final String id;
  final String? subject;
  final String? description;
  final String? imageUrl;
  final String? createdAt;
  final String? status;

  ReportItem({
    required this.id,
    this.subject,
    this.description,
    this.imageUrl,
    this.createdAt,
    this.status,
  });

  factory ReportItem.fromJson(Map<String, dynamic> j) => ReportItem(
    id: (j['id'] ?? j['reportId'] ?? '') as String,
    subject: j['subject'] as String?,
    description: j['description'] as String?,
    imageUrl: j['imageUrl'] as String?,
    createdAt: j['createdAt'] as String?,
    status: j['status'] as String?,
  );
}
