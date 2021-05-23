class Todo {
  final String content;
  final bool isDone;

  Todo(this.content, this.isDone);

  Todo.fromJson(Map<String, dynamic> json)
      : content = json['content'],
        isDone = json['isDone'];

  Map<String, dynamic> toJson() => {
    'content': content,
    'isDone': isDone,
  };
}