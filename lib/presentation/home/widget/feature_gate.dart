// lib/presentation/common/feature_gate.dart
// ignore_for_file: use_build_context_synchronously, depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:onsetway_services/core/network/http_client.dart';
import 'package:onsetway_services/services/access_api.dart';
import 'package:provider/provider.dart';

Future<bool> ensureFeatureAllowed(
  BuildContext context, {
  required String featureName, // 'appointments' or 'offers'
}) async {
  try {
    final http = context.read<HttpClient>();
    final api = AccessApi(http);
    final f = await api.getUserFeatures();

    final allowed = switch (featureName) {
      'appointments' => f.canAccessAppointments,
      'offers' => f.canAccessOffers,
      _ => false,
    };

    if (!allowed) {
      await showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('Access restricted'),
          content: Text(
            featureName == 'appointments'
                ? 'You cannot book more appointments at the moment.'
                : 'You cannot access offers at the moment.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }

    return allowed;
  } catch (e) {
    // Network or parsing error → explain and block
    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Unable to check access'),
        content: const Text(
          'Please try again in a moment. If the problem persists, contact support.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
    return false;
  }
}
