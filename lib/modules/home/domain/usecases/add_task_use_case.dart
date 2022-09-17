import 'package:dartz/dartz.dart';
import '../../../../app/common/usecase/base_use_case.dart';
import '../../../../app/errors/failure.dart';
import '../entities/task_to_do.dart';
import '../repositories/base_home_repository.dart';

class AddTaskUseCase
    implements BaseUseCase<Either<LocalFailure, bool>, TaskTodo> {
  final BaseHomeRespository baseHomeRespository;

  AddTaskUseCase(this.baseHomeRespository);
  @override
  Future<Either<LocalFailure, bool>> call(TaskTodo taskTodo) =>
      baseHomeRespository.addTask(taskTodo);
}
