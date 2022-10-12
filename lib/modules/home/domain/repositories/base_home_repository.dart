import 'package:dartz/dartz.dart';
import '../../../../app/errors/failure.dart';
import '../entities/task_to_do.dart';
import '../usecases/get_tasks_use_case.dart';

abstract class BaseHomeRespository {
  Future<Either<LocalFailure, bool>> addTask(TaskTodo taskTodo);
  Future<Either<LocalFailure, List<TaskTodo>>> getTasks(TaskInputs parameter);
  Future<Either<LocalFailure, TaskTodo?>> editTask(TaskTodo taskTodo);
  Future<Either<LocalFailure, int>> deleteTask(int taskId);
}
