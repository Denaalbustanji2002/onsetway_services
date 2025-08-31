import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:onsetway_services/main.dart';
import 'package:onsetway_services/core/network/http_client.dart';
import 'package:onsetway_services/services/auth_api.dart';
import 'package:onsetway_services/services/profile_api.dart';

void main() {
  testWidgets('App builds without errors', (WidgetTester tester) async {
    // Build required dependencies for MyApp.
    final http = HttpClient();
    final authApi = AuthApi(http);
    final profileApi = ProfileApi(http);

    await tester.pumpWidget(
      MyApp(http: http, authApi: authApi, profileApi: profileApi),
    );
    await tester.pump(); // trigger first frame

    // Basic smoke assertions.
    expect(find.byType(MaterialApp), findsOneWidget);
    // If you want to assert the splash is present, import SplashScreen and:
    // expect(find.byType(SplashScreen), findsOneWidget);
  });
}
