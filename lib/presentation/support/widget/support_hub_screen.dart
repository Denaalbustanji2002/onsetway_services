import 'package:flutter/material.dart';
import 'package:onsetway_services/constitem/const_colors.dart';

import 'package:onsetway_services/presentation/services_details/programming/widget/appbar_pop.dart';
import 'package:onsetway_services/presentation/support/view/send_feedback_page.dart';
import 'package:onsetway_services/presentation/support/view/send_report_page.dart';

class SupportCenterPage extends StatelessWidget {
  const SupportCenterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return OWPScaffold(
      title: 'Support Center  ',
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _card(
            context,
            title: 'Send Feedback',
            subtitle: 'Share ideas or comments with the team.',
            icon: Icons.reviews_outlined,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const SendFeedbackPage()),
            ),
          ),
          const SizedBox(height: 12),
          _card(
            context,
            title: 'Report a Problem',
            subtitle: 'Describe an issue and attach a screenshot.',
            icon: Icons.report_problem_outlined,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const SendProblemReportPage()),
            ),
          ),
        ],
      ),
    );
  }

  Widget _card(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Ink(
        decoration: BoxDecoration(
          color: ConstColor.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: ConstColor.black.withOpacity(0.06),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
          border: Border.all(
            color: ConstColor.darkGold.withOpacity(0.2),
            width: 1,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  gradient: const LinearGradient(
                    colors: [ConstColor.darkGold, ConstColor.gold],
                  ),
                ),
                child: const Icon(
                  Icons.support_agent_outlined,
                  color: Colors.black,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: ConstColor.black,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 12,
                        color: ConstColor.black.withOpacity(0.7),
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right_rounded, color: ConstColor.gold),
            ],
          ),
        ),
      ),
    );
  }
}
