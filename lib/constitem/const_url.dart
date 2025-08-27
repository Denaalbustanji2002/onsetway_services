class ConstUrl {
  // Prefer --dart-define=BASE_URL=http://192.168.1.131:5001

  //flutter run --dart-define=BASE_URL=https://myapi.com
  static const String baseUrl = String.fromEnvironment(
    'BASE_URL',
    defaultValue: 'http://192.168.1.131:5001',
  );
}
