import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../app/errors/failure.dart';
import '/modules/auth/domain/entities/user.dart';
import '../repositories/base_auth_repository.dart';
import '/app/usecase/base_use_case.dart';

class LoginUseCase implements BaseUseCase<Either<Failure, User>, LoginInputs> {
  final BaseAuthRepository baseAuthRepository;
  LoginUseCase(this.baseAuthRepository);

  @override
  Future<Either<Failure, User>> call(LoginInputs parameters) =>
      baseAuthRepository.signIn(parameters);
}

class LoginInputs extends Equatable {
  final String name, password;
  const LoginInputs({
    required this.name,
    required this.password,
  });

  @override
  List<Object?> get props => [name, password];
}
