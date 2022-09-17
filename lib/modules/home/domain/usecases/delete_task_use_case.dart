import 'package:dartz/dartz.dart';
import '../../../../app/common/usecase/base_use_case.dart';
import '../../../../app/errors/failure.dart';
import '../repositories/base_home_repository.dart';

class DeleteTaskUseCase
    implements BaseUseCase<Either<LocalFailure, bool>, int> {
  final BaseHomeRespository baseHomeRespository;

  DeleteTaskUseCase(this.baseHomeRespository);
  @override
  Future<Either<LocalFailure, bool>> call(int taskId) async =>
      await baseHomeRespository.deleteTask(taskId);
}
