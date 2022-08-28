import 'package:dartz/dartz.dart';

import '../../../../app/errors/failure.dart';
import '../../../../app/usecase/base_use_case.dart';
import '../entities/user.dart';
import '../repositories/base_auth_repository.dart';

class TwitterUseCase
    implements BaseUseCase<Either<Failure, User>, NoParameters> {
  final BaseAuthRepository baseAuthRepository;

  TwitterUseCase(this.baseAuthRepository);

  @override
  Future<Either<Failure, User>> call(NoParameters parameters) =>
      baseAuthRepository.twitter();
}
