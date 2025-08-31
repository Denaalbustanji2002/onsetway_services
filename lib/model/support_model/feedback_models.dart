class CreateFeedbackRequest {
  final String feedbackText;
  CreateFeedbackRequest(this.feedbackText);
  Map<String, dynamic> toJson() => {'feedbackText': feedbackText};
}

class CreateFeedbackResponse {
  final String message;
  final String feedbackId;
  CreateFeedbackResponse({required this.message, required this.feedbackId});
  factory CreateFeedbackResponse.fromJson(Map<String, dynamic> j) =>
      CreateFeedbackResponse(
        message: (j['message'] ?? '') as String,
        feedbackId: (j['feedbackId'] ?? '') as String,
      );
}

/// Defensive shape for GETs (fields may evolve server-side)
class FeedbackItem {
  final String id;
  final String? text;
  final String? createdAt;
  final String? status;
  FeedbackItem({required this.id, this.text, this.createdAt, this.status});

  factory FeedbackItem.fromJson(Map<String, dynamic> j) => FeedbackItem(
    id: (j['id'] ?? j['feedbackId'] ?? '') as String,
    text: j['feedbackText'] as String?,
    createdAt: j['createdAt'] as String?,
    status: j['status'] as String?,
  );
}
