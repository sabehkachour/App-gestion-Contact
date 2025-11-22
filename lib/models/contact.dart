class Contact {
  int? id;
  String name;
  String phone;
  String email;
  String address;
  String notes;
  String group;
  String photo;

  Contact({
    this.id,
    required this.name,
    required this.phone,
    required this.email,
    this.address = '',
    this.notes = '',
    this.group = '',
    this.photo = '',
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'email': email,
      'address': address,
      'notes': notes,
      'contact_group': group, // Note: nom de colonne différent
      'photo': photo,
    };
  }

  factory Contact.fromMap(Map<String, dynamic> map) {
    return Contact(
      id: map['id'],
      name: map['name'] ?? '',
      phone: map['phone'] ?? '',
      email: map['email'] ?? '',
      address: map['address'] ?? '',
      notes: map['notes'] ?? '',
      group: map['contact_group'] ?? '', // Mapping du nom de colonne
      photo: map['photo'] ?? '',
    );
  }
}
