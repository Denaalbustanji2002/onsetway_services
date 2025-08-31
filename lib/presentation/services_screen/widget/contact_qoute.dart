import 'package:flutter/material.dart';
import 'package:onsetway_services/presentation/services_screen/view/contactus.dart';
import 'package:onsetway_services/presentation/services_screen/view/getqoute.dart';

/// Navigate to Contact Us for a specific service
void handleContactUs(BuildContext context, {required String serviceName}) {
  Navigator.of(context).push(
    MaterialPageRoute(builder: (_) => AddContactPage(serviceName: serviceName)),
  );
}

/// Navigate to Get Quote for a specific service
void handleGetQuote(BuildContext context, {required String serviceName}) {
  Navigator.of(context).push(
    MaterialPageRoute(
      builder: (_) => CreateQuotePage(serviceName: serviceName),
    ),
  );
}
