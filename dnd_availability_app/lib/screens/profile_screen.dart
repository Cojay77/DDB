import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/auth_service.dart';
/* import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io'; */

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final user = FirebaseAuth.instance.currentUser!;
  final AuthService _authService = AuthService();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _photoController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _nameController.text = user.displayName ?? '';
    _photoController.text = user.photoURL ?? '';
  }

  Future<void> _updateProfile() async {
    try {
      var displayName = _nameController.text.trim();
      await user.updateDisplayName(displayName);
      await user.updatePhotoURL(_photoController.text.trim());
      await _authService.setDisplayName(user, displayName);
      await user.reload(); // recharge l'utilisateur
      setState(() {});
      
    // met à jour l'affichage
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("✅ Profil mis à jour !")));
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("❌ Erreur : $e")));
    }
  }

  @override
  Widget build(BuildContext context) {
    final updatedUser = FirebaseAuth.instance.currentUser!;
    return Scaffold(
      appBar: AppBar(title: const Text("Mon profil")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            if (updatedUser.photoURL != null)
              CircleAvatar(
                backgroundImage: NetworkImage(updatedUser.photoURL!),
                radius: 40,
              ),
            const SizedBox(height: 16),
            Text("Adresse email : ${updatedUser.email ?? ''}"),
            const SizedBox(height: 24),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: "Pseudo"),
            ),
            /* const SizedBox(height: 12),
            TextField(
              controller: _photoController,
              decoration: const InputDecoration(
                labelText: "URL photo de profil",
              ),
            ), */
            /* const SizedBox(height: 20),
                        TextButton.icon(
              onPressed: _pickAndUploadImage,
              icon: const Icon(Icons.image),
              label: const Text("Changer la photo depuis la galerie"),
            ), */
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _updateProfile,
              child: const Text("Enregistrer les modifications"),
            ),
          ],
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
            //Image.asset('assets/dragon.png', height: 40, fit: BoxFit.contain),
            Icon(Icons.whatshot),
            const Spacer(flex: 1),
            Text("D&D&B - release build", style: TextStyle(fontSize: 9))
          ],
        ),
      ),
    );
  }

  /* Future<void> _pickAndUploadImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final File file = File(pickedFile.path);
      final fileName = 'profile_${user.uid}.jpg';
      final storageRef = FirebaseStorage.instance.ref().child(
        'profile_pictures/$fileName',
      );

      try {
        final uploadTask = await storageRef.putFile(file);
        final downloadURL = await uploadTask.ref.getDownloadURL();

        await user.updatePhotoURL(downloadURL);
        await user.reload();
        setState(() {});
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("✅ Photo de profil mise à jour")),
        );
      } catch (e) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("❌ Erreur de chargement : $e")));
      }
    }
  } */
}
