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
  TextEditingController searchCtrl = TextEditingController();
  String searchQuery = "";
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadContacts();
  }

  Future<void> _loadContacts() async {
    setState(() {
      _isLoading = true;
    });
    
    try {
      final data = await db.getContacts();
      setState(() {
        contacts = data;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      _showErrorSnackBar("Erreur lors du chargement des contacts");
    }
  }

  Future<void> _deleteContact(int id, String contactName) async {
    try {
      await db.deleteContact(id);
      await _loadContacts();
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(Icons.check_circle, color: Colors.white, size: 20),
              SizedBox(width: 8),
              Expanded(child: Text("Contact \"$contactName\" supprimé")),
            ],
          ),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
          action: SnackBarAction(
            label: "Annuler",
            textColor: Colors.white,
            onPressed: () {
           
            },
          ),
        ),
      );
    } catch (e) {
      _showErrorSnackBar("Erreur lors de la suppression");
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.error_outline, color: Colors.white, size: 20),
            SizedBox(width: 8),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Future<void> _confirmDelete(int id, String contactName) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.warning_amber, color: Colors.orange),
            SizedBox(width: 8),
            Text("Supprimer le contact"),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Voulez-vous vraiment supprimer le contact :"),
            SizedBox(height: 8),
            Text(
              "\"$contactName\"",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.teal,
              ),
            ),
            SizedBox(height: 4),
            Text(
              "Cette action est irréversible.",
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(
              "Annuler",
              style: TextStyle(color: Colors.grey[600]),
            ),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: Text("Supprimer"),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      _deleteContact(id, contactName);
    }
  }

  @override
  Widget build(BuildContext context) {
    final filteredContacts = contacts.where((contact) {
      final name = contact['name'].toString().toLowerCase();
      final phone = contact['phone'].toString().toLowerCase();
      final email = contact['email'].toString().toLowerCase();
      
      return name.contains(searchQuery) || 
             phone.contains(searchQuery) || 
             email.contains(searchQuery);
    }).toList();

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          "Mes Contacts",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.teal[700],
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _loadContacts,
            tooltip: "Actualiser",
          ),
        ],
      ),
      body: Column(
        children: [
          
          Container(
            padding: EdgeInsets.all(16),
            color: Colors.white,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: TextField(
                controller: searchCtrl,
                decoration: InputDecoration(
                  hintText: "Rechercher un contact...",
                  prefixIcon: Icon(Icons.search, color: Colors.teal[600]),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(horizontal: 16),
                ),
                onChanged: (value) {
                  setState(() {
                    searchQuery = value.toLowerCase();
                  });
                },
              ),
            ),
          ),

         
          if (searchQuery.isNotEmpty)
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              color: Colors.teal[50],
              child: Row(
                children: [
                  Icon(Icons.search, size: 16, color: Colors.teal[700]),
                  SizedBox(width: 8),
                  Text(
                    "${filteredContacts.length} contact(s) trouvé(s)",
                    style: TextStyle(
                      color: Colors.teal[800],
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Spacer(),
                  if (searchQuery.isNotEmpty)
                    TextButton(
                      onPressed: () {
                        searchCtrl.clear();
                        setState(() {
                          searchQuery = "";
                        });
                      },
                      child: Text(
                        "Effacer",
                        style: TextStyle(
                          color: Colors.teal[700],
                          fontSize: 12,
                        ),
                      ),
                    ),
                ],
              ),
            ),

          
          Expanded(
            child: _isLoading
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.teal),
                        ),
                        SizedBox(height: 16),
                        Text(
                          "Chargement des contacts...",
                          style: TextStyle(
                            color: Colors.teal,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  )
                : filteredContacts.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              searchQuery.isEmpty 
                                  ? Icons.contacts_outlined 
                                  : Icons.search_off,
                              size: 80,
                              color: Colors.grey[400],
                            ),
                            SizedBox(height: 16),
                            Text(
                              searchQuery.isEmpty
                                  ? "Aucun contact"
                                  : "Aucun contact trouvé",
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.grey[600],
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              searchQuery.isEmpty
                                  ? "Appuyez sur le bouton + pour ajouter un contact"
                                  : "Essayez avec d'autres termes de recherche",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.grey[500],
                              ),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        itemCount: filteredContacts.length,
                        itemBuilder: (context, index) {
                          final contact = filteredContacts[index];
                          
                          return _buildContactCard(contact);
                        },
                      ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => AddContactScreen()),
          );
          if (result == true) {
            _loadContacts();
          }
        },
        backgroundColor: Colors.teal[700],
        foregroundColor: Colors.white,
        child: Icon(Icons.add),
        elevation: 2,
      ),
    );
  }

  Widget _buildContactCard(Map<String, dynamic> contact) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: Colors.teal[100],
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.person,
            color: Colors.teal[700],
            size: 24,
          ),
        ),
        title: Text(
          contact['name'],
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16,
            color: Colors.grey[800],
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 4),
            Row(
              children: [
                Icon(Icons.phone, size: 14, color: Colors.grey[600]),
                SizedBox(width: 4),
                Text(
                  contact['phone'],
                  style: TextStyle(color: Colors.grey[600]),
                ),
              ],
            ),
            SizedBox(height: 2),
            Row(
              children: [
                Icon(Icons.email, size: 14, color: Colors.grey[600]),
                SizedBox(width: 4),
                Expanded(
                  child: Text(
                    contact['email'],
                    style: TextStyle(color: Colors.grey[600]),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            
            IconButton(
              icon: Icon(Icons.edit, size: 20),
              color: Colors.blue[600],
              onPressed: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => AddContactScreen(contactData: contact),
                  ),
                );
                if (result == true) {
                  _loadContacts();
                }
              },
              tooltip: "Modifier",
            ),
            
            
            IconButton(
              icon: Icon(Icons.delete, size: 20),
              color: Colors.red[600],
              onPressed: () => _confirmDelete(
                contact['id'], 
                contact['name']
              ),
              tooltip: "Supprimer",
            ),
          ],
        ),
      ),
    );
  }
}