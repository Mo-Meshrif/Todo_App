import 'package:dartz/dartz.dart';
import '/app/usecase/base_use_case.dart';
import '../../../../app/errors/failure.dart';
import '../repositories/base_auth_repository.dart';

class LogoutUseCase implements BaseUseCase<Either<Failure, void>, NoParameters> {
  final BaseAuthRepository baseAuthRepository;
  LogoutUseCase(this.baseAuthRepository);

  @override
  Future<Either<Failure, void>> call(NoParameters parameters) => baseAuthRepository.logout();
}