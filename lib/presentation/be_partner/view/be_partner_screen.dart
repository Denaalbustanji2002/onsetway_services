import 'package:flutter/material.dart';

import '../../home/widget/appbar_widget.dart';

class BePartnerScreen extends StatefulWidget {
  const BePartnerScreen({super.key});

  @override
  State<BePartnerScreen> createState() => _BePartnerScreenState();
}

class _BePartnerScreenState extends State<BePartnerScreen> {
  @override
  Widget build(BuildContext context) {
    return OWScaffold(
      title: 'Be Partner ',
      // logoAsset: 'assets/logo/croped2 (1).png', // make sure this path exists in pubspec.yaml
      body: const Center(
        child: Text(
          'Be Partner',
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
      ),
    );
  }
}
