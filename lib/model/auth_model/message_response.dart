class MessageResponse {
  final String message;
  MessageResponse(this.message);
  factory MessageResponse.fromJson(Map<String, dynamic> j) =>
      MessageResponse((j['message'] ?? '') as String);
}
