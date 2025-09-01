// lib/model/access/user_features.dart
class UserFeatures {
  final bool canAccessAppointments;
  final bool canAccessOffers;

  const UserFeatures({
    required this.canAccessAppointments,
    required this.canAccessOffers,
  });

  /// Robust factory:
  /// - Accepts root, `data`, or `features` wrapper
  /// - Accepts camelCase or snake_case keys
  /// - Coerces bool from bool/num/string
  factory UserFeatures.fromJson(Map<String, dynamic> json) {
    // unwrap if server sends { "data": { ... } } or { "features": { ... } }
    final Map<String, dynamic> j = _unwrap(json, const ['data', 'features']);

    return UserFeatures(
      canAccessAppointments: _asBool(
        j['canAccessAppointments'] ??
            j['can_access_appointments'] ??
            j['appointmentsAllowed'] ??
            j['appointments_allowed'],
      ),
      canAccessOffers: _asBool(
        j['canAccessOffers'] ??
            j['can_access_offers'] ??
            j['offersAllowed'] ??
            j['offers_allowed'],
      ),
    );
  }

  Map<String, dynamic> toJson() => {
    'canAccessAppointments': canAccessAppointments,
    'canAccessOffers': canAccessOffers,
  };

  UserFeatures copyWith({bool? canAccessAppointments, bool? canAccessOffers}) {
    return UserFeatures(
      canAccessAppointments:
          canAccessAppointments ?? this.canAccessAppointments,
      canAccessOffers: canAccessOffers ?? this.canAccessOffers,
    );
  }

  @override
  String toString() =>
      'UserFeatures(appointments=$canAccessAppointments, offers=$canAccessOffers)';

  // ---------- helpers ----------
  static Map<String, dynamic> _unwrap(
    Map<String, dynamic> src,
    List<String> keys,
  ) {
    for (final k in keys) {
      final v = src[k];
      if (v is Map<String, dynamic>) return v;
    }
    return src;
  }

  static bool _asBool(dynamic v) {
    if (v is bool) return v;
    if (v is num) return v != 0;
    if (v is String) {
      final s = v.trim().toLowerCase();
      return s == 'true' || s == '1' || s == 'yes';
    }
    return false; // default if missing/unknown
  }
}
