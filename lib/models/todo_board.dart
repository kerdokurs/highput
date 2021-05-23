class TodoBoard {
  final String title;
  final String description;

  TodoBoard(this.title, this.description);

  TodoBoard.fromJson(Map<String, dynamic> json) : title = json['title'] ?? 'Untitled', description = json['description'] ?? '';

  Map<String, dynamic> toJson() => {
    'title': title,
    'description': description,
  };
}
