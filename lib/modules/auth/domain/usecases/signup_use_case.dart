import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../app/errors/failure.dart';
import '../../../../app/usecase/base_use_case.dart';
import '../entities/user.dart';
import '../repositories/base_auth_repository.dart';

class SignUpUseCase implements BaseUseCase<Either<Failure, User>, SignUpInputs> {
  final BaseAuthRepository baseAuthRepository;
  SignUpUseCase(this.baseAuthRepository);

  @override
  Future<Either<Failure, User>> call(SignUpInputs parameters) =>
      baseAuthRepository.signUp(parameters);
}

class SignUpInputs extends Equatable {
  final String name, email, password;
  const SignUpInputs({
    required this.name,
    required this.email,
    required this.password,
  });

  @override
  List<Object?> get props => [name, password];
}