part of 'home_bloc.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object> get props => [];
}

class AddTaskEvent extends HomeEvent {
  final TaskTodo taskTodo;
  const AddTaskEvent({required this.taskTodo});
}

class GetDailyTasksEvent extends HomeEvent {}

class GetWeeklyTasksEvent extends HomeEvent {}

class GetMonthlyTasksEvent extends HomeEvent {
  final DateTime date;

  const GetMonthlyTasksEvent({required this.date});
}

class EditTaskEvent extends HomeEvent {
  final TaskTodo taskTodo;
  const EditTaskEvent({required this.taskTodo});
}

class DeleteTaskEvent extends HomeEvent {
  final int taskId;
  const DeleteTaskEvent({required this.taskId});
}

class GetSearchedTasksEvent extends HomeEvent {
  final String searchedVal;

  const GetSearchedTasksEvent({required this.searchedVal});
}

class ClearSearchListEvent extends HomeEvent {}

class GetCustomTasksEvent extends HomeEvent {
  final String type;
  const GetCustomTasksEvent(this.type);
}