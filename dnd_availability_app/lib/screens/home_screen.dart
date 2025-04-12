import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final AuthService _authService = AuthService();
  bool isAdmin = false;
  String? userEmail;
  String? displayName;

  @override
  void initState() {
    super.initState();
    final user = _authService.currentUser;
    userEmail = user?.email;
    displayName = user?.displayName;
    if (user != null) {
      _authService.isUserAdmin(user.uid).then((value) {
        setState(() {
          isAdmin = value;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Accueil"),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await _authService.logout();
              Navigator.pushReplacementNamed(context, '/login');
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Bienvenue, ${displayName ?? 'utilisateur'} !"),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/sessions');
              },
              child: const Text("Voir les sessions de jeu"),
            ),
            if (isAdmin)
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/admin');
                },
                child: const Text("Espace Admin"),
              ),
            const SizedBox(height: 10),
            IconButton(
              icon: const Icon(Icons.person),
              alignment: Alignment.bottomCenter,
              onPressed: () {
                Navigator.pushNamed(context, '/profile');
              },
            ),
            const Text("Profil")
          ],
        ),
      ),
    );
  }
}
