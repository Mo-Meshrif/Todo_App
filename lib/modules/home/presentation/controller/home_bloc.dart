import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../app/errors/failure.dart';
import '../../domain/entities/task_to_do.dart';
import '../../domain/usecases/add_task_use_case.dart';
import '../../domain/usecases/delete_task_use_case.dart';
import '../../domain/usecases/edit_task_use_case.dart';
import '../../domain/usecases/get_tasks_use_case.dart';
part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final AddTaskUseCase addTaskUseCase;
  final GetTasksUseCase getTasksUseCase;
  final EditTaskUseCase editTaskUseCase;
  final DeleteTaskUseCase deleteTaskUseCase;
  HomeBloc({
    required this.addTaskUseCase,
    required this.getTasksUseCase,
    required this.editTaskUseCase,
    required this.deleteTaskUseCase,
  }) : super(HomeInitial()) {
    on<AddTaskEvent>(_addTask);
    on<GetDailyTasksEvent>(_getDailyTasks);
    on<GetWeeklyTasksEvent>(_getWeeklyTasks);
    on<GetMonthlyTasksEvent>(_getMonthlyTasks);
    on<EditTaskEvent>(_editTask);
    on<DeleteTaskEvent>(_deleteTask);
    on<GetSearchedTasksEvent>(_getSearchedTasks);
    on<GetCustomTasksEvent>(_getCustomTasks);
    on<ClearSearchListEvent>(
      (event, emit) => emit(HomeTranstion()),
    );
  }

  FutureOr<void> _addTask(AddTaskEvent event, Emitter<HomeState> emit) async {
    emit(AddTaskLoading());
    final result = await addTaskUseCase(event.taskTodo);
    result.fold(
      (failure) => emit(HomeFailure(msg: failure.msg)),
      (isAdded) => emit(AddTaskLoaded(isAdded: isAdded)),
    );
  }

  FutureOr<void> _getDailyTasks(
      GetDailyTasksEvent event, Emitter<HomeState> emit) async {
    emit(DailyTaskLoading());
    DateTime date = DateTime.now();
    final result = await _getTasks(
      TaskInputs(
        whereArgs: [date.day, date.weekday, date.month, date.year],
        where: 'day=? AND week=? AND month=? AND year=?',
      ),
    );

    result.fold(
      (failure) => emit(HomeFailure(msg: failure.msg)),
      (tasks) => emit(DailyTaskLoaded(dailyList: tasks)),
    );
  }

  FutureOr<void> _getWeeklyTasks(
      GetWeeklyTasksEvent event, Emitter<HomeState> emit) async {
    emit(WeeklyTaskLoading());
    DateTime date = DateTime.now();
    final result = await _getTasks(
      TaskInputs(
        whereArgs: [date.weekday, date.month, date.year],
        where: 'week=? AND month=? AND year=?',
      ),
    );
    result.fold(
      (failure) => emit(HomeFailure(msg: failure.msg)),
      (tasks) => emit(WeeklyTaskLoaded(weeklyList: tasks)),
    );
  }

  FutureOr<void> _getMonthlyTasks(
      GetMonthlyTasksEvent event, Emitter<HomeState> emit) async {
    emit(MonthlyTaskLoading());
    DateTime date = event.date;
    final result = await _getTasks(
      TaskInputs(
        whereArgs: [date.month, date.year],
        where: 'month=? AND year=?',
      ),
    );
    result.fold(
      (failure) => emit(HomeFailure(msg: failure.msg)),
      (tasks) => emit(MonthlyTaskLoaded(monthlyList: tasks)),
    );
  }

  Future<Either<LocalFailure, List<TaskTodo>>> _getTasks(
          TaskInputs taskInputs) =>
      getTasksUseCase(taskInputs);

  FutureOr<void> _editTask(EditTaskEvent event, Emitter<HomeState> emit) async {
    emit(EditTaskLoading());
    final result = await editTaskUseCase(event.taskTodo);
    result.fold(
      (failure) => emit(HomeFailure(msg: failure.msg)),
      (task) => emit(EditTaskLoaded(task: task)),
    );
  }

  FutureOr<void> _deleteTask(
      DeleteTaskEvent event, Emitter<HomeState> emit) async {
    emit(DeleteTaskLoading());
    final result = await deleteTaskUseCase(event.taskId);
    result.fold(
      (failure) => emit(HomeFailure(msg: failure.msg)),
      (taskId) => emit(DeleteTaskLLoaded(taskId: taskId)),
    );
  }

  FutureOr<void> _getSearchedTasks(
      GetSearchedTasksEvent event, Emitter<HomeState> emit) async {
    emit(SearchedTaskLoading());
    final result = await _getTasks(
      TaskInputs(
        whereArgs: [event.searchedVal + '%'],
        where: 'name LIKE ?',
      ),
    );
    await Future.delayed(const Duration(seconds: 1), () {}).whenComplete(() {
      result.fold(
        (failure) => emit(HomeFailure(msg: failure.msg)),
        (tasks) => emit(SearchedTaskLoaded(searchedList: tasks)),
      );
    });
  }

  FutureOr<void> _getCustomTasks(
      GetCustomTasksEvent event, Emitter<HomeState> emit) async {
    emit(CustomTaskLoading());
    final result = await _getTasks(
      TaskInputs(
        whereArgs: const [1],
        where: event.type + '=?',
      ),
    );
    result.fold(
      (failure) => emit(HomeFailure(msg: failure.msg)),
      (tasks) => emit(CustomTaskLoaded(customList: tasks)),
    );
  }
}
