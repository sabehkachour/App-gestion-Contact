import 'package:flutter/material.dart';
import '../db/database_helper.dart';

class AddContactScreen extends StatefulWidget {
  @override
  _AddContactScreenState createState() => _AddContactScreenState();
}

class _AddContactScreenState extends State<AddContactScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nameCtrl = TextEditingController();
  final TextEditingController phoneCtrl = TextEditingController();
  final TextEditingController emailCtrl = TextEditingController();
  final DatabaseHelper db = DatabaseHelper();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Ajouter un contact")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: nameCtrl,
                decoration: InputDecoration(labelText: "Nom"),
                validator: (value) {
                  if (value == null || value.isEmpty) return "Entrez un nom";
                  return null;
                },
              ),
              SizedBox(height: 15),
              TextFormField(
                controller: phoneCtrl,
                decoration: InputDecoration(labelText: "Téléphone"),
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.isEmpty) return "Entrez un numéro";
                  return null;
                },
              ),
              SizedBox(height: 15),
              TextFormField(
                controller: emailCtrl,
                decoration: InputDecoration(labelText: "Email"),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) return "Entrez un email";
                  return null;
                },
              ),
              SizedBox(height: 30),
              ElevatedButton(
                child: Text("Enregistrer"),
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    await db.insertContact({
                      "name": nameCtrl.text,
                      "phone": phoneCtrl.text,
                      "email": emailCtrl.text,
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Contact ajouté avec succès")));
                    Navigator.pop(context);
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}