part of 'home_bloc.dart';

abstract class HomeState extends Equatable {
  const HomeState();
}

class HomeInitial extends HomeState {
  @override
  List<Object?> get props => [];
}

class HomeTranstion extends HomeState {
  @override
  List<Object?> get props => [];
}

class AddTaskLoading extends HomeState {
  @override
  List<Object?> get props => [];
}

class AddTaskLoaded extends HomeState {
  final bool isAdded;
  const AddTaskLoaded({required this.isAdded});

  @override
  List<Object?> get props => [isAdded];
}

class DailyTaskLoading extends HomeState {
  @override
  List<Object?> get props => [];
}

class DailyTaskLoaded extends HomeState {
  final List<TaskTodo> dailyList;

  const DailyTaskLoaded({required this.dailyList});

  @override
  List<Object?> get props => [dailyList];
}

class WeeklyTaskLoading extends HomeState {
  @override
  List<Object?> get props => [];
}

class WeeklyTaskLoaded extends HomeState {
  final List<TaskTodo> weeklyList;
  const WeeklyTaskLoaded({required this.weeklyList});

  @override
  List<Object?> get props => [weeklyList];
}

class MonthlyTaskLoading extends HomeState {
  @override
  List<Object?> get props => [];
}

class MonthlyTaskLoaded extends HomeState {
  final List<TaskTodo> monthlyList;
  const MonthlyTaskLoaded({required this.monthlyList});

  @override
  List<Object?> get props => [monthlyList];
}

class EditTaskLoading extends HomeState {
  @override
  List<Object?> get props => [];
}

class EditTaskLoaded extends HomeState {
  final TaskTodo? task;
  const EditTaskLoaded({required this.task});

  @override
  List<Object?> get props => [task];
}

class DeleteTaskLoading extends HomeState {
  @override
  List<Object?> get props => [];
}

class DeleteTaskLLoaded extends HomeState {
  final bool isDeleted;
  const DeleteTaskLLoaded({required this.isDeleted});

  @override
  List<Object?> get props => [isDeleted];
}

class SearchedTaskLoading extends HomeState {
  @override
  List<Object?> get props => [];
}

class SearchedTaskLoaded extends HomeState {
  final List<TaskTodo> searchedList;
  const SearchedTaskLoaded({required this.searchedList});

  @override
  List<Object?> get props => [searchedList];
}

class HomeFailure extends HomeState {
  final String msg;
  const HomeFailure({required this.msg});

  @override
  List<Object?> get props => [msg];
}
