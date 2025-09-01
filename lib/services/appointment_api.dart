// ignore_for_file: unnecessary_type_check

import 'package:onsetway_services/core/network/http_client.dart';

bool _asBool(dynamic v) {
  if (v is bool) return v;
  if (v is num) return v != 0;
  if (v is String) {
    final s = v.toLowerCase().trim();
    return s == 'true' || s == '1' || s == 'yes';
  }
  return false;
}

int _asInt(dynamic v, [int fallback = 0]) {
  if (v is int) return v;
  if (v is num) return v.toInt();
  if (v is String) return int.tryParse(v) ?? fallback;
  return fallback;
}

String _asString(dynamic v, [String fallback = '']) {
  if (v == null) return fallback;
  return v.toString();
}

DateTime _parseDate(dynamic v) {
  final s = v?.toString() ?? '';
  return DateTime.tryParse(s) ?? DateTime.now();
}

String _weekdayFromDate(DateTime d) {
  const names = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday',
  ];
  return names[d.weekday - 1];
}

/// ============ MODELS ============

class AvailabilitySlot {
  final int availabilityId;
  final String dayOfWeek; // backend may not send; we compute fallback
  final String startTime; // "HH:mm" or "HH:mm:ss"
  final String endTime;
  final bool isBooked;

  AvailabilitySlot({
    required this.availabilityId,
    required this.dayOfWeek,
    required this.startTime,
    required this.endTime,
    required this.isBooked,
  });

  factory AvailabilitySlot.fromJson(
    Map<String, dynamic> j, {
    String? dayOfWeek,
  }) {
    return AvailabilitySlot(
      availabilityId: _asInt(j['availabilityId'] ?? j['id']),
      dayOfWeek: _asString(j['dayOfWeek'], dayOfWeek ?? ''),
      startTime: _asString(j['startTime']),
      endTime: _asString(j['endTime']),
      isBooked: _asBool(j['isBooked']),
    );
  }
}

class AvailableDay {
  final DateTime date; // "2025-09-08" or ISO
  final String dayOfWeek; // e.g. "Monday"
  final List<AvailabilitySlot> slots;

  AvailableDay({
    required this.date,
    required this.dayOfWeek,
    required this.slots,
  });

  factory AvailableDay.fromJson(Map<String, dynamic> j) {
    final d = _parseDate(j['date']);
    final w = _asString(j['dayOfWeek'], _weekdayFromDate(d));

    final raw = j['slots'];
    final List list = (raw is List) ? raw : const [];
    final slots = list
        .map(
          (e) => AvailabilitySlot.fromJson(
            e as Map<String, dynamic>,
            dayOfWeek: w,
          ),
        )
        .toList();

    return AvailableDay(date: d, dayOfWeek: w, slots: slots);
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
    final d = _parseDate(j['date']);
    return AppointmentModel(
      appointmentId: _asInt(j['appointmentId'] ?? j['id']),
      availabilityId: _asInt(j['availabilityId']),
      dayOfWeek: _asString(j['dayOfWeek'], _weekdayFromDate(d)),
      date: d,
      startTime: _asString(j['startTime']),
      endTime: _asString(j['endTime']),
    );
  }
}

/// ============ API ============

class AppointmentApi {
  final HttpClient _http;
  AppointmentApi(this._http);

  // normalizes {"data":[...]} or {"items":[...]} or direct [...]
  List _pickList(dynamic root, {List<String> keys = const ['data', 'items']}) {
    if (root is List) return root;
    if (root is Map<String, dynamic>) {
      for (final k in keys) {
        final v = root[k];
        if (v is List) return v;
      }
    }
    return const [];
  }

  // GET /api/appointments/available  (grouped by day)
  Future<List<AvailableDay>> getAvailableDays() async {
    final j = await _http.getJson('/api/appointments/available', auth: true);
    // backend now groups by day: try data/items; else try "availableDays"
    List raw = _pickList(j, keys: const ['data', 'items', 'availableDays']);
    // If server returns a single map {date, dayOfWeek, slots:[]}
    if (raw.isEmpty && j is Map && j['date'] != null && j['slots'] is List) {
      raw = [j];
    }
    return raw
        .map((e) => AvailableDay.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  // POST /api/appointments/book  {availabilityId}
  Future<Map<String, dynamic>> book({required int availabilityId}) async {
    return await _http.postJson(
      '/api/appointments/book',
      body: {'availabilityId': availabilityId},
      auth: true,
    );
  }

  // GET /api/appointments/my
  Future<List<AppointmentModel>> getMyAppointments() async {
    final j = await _http.getJson('/api/appointments/my', auth: true);
    final list = _pickList(j, keys: const ['data', 'items', 'appointments']);
    return list
        .map((e) => AppointmentModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  // DELETE /api/appointments/cancel  {appointmentId}
  Future<Map<String, dynamic>> cancel({required int appointmentId}) async {
    return await _http.deleteJson(
      '/api/appointments/cancel',
      body: {'appointmentId': appointmentId},
      auth: true,
    );
  }
}
