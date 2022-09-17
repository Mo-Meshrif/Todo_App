import 'package:dartz/dartz.dart';
import '../../../../app/common/usecase/base_use_case.dart';
import '../../../../app/errors/failure.dart';
import '../entities/task_to_do.dart';
import '../repositories/base_home_repository.dart';

class EditTaskUseCase
    implements BaseUseCase<Either<LocalFailure, TaskTodo?>, TaskTodo> {
  final BaseHomeRespository baseHomeRespository;

  EditTaskUseCase(this.baseHomeRespository);
  @override
  Future<Either<LocalFailure, TaskTodo?>> call(TaskTodo taskTodo) =>
      baseHomeRespository.editTask(taskTodo);
}
