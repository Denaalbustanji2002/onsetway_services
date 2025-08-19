import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../home/widget/appbar_widget.dart';

class Appointment extends StatefulWidget {
  const Appointment({super.key});

  @override
  State<Appointment> createState() => _AppointmentState();
}

class _AppointmentState extends State<Appointment> {
  @override
  Widget build(BuildContext context) {
    return  OWScaffold(

      title: 'Appointment',
      // logoAsset: 'assets/logo/croped2 (1).png', // make sure this path exists in pubspec.yaml
      body: const Center(

        child: Text(
          'appointment',
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
      ),
    ) ;
  }
}
