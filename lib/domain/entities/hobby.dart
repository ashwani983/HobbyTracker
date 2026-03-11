class Hobby {
  final String id;
  final String name;
  final String? description;
  final String category;
  final String iconName;
  final int color;
  final DateTime createdAt;
  final bool isArchived;

  const Hobby({
    required this.id,
    required this.name,
    this.description,
    required this.category,
    required this.iconName,
    required this.color,
    required this.createdAt,
    this.isArchived = false,
  });

  Hobby copyWith({
    String? name,
    String? description,
    String? category,
    String? iconName,
    int? color,
    bool? isArchived,
  }) {
    return Hobby(
      id: id,
      name: name ?? this.name,
      description: description ?? this.description,
      category: category ?? this.category,
      iconName: iconName ?? this.iconName,
      color: color ?? this.color,
      createdAt: createdAt,
      isArchived: isArchived ?? this.isArchived,
    );
  }
}
