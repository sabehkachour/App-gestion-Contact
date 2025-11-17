import 'package:flutter/material.dart';
import '../db/database_helper.dart';
import 'add_contact_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final DatabaseHelper db = DatabaseHelper();
  List<Map<String, dynamic>> users = [];
  List<Map<String, dynamic>> filteredUsers = [];
  TextEditingController searchCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadUsers();
    searchCtrl.addListener(_search);
  }

  void _loadUsers() async {
    users = await db.getUsers();
    setState(() {
      filteredUsers = users;
    });
  }

  void _search() {
    final query = searchCtrl.text.toLowerCase();
    setState(() {
      filteredUsers = users
          .where((u) =>
              u['name'].toLowerCase().contains(query) ||
              u['email'].toLowerCase().contains(query))
          .toList();
    });
  }

  void _deleteUser(int id) async {
    final database = await db.db;
    await database.delete('users', where: 'id = ?', whereArgs: [id]);
    _loadUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Liste des utilisateurs")),
      body: Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            TextField(
              controller: searchCtrl,
              decoration: InputDecoration(
                  labelText: "Rechercher", suffixIcon: Icon(Icons.search)),
            ),
            Expanded(
              child: filteredUsers.isEmpty
                  ? Center(child: Text("Aucun utilisateur trouvé"))
                  : ListView.builder(
                      itemCount: filteredUsers.length,
                      itemBuilder: (context, index) {
                        final user = filteredUsers[index];
                        return ListTile(
                          title: Text(user['name']),
                          subtitle: Text(user['email']),
                          trailing: IconButton(
                            icon: Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _deleteUser(user['id']),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => AddContactScreen()),
          );
          _loadUsers();
        },
      ),
    );
  }
}
