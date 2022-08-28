import 'package:dartz/dartz.dart';
import '../../../../app/errors/failure.dart';
import '../../../../app/usecase/base_use_case.dart';
import '../entities/user.dart';
import '../repositories/base_auth_repository.dart';

class GoogleUseCase implements BaseUseCase<Either<Failure, User>, NoParameters> {
  final BaseAuthRepository baseAuthRepository;

  GoogleUseCase(this.baseAuthRepository);

  @override
  Future<Either<Failure, User>> call(NoParameters parameters) => baseAuthRepository.google();
}
