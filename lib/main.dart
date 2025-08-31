import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:onsetway_services/core/theme/app_theme.dart';
import 'package:onsetway_services/core/network/http_client.dart';

import 'package:onsetway_services/services/auth_api.dart';
import 'package:onsetway_services/services/profile_api.dart';

import 'package:onsetway_services/cubit/auth_cubit.dart';
// NOTE: Provide Person/CompanyProfileCubits inside their respective pages, not here.

import 'package:onsetway_services/presentation/splash_screen.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Centralized networking stack
  final http = HttpClient(); // your authorized client wrapper
  final authApi = AuthApi(http); // depends on HttpClient
  final profileApi = ProfileApi(http); // shared client (inject where needed)

  FlutterError.onError = (details) {
    FlutterError.dumpErrorToConsole(details);
  };

  runApp(MyApp(http: http, authApi: authApi, profileApi: profileApi));
}

class MyApp extends StatelessWidget {
  const MyApp({
    super.key,
    required this.http,
    required this.authApi,
    required this.profileApi,
  });

  final HttpClient http;
  final AuthApi authApi;
  final ProfileApi profileApi;

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<HttpClient>.value(value: http),
        RepositoryProvider<AuthApi>.value(value: authApi),
        RepositoryProvider<ProfileApi>.value(value: profileApi),
      ],
      child: MultiBlocProvider(
        providers: [
          // AuthCubit can be global; profile cubits should be provided at the screen level
          BlocProvider<AuthCubit>(create: (_) => AuthCubit(authApi)),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          navigatorKey: navigatorKey,
          title: 'OnsetWay',
          theme: appTheme(), // your gold/black palette
          home: const SplashScreen(),
          // Ensure the first frame is black to avoid white flash
          builder: (context, child) => ColoredBox(
            color: Colors.black,
            child: SizedBox.expand(child: child ?? const SizedBox.shrink()),
          ),
        ),
      ),
    );
  }
}
