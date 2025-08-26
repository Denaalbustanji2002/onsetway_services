// ignore_for_file: unused_element, file_names, use_super_parameters, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:onsetway_services/constitem/const_colors.dart';
import 'package:onsetway_services/presentation/services_details/programming/widget/appbar_pop.dart';

class TermsConditions extends StatelessWidget {
  const TermsConditions({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OWPScaffold(
      title: 'Terms & Conditions',
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
                  const SizedBox(height: 32),
                  ..._buildPolicySections(),
                  const SizedBox(height: 40),
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
                Icon(Icons.balance, size: 45, color: ConstColor.black),
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
            'TERMS & CONDITIONS',
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
              'Legal Agreement • Effective \n August 21, 2025',
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
      padding: const EdgeInsets.all(24),
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
            'By accessing and using the services provided by Onsetway, you acknowledge that you have read, understood, and agree to be legally bound by these Terms and Conditions in their entirety.',
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
        'icon': Icons.business_center_outlined,
        'title': 'Scope of Services',
        'content':
            'Onsetway provides comprehensive technology solutions including software development, IT consulting, system integration, and digital transformation services. All services are delivered in accordance with industry best practices and applicable regulatory requirements.',
      },
      {
        'number': '02',
        'icon': Icons.verified_user_outlined,
        'title': 'User Obligations',
        'content':
            'Users must utilize our services in compliance with all applicable laws and regulations. Any misuse, unauthorized access, or breach of security protocols may result in immediate termination of services and potential legal action.',
      },
      {
        'number': '03',
        'icon': Icons.copyright_outlined,
        'title': 'Intellectual Property Rights',
        'content':
            'All proprietary technologies, methodologies, source code, designs, and documentation remain the exclusive property of Onsetway. Unauthorized reproduction, distribution, or reverse engineering is strictly prohibited and protected under international copyright law.',
      },
      {
        'number': '04',
        'icon': Icons.handshake_outlined,
        'title': 'Service Level Agreements',
        'content':
            'Service specifications, deliverables, timelines, and performance metrics are detailed in individual service agreements. Onsetway commits to maintaining professional standards and meeting agreed-upon service levels.',
      },
      {
        'number': '05',
        'icon': Icons.payment_outlined,
        'title': 'Financial Terms',
        'content':
            'Payment obligations, billing cycles, and fee structures are established prior to service commencement. Late payments may incur additional charges and may result in service suspension until account reconciliation.',
      },
      {
        'number': '06',
        'icon': Icons.policy_outlined,
        'title': 'Privacy & Data Protection',
        'content':
            'Client data handling adheres to international privacy standards and data protection regulations. Our comprehensive Privacy Policy governs data collection, processing, storage, and protection measures.',
      },
      {
        'number': '07',
        'icon': Icons.security_outlined,
        'title': 'Limitation of Liability',
        'content':
            'Onsetway\'s liability is limited to the maximum extent permitted by applicable law. We shall not be liable for indirect, consequential, or punitive damages arising from service usage or interruption.',
      },
      {
        'number': '08',
        'icon': Icons.gavel_outlined,
        'title': 'Dispute Resolution',
        'content':
            'Any disputes shall be resolved through binding arbitration under Jordanian law. The courts of Amman, Jordan, shall have exclusive jurisdiction for any legal proceedings.',
      },
      {
        'number': '09',
        'icon': Icons.update_outlined,
        'title': 'Terms Modification',
        'content':
            'These terms may be updated to reflect changes in our services, legal requirements, or business practices. Material changes will be communicated with appropriate notice period.',
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
              Icon(Icons.balance, color: ConstColor.gold, size: 24),
              const SizedBox(width: 12),
              Text(
                'LEGAL CONTACT\n INFORMATION',
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
            'For legal inquiries, contract modifications, or dispute resolution \n © 2025 Onsetway. All rights reserved.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12,
              color: ConstColor.white.withOpacity(0.7),
              fontStyle: FontStyle.italic,
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
