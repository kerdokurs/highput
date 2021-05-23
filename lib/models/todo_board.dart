class TodoBoard {
  final String title;
  final String description;
  final DateTime createdAt;

  TodoBoard(this.title, this.description, this.createdAt);

  TodoBoard.fromJson(Map<String, dynamic> json) : title = json['title'] ?? 'Untitled', description = json['description'] ?? '', createdAt = DateTime.now();

  Map<String, dynamic> toJson() => {
    'title': title,
    'description': description,
    'created_at': createdAt,
  };
}
