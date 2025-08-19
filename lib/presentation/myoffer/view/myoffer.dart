import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../home/widget/appbar_widget.dart';

class MyOffer extends StatefulWidget {
  const MyOffer({super.key});

  @override
  State<MyOffer> createState() => _MyOfferState();
}

class _MyOfferState extends State<MyOffer> {
  @override
  Widget build(BuildContext context) {
    return OWScaffold(

      title: 'My Offer ',
      // logoAsset: 'assets/logo/croped2 (1).png', // make sure this path exists in pubspec.yaml
      body: const Center(

        child: Text(
          'offers',
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
      ),
    ) ;
  }
}
