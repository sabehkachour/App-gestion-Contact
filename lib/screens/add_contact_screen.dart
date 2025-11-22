import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../db/database_helper.dart';

class AddContactScreen extends StatefulWidget {
  final Map<String, dynamic>? contactData;

  AddContactScreen({this.contactData});

  @override
  _AddContactScreenState createState() => _AddContactScreenState();
}

class _AddContactScreenState extends State<AddContactScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nameCtrl = TextEditingController();
  final TextEditingController phoneCtrl = TextEditingController();
  final TextEditingController emailCtrl = TextEditingController();

  final DatabaseHelper db = DatabaseHelper();
  bool _isLoading = false;

  bool get isEditing => widget.contactData != null;

  String? _validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return 'Veuillez entrer un numéro de téléphone';
    }

    final phoneRegex = RegExp(r'^[0-9]{8}$');
    if (!phoneRegex.hasMatch(value)) {
      return 'Le numéro doit contenir exactement 8 chiffres';
    }

    return null;
  }

  Future<void> _saveContact() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        final contactData = {
          "name": nameCtrl.text.trim(),
          "phone": phoneCtrl.text.trim(),
          "email": emailCtrl.text.trim().toLowerCase(),
        };

        if (isEditing) {
          await db.updateContact(
            widget.contactData!['id'],
            contactData,
          );

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("✅ Contact modifié avec succès"),
              backgroundColor: Colors.green,
              behavior: SnackBarBehavior.floating,
            ),
          );
        } else {
          await db.insertContact(contactData);

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("✅ Contact ajouté avec succès"),
              backgroundColor: Colors.green,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }

        await Future.delayed(Duration(milliseconds: 500));
        Navigator.pop(context, true); 
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("❌ Erreur: ${e.toString()}"),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    if (isEditing) {
      nameCtrl.text = widget.contactData!['name'];
      phoneCtrl.text = widget.contactData!['phone'];
      emailCtrl.text = widget.contactData!['email'];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          isEditing ? "Modifier le contact" : "Nouveau contact",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.teal[700],
        foregroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: _isLoading
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.teal),
                  ),
                  SizedBox(height: 16),
                  Text(
                    isEditing ? "Modification..." : "Ajout en cours...",
                    style: TextStyle(
                      color: Colors.teal,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            )
          : SingleChildScrollView(
              padding: EdgeInsets.all(24),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.all(16),
                      margin: EdgeInsets.only(bottom: 24),
                      decoration: BoxDecoration(
                        color: Colors.teal[50],
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.teal[100]!),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            isEditing ? Icons.edit : Icons.person_add,
                            color: Colors.teal[700],
                            size: 24,
                          ),
                          SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              isEditing
                                  ? "Modifiez les informations du contact"
                                  : "Ajoutez un nouveau contact à votre liste",
                              style: TextStyle(
                                color: Colors.teal[800],
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    _buildFormField(
                      controller: nameCtrl,
                      label: "Nom complet",
                      hint: "Ex: Jean Dupont",
                      icon: Icons.person_outline,
                      validator: (value) =>
                          value!.isEmpty ? "Le nom est obligatoire" : null,
                    ),

                    SizedBox(height: 20),

                   
                    _buildFormField(
                      controller: phoneCtrl,
                      label: "Numéro de téléphone",
                      hint: "8 chiffres (ex: 55123456)",
                      icon: Icons.phone_iphone_outlined,
                      keyboardType: TextInputType.number,
                      maxLength: 8,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      validator: _validatePhone,
                    ),

                    SizedBox(height: 20),

                    
                    _buildFormField(
                      controller: emailCtrl,
                      label: "Adresse email",
                      hint: "Ex: jean.dupont@email.com",
                      icon: Icons.email_outlined,
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'L\'email est obligatoire';
                        }
                        if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                          return 'Format d\'email invalide';
                        }
                        return null;
                      },
                    ),

                    SizedBox(height: 40),
                    Row(
                      children: [
                       
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => Navigator.pop(context),
                            style: OutlinedButton.styleFrom(
                              padding: EdgeInsets.symmetric(vertical: 16),
                              side: BorderSide(color: Colors.grey[400]!),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: Text(
                              "Annuler",
                              style: TextStyle(
                                color: Colors.grey[700],
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 16),

                        Expanded(
                          child: ElevatedButton(
                            onPressed: _isLoading ? null : _saveContact,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.teal[700],
                              foregroundColor: Colors.white,
                              padding: EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 2,
                            ),
                            child: _isLoading
                                ? SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                          Colors.white),
                                    ),
                                  )
                                : Text(
                                    isEditing ? "Modifier" : "Ajouter",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                          ),
                        ),
                      ],
                    ),

                    
                    Padding(
                      padding: EdgeInsets.only(top: 20),
                      child: Text(
                        "* Champs obligatoires",
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 12,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildFormField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    required String? Function(String?)? validator,
    TextInputType keyboardType = TextInputType.text,
    int? maxLength,
    List<TextInputFormatter>? inputFormatters,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "$label *",
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: Colors.grey[800],
            fontSize: 14,
          ),
        ),
        SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey[300]!),
            color: Colors.white,
          ),
          child: TextFormField(
            controller: controller,
            keyboardType: keyboardType,
            maxLength: maxLength,
            inputFormatters: inputFormatters,
            validator: validator,
            decoration: InputDecoration(
              hintText: hint,
              prefixIcon: Icon(icon, color: Colors.teal[600]),
              border: InputBorder.none,
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              counterText: "",
              errorStyle: TextStyle(
                color: Colors.red[600],
                fontSize: 12,
              ),
            ),
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[800],
            ),
          ),
        ),
      ],
    );
  }
}
