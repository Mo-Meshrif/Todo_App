import 'package:dartz/dartz.dart';
import '../../../../app/errors/failure.dart';
import '../entities/user.dart';
import '../usecases/login_use_case.dart';
import '../usecases/signup_use_case.dart';

abstract class BaseAuthRepository {
  Future<Either<Failure, User>> signIn(LoginInputs userInputs);
  Future<Either<Failure, User>> signUp(SignUpInputs userInputs);
  Future<Either<Failure, bool>> forgetPassword(String email);
  Future<Either<Failure, User>> facebook();
  Future<Either<Failure, User>> twitter();
  Future<Either<Failure, User>> google();
  Future<Either<Failure, void>> logout();
}
