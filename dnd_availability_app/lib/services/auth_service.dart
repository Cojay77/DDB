import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseDatabase _db = FirebaseDatabase.instance;

  // Inscription
  Future<User?> register(String email, String password, String username) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user = result.user;
      await user?.updateDisplayName(username);

      if (user != null) {
          await _db.ref("users/${user.uid}").set({
          "email": user.email,
          "isAdmin": false
        });
      }

      return user;
    } catch (e) {
      print("Register error: $e");
      return null;
    }
  }

  // Connexion
  Future<User?> login(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return result.user;
    } catch (e) {
      print("Login error: $e");
      return null;
    }
  }

  Future<bool> isUserAdmin(String uid) async {
    final db = FirebaseDatabase.instance;
    final snapshot = await db.ref("users/$uid/isAdmin").get();

    if (snapshot.exists) {
      return snapshot.value == true;
    }
    return false;
  }

  Future<void> logout() async {
    await _auth.signOut();
  }

  User? get currentUser => _auth.currentUser;
}
