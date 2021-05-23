class Reminder {
  final String title;
  final String time;
  final DateTime createdAt;

  Reminder(this.title, this.time, this.createdAt);

  Reminder.fromJson(Map<String, dynamic> json)
      : title = json['title'] ?? 'Untitled',
        time = json['time'],
        createdAt = json['created_at'].toDate();

  Map<String, dynamic> toJson() => {
        'title': title,
        'time': time,
        'created_at': createdAt.toString(),
      };
}
