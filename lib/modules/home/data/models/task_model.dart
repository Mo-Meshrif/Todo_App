import '/app/helper/extentions.dart';
import '../../../../app/helper/enums.dart';
import '../../domain/entities/task_to_do.dart';

class TaskModel extends TaskTodo {
  final String uid;
  final int day, week, month, year;
  const TaskModel({
    int? id,
    required this.uid,
    required String name,
    required String description,
    required String category,
    required String date,
    required this.day,
    required this.week,
    required this.month,
    required this.year,
    required TaskPriority priority,
    required bool important,
    required bool done,
    required bool later,
  }) : super(
          id: id,
          name: name,
          description: description,
          category: category,
          date: date,
          priority: priority,
          important: important,
          done: done,
          later: later,
        );
  factory TaskModel.fromJson(Map<String, dynamic> map) => TaskModel(
        id: map['id'],
        uid: map['uid'],
        name: map['name'],
        description: map['description'],
        category: map['category'],
        date: map['date'],
        day: map['day'],
        week: map['week'],
        month: map['month'],
        year: map['year'],
        priority: (map['priority'] as int).toPriority(),
        important: map['important'] == 1 ? true : false,
        done: map['done'] == 1 ? true : false,
        later: map['later'] == 1 ? true : false,
      );
  toJson() => {
        'uid': uid,
        'name': name,
        'description': description,
        'category': category,
        'date': date,
        'day': day,
        'week': week,
        'month': month,
        'year': year,
        'priority': priority.toInt(),
        'important': important ? 1 : 0,
        'done': done ? 1 : 0,
        'later': later ? 1 : 0,
      };
}
