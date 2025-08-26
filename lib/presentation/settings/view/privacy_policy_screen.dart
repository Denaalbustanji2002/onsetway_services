// ignore_for_file: deprecated_member_use, use_super_parameters

import 'package:flutter/material.dart';
import 'package:onsetway_services/constitem/const_colors.dart';
import 'package:onsetway_services/presentation/services_details/programming/widget/appbar_pop.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OWPScaffold(
      title: 'Privacy Policy',
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              ConstColor.black.withOpacity(0.97),
              ConstColor.black,
              ConstColor.black.withOpacity(0.99),
            ],
          ),
        ),
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(child: _buildProfessionalHeader()),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  _buildLegalNotice(),
                  const SizedBox(height: 22),
                  ..._buildPolicySections(),
                  const SizedBox(height: 30),
                  _buildLegalFooter(),
                  const SizedBox(height: 24),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfessionalHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 48, horizontal: 24),
      child: Column(
        children: [
          // Company emblem
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  ConstColor.gold,
                  ConstColor.gold.withOpacity(0.9),
                  ConstColor.darkGold,
                ],
              ),
              shape: BoxShape.circle,
              border: Border.all(
                color: ConstColor.gold.withOpacity(0.3),
                width: 2,
              ),
              boxShadow: [
                BoxShadow(
                  color: ConstColor.gold.withOpacity(0.25),
                  blurRadius: 24,
                  spreadRadius: 4,
                ),
              ],
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Icon(Icons.privacy_tip_outlined, size: 45, color: ConstColor.black),
                Positioned(
                  bottom: 8,
                  child: Container(
                    width: 20,
                    height: 3,
                    decoration: BoxDecoration(
                      color: ConstColor.black,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Title with enhanced typography
          Text(
            'PRIVACY POLICY',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w800,
              color: ConstColor.gold,
              letterSpacing: 2.5,
              height: 1.2,
            ),
          ),

          const SizedBox(height: 16),

          // Subtitle with legal formality
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
            decoration: BoxDecoration(
              color: ConstColor.gold.withOpacity(0.1),
              borderRadius: BorderRadius.circular(25),
              border: Border.all(
                color: ConstColor.gold.withOpacity(0.2),
                width: 1,
              ),
            ),
            child: Text(
              'Data Protection • Effective \n August 21, 2025',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: ConstColor.gold,
                letterSpacing: 0.8,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLegalNotice() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: ConstColor.darkGold.withOpacity(0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: ConstColor.gold.withOpacity(0.25), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.info_outline, color: ConstColor.gold, size: 20),
              const SizedBox(width: 8),
              Text(
                'IMPORTANT LEGAL NOTICE',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: ConstColor.gold,
                  letterSpacing: 1.2,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'At Onsetway, we are committed to protecting your privacy and safeguarding your personal information. This Privacy Policy outlines our data collection, usage, and protection practices in accordance with international privacy standards.',
            style: TextStyle(
              fontSize: 13,
              height: 1.6,
              color: ConstColor.white.withOpacity(0.9),
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildPolicySections() {
    final sections = [
      {
        'number': '01',
        'icon': Icons.data_usage_outlined,
        'title': 'Information We Collect',
        'content':
            'We collect personal data including full name, email address, phone number, company details, service requests, communication history, and website usage data through analytics tools and cookies to provide and improve our services.',
      },
      {
        'number': '02',
        'icon': Icons.settings_applications_outlined,
        'title': 'How We Use Your Information',
        'content':
            'Your personal information is used to respond to inquiries, provide requested services, process transactions, send invoices, improve our website and services, provide customer support, and send updates or marketing communications with your consent.',
      },
      {
        'number': '03',
        'icon': Icons.security_outlined,
        'title': 'Data Protection & Security',
        'content':
            'We implement appropriate technical and organizational security measures to protect your personal data from unauthorized access, loss, or misuse. Access to your data is strictly limited to authorized team members who require it for business purposes.',
      },
      {
        'number': '04',
        'icon': Icons.share_outlined,
        'title': 'Data Sharing Policy',
        'content':
            'We do not sell, rent, or trade your personal data. We may share your information only with your explicit permission, with trusted third-party service providers under strict confidentiality agreements, or when legally required to do so.',
      },
      {
        'number': '05',
        'icon': Icons.cookie_outlined,
        'title': 'Cookies & Tracking',
        'content':
            'Our website uses cookies to enhance your browsing experience and analyze site usage. You may disable cookies through your browser settings, though this may affect certain website features and functionality.',
      },
      {
        'number': '06',
        'icon': Icons.account_circle_outlined,
        'title': 'Your Privacy Rights',
        'content':
            'You have the right to access, correct, or delete your personal data, withdraw consent for communications, and request data portability. These rights can be exercised at any time by contacting our privacy team.',
      },
      {
        'number': '07',
        'icon': Icons.update_outlined,
        'title': 'Policy Updates',
        'content':
            'This Privacy Policy may be updated periodically to reflect changes in our practices, services, or legal requirements. All updates will be posted on this page with a revised effective date and appropriate notice.',
      },
      {
        'number': '08',
        'icon': Icons.gavel_outlined,
        'title': 'Legal Compliance',
        'content':
            'Our data processing practices comply with applicable privacy laws and regulations. We maintain appropriate documentation and procedures to demonstrate compliance with data protection requirements.',
      },
      {
        'number': '09',
        'icon': Icons.contact_support_outlined,
        'title': 'Privacy Contact',
        'content':
            'For privacy-related questions, data requests, or concerns about how your information is handled, please contact our privacy team using the contact information provided below.',
      },
    ];

    return sections.asMap().entries.map((entry) {
      int index = entry.key;
      Map<String, dynamic> section = entry.value;
      return _buildFormalPolicySection(
        number: section['number'],
        icon: section['icon'],
        title: section['title'],
        content: section['content'],
        index: index,
      );
    }).toList();
  }

  Widget _buildFormalPolicySection({
    required String number,
    required IconData icon,
    required String title,
    required String content,
    required int index,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      child: Container(
        decoration: BoxDecoration(
          color: ConstColor.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: ConstColor.gold.withOpacity(0.15),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: ConstColor.black.withOpacity(0.08),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
            BoxShadow(
              color: ConstColor.gold.withOpacity(0.04),
              blurRadius: 20,
              spreadRadius: 1,
            ),
          ],
        ),
        child: Column(
          children: [
            // Header section
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    ConstColor.gold.withOpacity(0.08),
                    ConstColor.darkGold.withOpacity(0.06),
                  ],
                ),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
              ),
              child: Row(
                children: [
                  // Section number
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [ConstColor.gold, ConstColor.darkGold],
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Text(
                        number,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: ConstColor.white,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 16),

                  // Icon
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: ConstColor.gold.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: ConstColor.gold.withOpacity(0.3),
                      ),
                    ),
                    child: Icon(icon, size: 18, color: ConstColor.darkGold),
                  ),

                  const SizedBox(width: 16),

                  // Title
                  Expanded(
                    child: Text(
                      title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: ConstColor.black,
                        letterSpacing: -0.2,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Content section
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              child: Text(
                content,
                style: TextStyle(
                  fontSize: 14,
                  height: 1.7,
                  color: const Color(0xFF374151),
                  fontWeight: FontWeight.w400,
                  letterSpacing: 0.1,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLegalFooter() {
    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            ConstColor.black.withOpacity(0.6),
            ConstColor.black.withOpacity(0.8),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: ConstColor.gold.withOpacity(0.3), width: 1.5),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.shield_outlined, color: ConstColor.gold, size: 24),
              const SizedBox(width: 12),
              Text(
                'PRIVACY CONTACT\n INFORMATION',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: ConstColor.gold,
                  letterSpacing: 1.5,
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: ConstColor.gold.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: ConstColor.gold.withOpacity(0.2)),
            ),
            child: Column(
              children: [
                _buildContactItem(Icons.email_outlined, 'support@ow-jo.com'),
                const SizedBox(height: 12),
                _buildContactItem(Icons.phone_outlined, '+962 65 673 053'),
                const SizedBox(height: 12),
                _buildContactItem(
                  Icons.location_on_outlined,
                  '46 Azal Plaza, Queen Nour Street\nAmman, Jordan',
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          Text(
            'For privacy inquiries, data requests, or concerns about information handling\n"Your privacy is our priority" © 2025 Onsetway. All rights reserved.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12,
              color: ConstColor.white.withOpacity(0.7),
              fontStyle: FontStyle.italic,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactItem(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 18, color: ConstColor.gold),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 13,
              color: ConstColor.white.withOpacity(0.9),
              fontWeight: FontWeight.w500,
              height: 1.4,
            ),
          ),
        ),
      ],
    );
  }
}
