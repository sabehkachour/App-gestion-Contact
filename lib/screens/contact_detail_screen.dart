import 'dart:io';
import 'package:flutter/material.dart';
import '../models/contact.dart';

class ContactDetailScreen extends StatelessWidget {
  final Contact contact;

  ContactDetailScreen({required this.contact});

  void _showActionSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.phone, color: Colors.teal),
              title: Text("Appeler"),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.message, color: Colors.teal),
              title: Text("Envoyer un SMS"),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.email, color: Colors.teal),
              title: Text("Envoyer un email"),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            SizedBox(height: 8),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Annuler"),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          "Détails du contact",
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
            icon: Icon(Icons.share),
            onPressed: () => _showActionSheet(context),
            tooltip: "Actions",
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(24),
        child: Column(
          children: [
            
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.teal[300]!,
                  width: 3,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 8,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: CircleAvatar(
                radius: 60,
                backgroundColor: contact.photo.isEmpty ? Colors.teal[100] : null,
                backgroundImage: contact.photo.isNotEmpty 
                    ? FileImage(File(contact.photo)) 
                    : null,
                child: contact.photo.isEmpty
                    ? Icon(
                        Icons.person,
                        size: 50,
                        color: Colors.teal[700],
                      )
                    : null,
              ),
            ),

            SizedBox(height: 24),
            Text(
              contact.name,
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.teal[900],
              ),
              textAlign: TextAlign.center,
            ),

            SizedBox(height: 8),

            if (contact.group.isNotEmpty) ...[
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.teal[50],
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.teal[100]!),
                ),
                child: Text(
                  contact.group,
                  style: TextStyle(
                    color: Colors.teal[700],
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              SizedBox(height: 8),
            ],

            SizedBox(height: 32),

            
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: EdgeInsets.all(0),
                child: Column(
                  children: [
                    
                    _buildInfoItem(
                      icon: Icons.phone_iphone_rounded,
                      label: "Téléphone",
                      value: contact.phone,
                      color: Colors.green,
                      onTap: () {
                        
                      },
                    ),
                    Divider(height: 1, indent: 60),
                    
                    _buildInfoItem(
                      icon: Icons.email_rounded,
                      label: "Email",
                      value: contact.email,
                      color: Colors.blue,
                      onTap: () {
                      
                      },
                    ),
                    
                    
                    if (contact.address.isNotEmpty) ...[
                      Divider(height: 1, indent: 60),
                      _buildInfoItem(
                        icon: Icons.location_on_rounded,
                        label: "Adresse",
                        value: contact.address,
                        color: Colors.orange,
                        onTap: () {
                          
                        },
                      ),
                    ],
                    
                    
                    if (contact.notes.isNotEmpty) ...[
                      Divider(height: 1, indent: 60),
                      _buildInfoItem(
                        icon: Icons.note_rounded,
                        label: "Notes",
                        value: contact.notes,
                        color: Colors.purple,
                        onTap: null,
                        isMultiline: true,
                      ),
                    ],
                  ],
                ),
              ),
            ),

            SizedBox(height: 24),

            
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Actions rapides",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[800],
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildActionButton(
                        icon: Icons.phone,
                        label: "Appeler",
                        color: Colors.green,
                        onTap: () {
            
                        },
                      ),
                      _buildActionButton(
                        icon: Icons.message,
                        label: "SMS",
                        color: Colors.blue,
                        onTap: () {
                          
                        },
                      ),
                      _buildActionButton(
                        icon: Icons.email,
                        label: "Email",
                        color: Colors.orange,
                        onTap: () {
                          
                        },
                      ),
                      _buildActionButton(
                        icon: Icons.share,
                        label: "Partager",
                        color: Colors.purple,
                        onTap: () => _showActionSheet(context),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            
            SizedBox(height: 24),
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.teal[50],
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.teal[100]!),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildStatItem("Contact", "Ajouté", "Aujourd'hui"),
                  _buildStatItem("Dernier", "Appel", "Jamais"),
                  _buildStatItem("Total", "Interactions", "0"),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoItem({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
    required VoidCallback? onTap,
    bool isMultiline = false,
  }) {
    return ListTile(
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: color, size: 20),
      ),
      title: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          color: Colors.grey[600],
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: isMultiline
          ? Text(
              value,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[800],
                fontWeight: FontWeight.w500,
              ),
            )
          : Text(
              value,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[800],
                fontWeight: FontWeight.w500,
              ),
              overflow: TextOverflow.ellipsis,
            ),
      onTap: onTap,
      trailing: onTap != null
          ? Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey[400])
          : null,
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Column(
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: IconButton(
            icon: Icon(icon, color: color),
            onPressed: onTap,
          ),
        ),
        SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[700],
          ),
        ),
      ],
    );
  }

  Widget _buildStatItem(String title, String subtitle, String value) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.teal[700],
          ),
        ),
        SizedBox(height: 4),
        Text(
          title,
          style: TextStyle(
            fontSize: 10,
            color: Colors.teal[600],
          ),
        ),
        Text(
          subtitle,
          style: TextStyle(
            fontSize: 10,
            color: Colors.teal[600],
          ),
        ),
      ],
    );
  }
}