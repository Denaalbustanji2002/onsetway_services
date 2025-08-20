import 'package:flutter/material.dart';
import 'package:onsetway_services/presentation/splash_screen.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      navigatorKey: navigatorKey,
      title: 'OnsetWay',
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.black, // يخلي الخلفية سوداء من البداية
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const SplashScreen(),
      builder: (context, child) => ColoredBox(
        color: Colors.black, // تأكيد أن أول إطار أسود
        child: SizedBox.expand(child: child),
      ),
    );
  }
}
