class Link {
  final int id;
  final String name;
  final String description;
  final String link;
  final DateTime createdAt;

  Link({
    required this.id,
    required this.name,
    required this.description,
    required this.link,
    required this.createdAt,
  });

  factory Link.fromMap(Map<String, dynamic> map) {
    return Link(
      id: map['id'],
      name: map['name'],
      description: map['description'],
      link: map['link'],
      createdAt: DateTime.parse(map['created_at']),
    );
  }
}
