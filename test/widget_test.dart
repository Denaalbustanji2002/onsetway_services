// test/widget_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/testing.dart';
import 'package:http/http.dart' as http;

import 'package:onsetway_services/main.dart';
import 'package:onsetway_services/core/network/http_client.dart';
import 'package:onsetway_services/services/auth_api.dart';
import 'package:onsetway_services/services/profile_api.dart';
import 'package:onsetway_services/services/access_api.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('App builds without errors', (WidgetTester tester) async {
    // Stub all HTTP the app might perform at startup.
    final mock = MockClient((http.Request req) async {
      // Feature flags: GET /api/user/access/features
      if (req.method == 'GET' &&
          req.url.path.endsWith('/api/user/access/features')) {
        return http.Response(
          '{"canAccessAppointments":false,"canAccessOffers":false}',
          200,
          headers: {'content-type': 'application/json'},
        );
      }

      // Default OK for any other unexpected boot requests.
      return http.Response(
        "{}",
        200,
        headers: {'content-type': 'application/json'},
      );
    });

    final httpClient = HttpClient(client: mock);
    final authApi = AuthApi(httpClient);
    final profileApi = ProfileApi(httpClient);
    final accessApi = AccessApi(httpClient);

    await tester.pumpWidget(
      MyApp(
        http: httpClient,
        authApi: authApi,
        profileApi: profileApi,
        accessApi: accessApi, // ⬅ required by MyApp now
      ),
    );

    // Let the first frames render (splash animations, etc.)
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 50));

    // Basic smoke assertion.
    expect(find.byType(MaterialApp), findsOneWidget);
    // If you want to assert the splash:
    // expect(find.byType(SplashScreen), findsOneWidget);
  });
}
