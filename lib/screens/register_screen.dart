import 'package:flutter/material.dart';
import '../db/database_helper.dart';
import 'home_screen.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController usernameCtrl = TextEditingController();
  final TextEditingController emailCtrl = TextEditingController();
  final TextEditingController passwordCtrl = TextEditingController();
  final TextEditingController confirmPasswordCtrl = TextEditingController();
  final DatabaseHelper db = DatabaseHelper();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Créer un compte"),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              SizedBox(height: 20),
              Icon(
                Icons.person_add,
                size: 60,
                color: Colors.teal,
              ),
              SizedBox(height: 20),
              Text(
                "Nouveau compte",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 30),
              TextFormField(
                controller: usernameCtrl,
                decoration: InputDecoration(
                  labelText: "Nom d'utilisateur",
                  prefixIcon: Icon(Icons.person),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty)
                    return "Entrez un nom d'utilisateur";
                  if (value.length < 3)
                    return "Le nom doit contenir au moins 3 caractères";
                  return null;
                },
              ),
              SizedBox(height: 15),
              TextFormField(
                controller: emailCtrl,
                decoration: InputDecoration(
                  labelText: "Email",
                  prefixIcon: Icon(Icons.email),
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty)
                    return "Entrez votre email";
                  if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value))
                    return "Email invalide";
                  return null;
                },
              ),
              SizedBox(height: 15),
              TextFormField(
                controller: passwordCtrl,
                decoration: InputDecoration(
                  labelText: "Mot de passe",
                  prefixIcon: Icon(Icons.lock),
                ),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty)
                    return "Entrez un mot de passe";
                  if (value.length < 4) return "Mot de passe trop court";
                  return null;
                },
              ),
              SizedBox(height: 15),
              TextFormField(
                controller: confirmPasswordCtrl,
                decoration: InputDecoration(
                  labelText: "Confirmer le mot de passe",
                  prefixIcon: Icon(Icons.lock_outline),
                ),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty)
                    return "Confirmez votre mot de passe";
                  if (value != passwordCtrl.text)
                    return "Les mots de passe ne correspondent pas";
                  return null;
                },
              ),
              SizedBox(height: 30),
              _isLoading
                  ? CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          setState(() {
                            _isLoading = true;
                          });
                          
                          await db.insertUser({
                            "username": usernameCtrl.text,
                            "email": emailCtrl.text,
                            "password": passwordCtrl.text,
                          });
                          
                          setState(() {
                            _isLoading = false;
                          });
                          
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("Compte créé avec succès"),
                              backgroundColor: Colors.green,
                            ),
                          );
                          
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (_) => HomeScreen()),
                          );
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 40, vertical: 12),
                        child: Text(
                          "Créer le compte",
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}