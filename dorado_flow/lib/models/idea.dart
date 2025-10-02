class Idea {
  final String id;
  final String title;
  final String description;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final List<String> tags;
  final bool isFavorite;
  final String? category;

  Idea({
    required this.id,
    required this.title,
    required this.description,
    required this.createdAt,
    this.updatedAt,
    required this.tags,
    required this.isFavorite,
    this.category,
  });

  Idea copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? createdAt,
    DateTime? updatedAt,
    List<String>? tags,
    bool? isFavorite,
    String? category,
  }) {
    return Idea(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      tags: tags ?? this.tags,
      isFavorite: isFavorite ?? this.isFavorite,
      category: category ?? this.category,
    );
  }
}

