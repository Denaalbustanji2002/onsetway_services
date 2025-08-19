import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../home/widget/appbar_widget.dart';

class SettingNav extends StatefulWidget {
  const SettingNav({super.key});

  @override
  State<SettingNav> createState() => _SettingNavState();
}

class _SettingNavState extends State<SettingNav> {
  @override
  Widget build(BuildContext context) {
    return  OWScaffold(

      title: 'Settings',
      // logoAsset: 'assets/logo/croped2 (1).png', // make sure this path exists in pubspec.yaml
      body: const Center(

        child: Text(
          'settings',
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
      ),
    ) ;
  }
}
