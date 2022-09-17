import 'package:dartz/dartz.dart';
import '../../../../app/errors/exception.dart';
import '../../../../app/errors/failure.dart';
import '../../../../app/helper/helper_functions.dart';
import '../../domain/entities/task_to_do.dart';
import '../../domain/repositories/base_home_repository.dart';
import '../../domain/usecases/get_tasks_use_case.dart';
import '../datasources/local_data_source.dart';
import '../models/task_model.dart';

class HomeRepositoryImpl implements BaseHomeRespository {
  final BaseHomeLocalDataSource baseHomeLocalDataSource;

  HomeRepositoryImpl(this.baseHomeLocalDataSource);
  @override
  Future<Either<LocalFailure, bool>> addTask(TaskTodo taskTodo) async {
    try {
      final DateTime date = DateTime.parse(taskTodo.date);
      final isAdded = await baseHomeLocalDataSource.addTask(
        TaskModel(
          uid: HelperFunctions.getSavedUser().id,
          name: taskTodo.name,
          description: taskTodo.description,
          category: taskTodo.category,
          date: taskTodo.date,
          day: date.day,
          week: date.weekday,
          month: date.month,
          year: date.year,
          priority: taskTodo.priority,
          important: taskTodo.important,
          done: taskTodo.done,
          later: taskTodo.later,
        ),
      );
      return Right(isAdded);
    } on LocalExecption catch (failure) {
      return Left(LocalFailure(msg: failure.msg));
    }
  }

  @override
  Future<Either<LocalFailure, List<TaskTodo>>> getTasks(
      TaskInputs parameter) async {
    try {
      final tasks = await baseHomeLocalDataSource.getTasks(parameter);
      return Right(tasks);
    } on LocalExecption catch (failure) {
      return Left(LocalFailure(msg: failure.msg));
    }
  }

  @override
  Future<Either<LocalFailure, TaskTodo?>> editTask(TaskTodo taskTodo) async {
    try {
      final DateTime date = DateTime.parse(taskTodo.date);
      final task = await baseHomeLocalDataSource.editTask(
        TaskModel(
          id: taskTodo.id,
          uid: HelperFunctions.getSavedUser().id,
          name: taskTodo.name,
          description: taskTodo.description,
          category: taskTodo.category,
          date: taskTodo.date,
          day: date.day,
          week: date.weekday,
          month: date.month,
          year: date.year,
          priority: taskTodo.priority,
          important: taskTodo.important,
          done: taskTodo.done,
          later: taskTodo.later,
        ),
      );
      return Right(task);
    } on LocalExecption catch (failure) {
      return Left(LocalFailure(msg: failure.msg));
    }
  }

  @override
  Future<Either<LocalFailure, bool>> deleteTask(int taskId) async {
    try {
      final isDeleted = await baseHomeLocalDataSource.deleteTask(taskId);
      return Right(isDeleted);
    } on LocalExecption catch (failure) {
      return Left(LocalFailure(msg: failure.msg));
    }
  }
}
