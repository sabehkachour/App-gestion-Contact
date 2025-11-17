class Contact {
  int? id;
  String name;
  String phone;
  String email;

  Contact({
    this.id,
    required this.name,
    required this.phone,
    required this.email,
  });

  Map<String, dynamic> toMap() {
    return {'id': id, 'name': name, 'phone': phone, 'email': email};
  }
}
