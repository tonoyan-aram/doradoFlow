class Location {
  final String id;
  final String name;
  final String? address;
  final String? description;
  final double? latitude;
  final double? longitude;
  final List<String> photos;
  final List<Contact> contacts;
  final List<String> tags;
  final DateTime createdAt;
  final String? notes;

  Location({
    required this.id,
    required this.name,
    this.address,
    this.description,
    this.latitude,
    this.longitude,
    required this.photos,
    required this.contacts,
    required this.tags,
    required this.createdAt,
    this.notes,
  });

  Location copyWith({
    String? id,
    String? name,
    String? address,
    String? description,
    double? latitude,
    double? longitude,
    List<String>? photos,
    List<Contact>? contacts,
    List<String>? tags,
    DateTime? createdAt,
    String? notes,
  }) {
    return Location(
      id: id ?? this.id,
      name: name ?? this.name,
      address: address ?? this.address,
      description: description ?? this.description,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      photos: photos ?? this.photos,
      contacts: contacts ?? this.contacts,
      tags: tags ?? this.tags,
      createdAt: createdAt ?? this.createdAt,
      notes: notes ?? this.notes,
    );
  }
}

class Contact {
  final String id;
  final String name;
  final String? phone;
  final String? email;
  final String? role;
  final String? notes;

  Contact({
    required this.id,
    required this.name,
    this.phone,
    this.email,
    this.role,
    this.notes,
  });

  Contact copyWith({
    String? id,
    String? name,
    String? phone,
    String? email,
    String? role,
    String? notes,
  }) {
    return Contact(
      id: id ?? this.id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      role: role ?? this.role,
      notes: notes ?? this.notes,
    );
  }
}