import 'package:dartz/dartz.dart';

import '../../../../app/errors/failure.dart';
import '../entities/user.dart';
import '../repositories/base_auth_repository.dart';
import '/app/usecase/base_use_case.dart';

class FacebookUseCase
    implements BaseUseCase<Either<Failure, User>, NoParameters> {
  final BaseAuthRepository baseAuthRepository;

  FacebookUseCase(this.baseAuthRepository);
  @override
  Future<Either<Failure, User>> call(NoParameters parameters) => baseAuthRepository.facebook();
}
