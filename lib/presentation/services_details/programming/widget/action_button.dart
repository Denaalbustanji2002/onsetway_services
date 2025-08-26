// ignore_for_file: unnecessary_import, use_key_in_widget_constructors

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:onsetway_services/presentation/services_details/programming/widget/base_card.dart';
import 'package:onsetway_services/presentation/services_details/programming/widget/smart_button.dart';

class ActionButtons extends BaseCardWidget {
  final VoidCallback? onContactUs;
  final VoidCallback? onGetQuote;

  const ActionButtons({
    required super.feature,
    required super.responsive,
    required super.isActive,
    required super.scaleFactor,
    this.onContactUs,
    this.onGetQuote,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: scale(20)),
      child: Row(
        children: [
          Expanded(
            child: SmartButton(
              text: 'Contact Us',
              icon: Icons.support_agent_outlined,
              isPrimary: false,
              onPressed: onContactUs ?? () {},
              scale: scale,
              responsive: responsive,
              scaleFactor: scaleFactor,
            ),
          ),
          SizedBox(width: scale(14)),
          Expanded(
            child: SmartButton(
              text: 'Get Quote',
              icon: Icons.arrow_forward_rounded,
              isPrimary: true,
              onPressed: onGetQuote ?? () {},
              scale: scale,
              responsive: responsive,
              scaleFactor: scaleFactor,
            ),
          ),
        ],
      ),
    );
  }
}
