import 'package:flutter/material.dart';
import '../db/database_helper.dart';
import 'add_contact_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final DatabaseHelper db = DatabaseHelper();
  List<Map<String, dynamic>> contacts = [];

  @override
  void initState() {
    super.initState();
    loadContacts();
  }

  Future<void> loadContacts() async {
    var data = await db.getContacts();
    setState(() {
      contacts = data;
    });
  }

  Future<void> deleteContact(int id) async {
    await db.deleteContact(id);
    loadContacts();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Contact supprimé")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Mes contacts"),
      ),
      body: contacts.isEmpty
          ? Center(child: Text("Aucun contact pour le moment"))
          : ListView.builder(
              itemCount: contacts.length,
              itemBuilder: (context, index) {
                final contact = contacts[index];
                return Card(
                  margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  child: ListTile(
                    title: Text(contact['name']),
                    subtitle: Text('${contact['phone']} | ${contact['email']}'),
                    trailing: IconButton(
                      icon: Icon(Icons.delete, color: Colors.red),
                      onPressed: () => deleteContact(contact['id']),
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => AddContactScreen()),
          );
          loadContacts();
        },
      ),
    );
  }
}