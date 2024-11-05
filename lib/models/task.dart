class Task {
  final String id;
  String description;
  bool isCompleted;

  Task({
    required this.id,
    required this.description,
    this.isCompleted = false,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'description': description,
    'isCompleted': isCompleted,
  };

  factory Task.fromJson(Map<String, dynamic> json) => Task(
    id: json['id'],
    description: json['description'],
    isCompleted: json['isCompleted'] ?? false,
  );
}

class TaskSection {
  final String title;
  final List<Task> tasks;

  TaskSection({
    required this.title,
    required this.tasks,
  });

  double get completionPercentage {
    if (tasks.isEmpty) return 0;
    final completedTasks = tasks.where((task) => task.isCompleted).length;
    return (completedTasks / tasks.length) * 100;
  }
}