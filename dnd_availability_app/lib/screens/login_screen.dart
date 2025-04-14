import 'package:dnd_availability_app/utils/platform_utils_stub.dart';
import 'package:dnd_availability_app/utils/pwa_utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import 'dart:js' as js;

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController displayNameController = TextEditingController();

  final AuthService _authService = AuthService();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    displayNameController.dispose();
    super.dispose();
  }

  Future<void> handleLogin() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    final user = await _authService.login(email, password);

    if (user != null) {
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      showDialog(
        context: context,
        builder:
            (_) => const AlertDialog(
              title: Text("Erreur"),
              content: Text("Connexion échouée."),
            ),
      );
    }
  }

  Future<void> handleSignUp() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();
    final displayName = displayNameController.text.trim();

    final user = await _authService.register(email, password, displayName);

    if (user != null) {
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      showDialog(
        context: context,
        builder:
            (_) => const AlertDialog(
              title: Text("Erreur"),
              content: Text("Inscription échouée."),
            ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text("Connexion", style: TextStyle(fontSize: 24)),
                const SizedBox(height: 20),
                TextField(
                  controller: emailController,
                  decoration: const InputDecoration(labelText: 'Email'),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(labelText: 'Mot de passe'),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: displayNameController,
                  decoration: const InputDecoration(
                    labelText: 'Pseudo (si tu crées un compte)',
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: handleLogin,
                  child: const Text("Se connecter"),
                ),
                const SizedBox(height: 10),
                TextButton(
                  onPressed: handleSignUp,
                  child: const Text("Créer un compte"),
                ),
                if ((kIsWeb || isStandalone()) && !isIOSBrowser()) ...[
                  ElevatedButton(
                    onPressed: () {
                      js.context.callMethod('promptInstall');
                    },
                    child: const Text("Installer l’application"),
                  ),
                ],
                if (kIsWeb && isIOSBrowser()) ...[
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(Icons.ios_share, color: Colors.white, size: 28),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              "Pour installer l'application :\nAppuyez sur "
                              "le bouton de partage (en bas de l'écran), "
                              "puis \"Ajouter à l’écran d’accueil\".",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Container(
        height: 60,
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: Colors.black,
          border: const Border(top: BorderSide(color: Colors.grey)),
        ),
        child: Row(
          children: [
            Image.asset('assets/logo.png', height: 40, fit: BoxFit.contain),
            const Spacer(flex: 1),
            Text("D&D&B - release build", style: TextStyle(fontSize: 9)),
          ],
        ),
      ),
    );
  }
}
