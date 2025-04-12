import 'package:dnd_availability_app/screens/profile_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';
import 'screens/admin_screen.dart';
import 'screens/game_sessions_screen.dart';
import 'screens/splash_screen.dart';

class DndApp extends StatefulWidget {
  const DndApp({super.key});

  @override
  State<DndApp> createState() => _DndAppState();
}

class _DndAppState extends State<DndApp> {
  Widget? initialScreen;

  @override
  void initState() {
    super.initState();
    _checkAuth();
  }

  void _checkAuth() async {
    await Future.delayed(const Duration(milliseconds: 100));
    final user = FirebaseAuth.instance.currentUser;
    setState(() {
      initialScreen = user != null ? const HomeScreen() : const LoginScreen();
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'D&D&B',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        cardTheme: CardTheme(
          color: Colors.white,
          elevation: 3,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.deepPurple,
          foregroundColor: Colors.white,
          centerTitle: true,
        ),
      ),
      locale: const Locale('fr', 'FR'),
      supportedLocales: const [Locale('fr', 'FR')],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      initialRoute: '/',
      routes: {
        '/login': (context) => const LoginScreen(),
        '/home': (context) => const HomeScreen(),
        '/admin': (context) => const AdminScreen(),
        '/sessions': (context) => const GameSessionsScreen(),
        '/splash': (context) => const SplashScreen(),
        '/profile': (context) => const ProfileScreen(),
      },
      home:
          initialScreen ??
          const Scaffold(body: Center(child: CircularProgressIndicator())),
    );
  }
}
