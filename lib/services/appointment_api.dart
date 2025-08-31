import 'package:onsetway_services/core/network/http_client.dart';

int _asInt(dynamic v, {int fallback = 0}) {
  if (v is int) return v;
  if (v is num) return v.toInt();
  if (v is String) return int.tryParse(v) ?? fallback;
  return fallback;
}

String _asString(dynamic v, {String fallback = ''}) {
  if (v is String) return v;
  if (v == null) return fallback;
  return v.toString();
}

DateTime _asDate(dynamic v) {
  final s = _asString(v);
  final d = DateTime.tryParse(s);
  return d ?? DateTime.now();
}

class AvailabilitySlot {
  final int availabilityId;
  final String dayOfWeek; // "Monday"
  final DateTime date; // 2025-09-08T00:00:00Z
  final String startTime; // "10:30:00"
  final String endTime; // "11:00:00"
  final bool isBooked;

  AvailabilitySlot({
    required this.availabilityId,
    required this.dayOfWeek,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.isBooked,
  });

  factory AvailabilitySlot.fromJson(Map<String, dynamic> j) {
    return AvailabilitySlot(
      availabilityId: _asInt(j['availabilityId'] ?? j['id']),
      dayOfWeek: _asString(j['dayOfWeek']),
      date: _asDate(j['date']),
      startTime: _asString(j['startTime']),
      endTime: _asString(j['endTime']),
      isBooked: (j['isBooked'] ?? false) == true,
    );
  }
}

class AppointmentModel {
  final int appointmentId;
  final int availabilityId;
  final String dayOfWeek;
  final DateTime date;
  final String startTime;
  final String endTime;

  AppointmentModel({
    required this.appointmentId,
    required this.availabilityId,
    required this.dayOfWeek,
    required this.date,
    required this.startTime,
    required this.endTime,
  });

  factory AppointmentModel.fromJson(Map<String, dynamic> j) {
    return AppointmentModel(
      appointmentId: _asInt(j['appointmentId'] ?? j['id']),
      availabilityId: _asInt(j['availabilityId']),
      dayOfWeek: _asString(j['dayOfWeek']),
      date: _asDate(j['date']),
      startTime: _asString(j['startTime']),
      endTime: _asString(j['endTime']),
    );
  }
}

class AppointmentApi {
  final HttpClient _http;
  AppointmentApi(this._http);

  /// Try to read a top-level list; if backend wraps as {data:[...]} or {items:[...]},
  /// unwrap it gracefully.
  Future<List<dynamic>> _getListFlexible(String path) async {
    try {
      // Preferred: endpoint returns a top-level JSON array.
      return await _http.getJsonList(path, auth: true);
    } on ApiException {
      // Fallback: sometimes it’s wrapped in a map.
      final map = await _http.getJson(path, auth: true);
      final v = map['data'] ?? map['items'];
      if (v is List) return v;
      // As a last resort, if server returned a single object, normalize to list.
      if (v is Map) return [v];
      return const <dynamic>[];
    }
  }

  Future<List<AvailabilitySlot>> getAvailable() async {
    final list = await _getListFlexible('/api/appointments/available');
    return list
        .whereType<Map<String, dynamic>>()
        .map(AvailabilitySlot.fromJson)
        .toList();
  }

  Future<Map<String, dynamic>> book({required int availabilityId}) async {
    // Server returns: { appointmentId, availabilityId, userId, bookedAt }
    return await _http.postJson(
      '/api/appointments/book',
      body: {'availabilityId': availabilityId},
      auth: true,
    );
  }

  Future<List<AppointmentModel>> getMyAppointments() async {
    final list = await _getListFlexible('/api/appointments/my');
    return list
        .whereType<Map<String, dynamic>>()
        .map(AppointmentModel.fromJson)
        .toList();
  }

  Future<Map<String, dynamic>> cancel({required int appointmentId}) async {
    // Server returns: { "message": "Appointment cancelled successfully" }
    return await _http.deleteJson(
      '/api/appointments/cancel',
      body: {'appointmentId': appointmentId},
      auth: true,
    );
  }
}
