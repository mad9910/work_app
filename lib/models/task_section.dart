import 'task.dart';

class TaskSection {
  final String title;
  final List<Task> tasks;

  TaskSection({
    required this.title,
    required this.tasks,
  });

  Map<String, dynamic> toJson() => {
    'title': title,
    'tasks': tasks.map((task) => task.toJson()).toList(),
  };

  factory TaskSection.fromJson(Map<String, dynamic> json) {
    return TaskSection(
      title: json['title'],
      tasks: (json['tasks'] as List)
          .map((task) => Task.fromJson(task as Map<String, dynamic>))
          .toList(),
    );
  }
}
