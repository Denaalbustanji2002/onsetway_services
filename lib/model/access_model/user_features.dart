// lib/model/access/user_features.dart
class UserFeatures {
  final bool canAccessAppointments;
  final bool canAccessOffers;

  const UserFeatures({
    required this.canAccessAppointments,
    required this.canAccessOffers,
  });

  factory UserFeatures.fromJson(Map<String, dynamic> j) {
    // default to false if server omits a key
    return UserFeatures(
      canAccessAppointments: (j['canAccessAppointments'] as bool?) ?? false,
      canAccessOffers: (j['canAccessOffers'] as bool?) ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
    'canAccessAppointments': canAccessAppointments,
    'canAccessOffers': canAccessOffers,
  };

  @override
  String toString() =>
      'UserFeatures(appointments=$canAccessAppointments, offers=$canAccessOffers)';
}
