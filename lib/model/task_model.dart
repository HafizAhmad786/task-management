class TaskModel {
  final String? title;
  final String? description;
  final String? priority;
  final DateTime? date;
  final String? time;
  final String? userId;
  String? taskId;
  final String? type;

  TaskModel({
    this.title,
    this.description,
    this.date,
    this.priority,
    this.time,
    this.userId,
    this.taskId,
    this.type
  });

  factory TaskModel.fromJson(Map<String,dynamic> json){
    return TaskModel(
      title: json['title'],
      description: json['description'],
      priority: json['priority'],
      date: DateTime.parse(json['date']),
      time: json['time'],
      userId: json['userId'],
      taskId: json['taskId'],
      type: json['type']
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'priority': priority,
      'date': date?.toIso8601String(),
      'time': time,
      'userId': userId,
      "taskId": taskId,
      "type": type
    };
  }

}

enum Priority {
  high,
  medium,
  low,
  empty
}