// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/widgets.dart';
import 'package:onsetway_services/core/storage/token_helper.dart';
import 'package:onsetway_services/services/profile_api.dart';
import 'package:provider/provider.dart'; // MultiRepositoryProvider exposes read<T>()

class ContactInfo {
  final String name;
  final String email;
  final String phone;
  ContactInfo({required this.name, required this.email, required this.phone});
}

Future<ContactInfo?> fetchDefaultContactInfo(BuildContext context) async {
  final profileApi = context.read<ProfileApi>();
  final role = (await TokenHelper.instance.readRole())?.toLowerCase();

  try {
    if (role == 'person') {
      final p = await profileApi.getPerson();
      final name = '${p.firstName} ${p.lastName}'.trim();
      return ContactInfo(name: name, email: p.email, phone: p.phoneNumber);
    } else if (role == 'company') {
      final c = await profileApi.getCompany();
      // Use authorized person for “name”; you can swap to companyName if preferred.
      return ContactInfo(
        name: c.authorizedPerson,
        email: c.email,
        phone: c.phoneNumber,
      );
    }
  } catch (_) {
    // If profile GET fails, just return null (fields will be empty and editable)
  }
  return null;
}
