class Task {
  String title;
  DateTime deadline;
  bool isCompleted;
  DateTime? completionDate;

  Task({
    required this.title,
    required this.deadline,
    this.isCompleted = false,
    this.completionDate,
  });

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'deadline': deadline.toIso8601String(),
      'isCompleted': isCompleted,
      'completionDate': completionDate?.toIso8601String(),
    };
  }

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      title: json['title'],
      deadline: DateTime.parse(json['deadline']),
      isCompleted: json['isCompleted'],
      completionDate: json['completionDate'] != null
          ? DateTime.parse(json['completionDate'])
          : null,
    );
  }
}
