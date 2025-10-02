enum KnowledgeCategory {
  photography,
  videography,
  music,
  art,
  business,
  marketing,
  technical,
  inspiration,
  other,
}

class KnowledgeArticle {
  final String id;
  final String title;
  final String content;
  final String? summary;
  final KnowledgeCategory category;
  final List<String> tags;
  final String? author;
  final String? source;
  final String? url;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final bool isFavorite;
  final bool isBookmarked;
  final int readCount;

  KnowledgeArticle({
    required this.id,
    required this.title,
    required this.content,
    this.summary,
    required this.category,
    required this.tags,
    this.author,
    this.source,
    this.url,
    required this.createdAt,
    this.updatedAt,
    required this.isFavorite,
    required this.isBookmarked,
    required this.readCount,
  });

  KnowledgeArticle copyWith({
    String? id,
    String? title,
    String? content,
    String? summary,
    KnowledgeCategory? category,
    List<String>? tags,
    String? author,
    String? source,
    String? url,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isFavorite,
    bool? isBookmarked,
    int? readCount,
  }) {
    return KnowledgeArticle(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      summary: summary ?? this.summary,
      category: category ?? this.category,
      tags: tags ?? this.tags,
      author: author ?? this.author,
      source: source ?? this.source,
      url: url ?? this.url,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isFavorite: isFavorite ?? this.isFavorite,
      isBookmarked: isBookmarked ?? this.isBookmarked,
      readCount: readCount ?? this.readCount,
    );
  }
}