import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'firebase_options.dart';
import 'services/analytics_service.dart';
import 'providers/auth_provider.dart';
import 'providers/missing_person_provider.dart';
import 'providers/reward_provider.dart';
import 'providers/admin_provider.dart';
import 'screens/home_screen.dart';
import 'screens/login_screen.dart';
import 'l10n/l10n.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  } catch (e) { }
  runApp(const MokhtafounApp());
}

class MokhtafounApp extends StatelessWidget {
  const MokhtafounApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => MissingPersonProvider()),
        ChangeNotifierProvider(create: (_) => RewardProvider()),
        ChangeNotifierProvider(create: (_) => AdminProvider()),
      ],
      child: MaterialApp(
        title: 'Mokhtafoun',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: L10n.supported,
        initialRoute: '/',
        routes: {'/': (_) => const AuthGate(), '/home': (_) => const HomeScreen()},
      ),
    );
  }
}

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});
  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    return StreamBuilder<bool>(
      stream: auth.authStateChanges,
      builder: (context, s) {
        if (s.connectionState == ConnectionState.waiting) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }
        final ok = s.data ?? false;
        if (ok) { AnalyticsService.view('Home'); return const HomeScreen(); }
        return const LoginScreen();
      },
    );
  }
}
