import 'dart:io';
import 'package:flutter/material.dart';
import '../models/contact.dart';

class ContactDetailScreen extends StatelessWidget {
  final Contact contact;
  
  ContactDetailScreen({required this.contact});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Détails du contact"),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            // Photo
            if (contact.photo.isNotEmpty)
              Center(
                child: CircleAvatar(
                  radius: 60,
                  backgroundImage: FileImage(File(contact.photo)),
                ),
              ),
            if (contact.photo.isEmpty)
              Center(
                child: CircleAvatar(
                  radius: 60,
                  backgroundColor: Colors.teal.shade100,
                  child: Icon(Icons.person, size: 50, color: Colors.teal),
                ),
              ),
            
            SizedBox(height: 20),
            
            // Nom
            Text(
              contact.name,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            
            SizedBox(height: 30),
            
            // Informations
            Card(
              elevation: 3,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    _buildInfoRow(Icons.phone, "Téléphone", contact.phone),
                    _buildDivider(),
                    _buildInfoRow(Icons.email, "Email", contact.email),
                    if (contact.address.isNotEmpty) ...[
                      _buildDivider(),
                      _buildInfoRow(Icons.location_on, "Adresse", contact.address),
                    ],
                    if (contact.group.isNotEmpty) ...[
                      _buildDivider(),
                      _buildInfoRow(Icons.group, "Groupe", contact.group),
                    ],
                  ],
                ),
              ),
            ),
            
            // Notes
            if (contact.notes.isNotEmpty) ...[
              SizedBox(height: 20),
              Card(
                elevation: 3,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.note, color: Colors.teal),
                          SizedBox(width: 8),
                          Text(
                            "Notes",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Text(
                        contact.notes,
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ),
            ],
            
            SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
  
  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: Colors.teal, size: 24),
        SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.shade600,
                ),
              ),
              SizedBox(height: 4),
              Text(
                value,
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      ],
    );
  }
  
  Widget _buildDivider() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Divider(height: 1),
    );
  }
}