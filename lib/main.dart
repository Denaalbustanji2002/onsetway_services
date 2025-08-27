import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:onsetway_services/core/theme/app_theme.dart';
import 'package:onsetway_services/cubit/auth_cubit.dart';

import 'package:onsetway_services/presentation/splash_screen.dart';
import 'package:onsetway_services/services/apiclient.dart';

// Theme + network/auth wiring

import 'core/network/http_client.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  final http = HttpClient();
  final authApi = AuthApi(http);

  runApp(MyApp(authApi: authApi));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.authApi});
  final AuthApi authApi;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [BlocProvider(create: (_) => AuthCubit(authApi))],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        navigatorKey: navigatorKey,
        title: 'OnsetWay',
        theme: appTheme(), // uses your gold/black palette
        home: const SplashScreen(),
        // Ensures the very first frame is black (prevents white flicker)
        builder: (context, child) => ColoredBox(
          color: Colors.black,
          child: SizedBox.expand(child: child ?? const SizedBox.shrink()),
        ),
      ),
    );
  }
}
