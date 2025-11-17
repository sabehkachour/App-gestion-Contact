import 'package:flutter/material.dart';
import '../db/database_helper.dart';
import 'home_screen.dart';

class RegisterScreen extends StatelessWidget {
  final TextEditingController nameCtrl = TextEditingController();
  final TextEditingController emailCtrl = TextEditingController();
  final TextEditingController phoneCtrl = TextEditingController();
  final DatabaseHelper db = DatabaseHelper();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Inscription")),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
                controller: nameCtrl,
                decoration: InputDecoration(labelText: "Nom")),
            TextField(
                controller: emailCtrl,
                decoration: InputDecoration(labelText: "Email")),
            TextField(
                controller: phoneCtrl,
                decoration: InputDecoration(labelText: "Téléphone")),
            SizedBox(height: 20),
            ElevatedButton(
              child: Text("S'inscrire"),
              onPressed: () async {
                if (await db.userExists(emailCtrl.text)) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Email déjà utilisé")),
                  );
                  return;
                }
                await db.insertUser({
                  "name": nameCtrl.text,
                  "email": emailCtrl.text,
                  "phone": phoneCtrl.text,
                });
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => HomeScreen()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
