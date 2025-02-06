class Link {
  final int id;
  final String name;
  final String description;
  final String category;
  final String link;
  final DateTime createdAt;

  Link({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    required this.link,
    required this.createdAt,
  });

  factory Link.fromMap(Map<String, dynamic> map) {
    return Link(
      id: map['id'],
      name: map['name'],
      description: map['description'],
      category: map['category'],
      link: map['link'],
      createdAt: DateTime.parse(map['created_at']),
    );
  }
}
