import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:onsetway_services/main.dart';
import 'package:onsetway_services/core/network/http_client.dart';
import 'package:onsetway_services/services/apiclient.dart';

void main() {
  testWidgets('App builds without errors', (WidgetTester tester) async {
    // Provide the required dependency to MyApp.
    final authApi = AuthApi(HttpClient());

    await tester.pumpWidget(MyApp(authApi: authApi));
    await tester.pump(); // trigger first frame

    // Basic smoke assertions.
    expect(find.byType(MaterialApp), findsOneWidget);
    // If you prefer to assert splash presence, uncomment the next line
    // after importing the SplashScreen type.
    // expect(find.byType(SplashScreen), findsOneWidget);
  });
}
