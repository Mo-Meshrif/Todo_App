import 'package:dartz/dartz.dart';
import '/app/services/network_services.dart';
import '../../../../app/errors/exception.dart';
import '../../../../app/errors/failure.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/base_auth_repository.dart';
import '../../domain/usecases/login_use_case.dart';
import '../../domain/usecases/signup_use_case.dart';
import '../datasources/remote_data_source.dart';

class AuthRepositoryImpl implements BaseAuthRepository {
  final BaseAuthRemoteDataSource baseAuthRemoteDataSource;
  final NetworkServices networkServices;

  AuthRepositoryImpl(
    this.baseAuthRemoteDataSource,
    this.networkServices,
  );

  @override
  Future<Either<Failure, User>> signIn(LoginInputs userInputs) async {
    if (await networkServices.isConnected()) {
      try {
        final user = await baseAuthRemoteDataSource.signIn(userInputs);
        return Right(user);
      } on ServerExecption catch (failure) {
        return Left(ServerFailure(msg: failure.msg));
      }
    } else {
      return const Left(ServerFailure(msg: 'NO_INTERNET_CONNECTION'));
    }
  }

  @override
  Future<Either<Failure, User>> signUp(SignUpInputs userInputs) async {
    if (await networkServices.isConnected()) {
      try {
        final user = await baseAuthRemoteDataSource.signUp(userInputs);
        return Right(user);
      } on ServerExecption catch (failure) {
        return Left(ServerFailure(msg: failure.msg));
      }
    } else {
      return const Left(ServerFailure(msg: 'NO_INTERNET_CONNECTION'));
    }
  }

  @override
  Future<Either<Failure, bool>> forgetPassword(String email) async {
    if (await networkServices.isConnected()) {
      try {
        final bool isRest = await baseAuthRemoteDataSource.forgetPassord(email);
        return Right(isRest);
      } on ServerExecption catch (failure) {
        return Left(ServerFailure(msg: failure.msg));
      }
    } else {
      return const Left(ServerFailure(msg: 'NO_INTERNET_CONNECTION'));
    }
  }

  @override
  Future<Either<Failure, User>> facebook() async {
    if (await networkServices.isConnected()) {
      try {
        final user = await baseAuthRemoteDataSource.facebook();
        return Right(user);
      } on ServerExecption catch (failure) {
        return Left(ServerFailure(msg: failure.msg));
      }
    } else {
      return const Left(ServerFailure(msg: 'NO_INTERNET_CONNECTION'));
    }
  }

  @override
  Future<Either<Failure, User>> twitter() async {
    if (await networkServices.isConnected()) {
      try {
        final user = await baseAuthRemoteDataSource.twitter();
        return Right(user);
      } on ServerExecption catch (failure) {
        return Left(ServerFailure(msg: failure.msg));
      }
    } else {
      return const Left(ServerFailure(msg: 'NO_INTERNET_CONNECTION'));
    }
  }

  @override
  Future<Either<Failure, User>> google() async {
    if (await networkServices.isConnected()) {
      try {
        final user = await baseAuthRemoteDataSource.google();
        return Right(user);
      } on ServerExecption catch (failure) {
        return Left(ServerFailure(msg: failure.msg));
      }
    } else {
      return const Left(ServerFailure(msg: 'NO_INTERNET_CONNECTION'));
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    if (await networkServices.isConnected()) {
      try {
        return Right(await baseAuthRemoteDataSource.logout());
      } on ServerExecption catch (failure) {
        return Left(ServerFailure(msg: failure.msg));
      }
    } else {
      return const Left(ServerFailure(msg: 'NO_INTERNET_CONNECTION'));
    }
  }
}
