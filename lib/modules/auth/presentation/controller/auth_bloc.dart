import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '/app/usecase/base_use_case.dart';
import '/modules/auth/domain/entities/user.dart';
import '/app/errors/failure.dart';
import '/modules/auth/domain/usecases/facebook_use_case.dart';
import '/modules/auth/domain/usecases/forget_passwod_use_case.dart';
import '/modules/auth/domain/usecases/google_use_case.dart';
import '/modules/auth/domain/usecases/twitter_use_case.dart';
import '../../domain/usecases/login_use_case.dart';
import '../../domain/usecases/signup_use_case.dart';
part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUseCase loginUseCase;
  final SignUpUseCase signUpUseCase;
  final ForgetPasswordUseCase forgetPasswordUseCase;
  final FacebookUseCase facebookUseCase;
  final TwitterUseCase twitterUseCase;
  final GoogleUseCase googleUseCase;
  AuthBloc({
    required this.loginUseCase,
    required this.signUpUseCase,
    required this.forgetPasswordUseCase,
    required this.facebookUseCase,
    required this.twitterUseCase,
    required this.googleUseCase,
  }) : super(AuthInitial()) {
    on<LoginEvent>(_login);
    on<SignUpEvent>(_signUp);
    on<ForgetPasswordEvent>(_forgetPassword);
    on<FacebookLoginEvent>(_facebookLogin);
    on<TwitterLoginEvent>(_twitterLogin);
    on<GoogleLoginEvent>(_googleLogin);
  }

  FutureOr<void> _login(LoginEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final Either<Failure, User> result = await loginUseCase(event.loginInputs);
    result.fold(
      (failure) => emit(AuthFailure(msg: failure.msg)),
      (user) => emit(AuthSuccess(user: user)),
    );
  }

  FutureOr<void> _signUp(SignUpEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final Either<Failure, User> result =
        await signUpUseCase(event.signUpInputs);
    result.fold(
      (failure) => emit(AuthFailure(msg: failure.msg)),
      (user) => emit(AuthSuccess(user: user)),
    );
  }

  FutureOr<void> _forgetPassword(
      ForgetPasswordEvent event, Emitter<AuthState> emit) async {
    emit(AuthPopUpLoading());
    final Either<Failure, bool> result =
        await forgetPasswordUseCase(event.email);
    result.fold(
      (failure) => emit(AuthFailure(msg: failure.msg)),
      (isRested) => emit(AuthRestSuccess(isRested: isRested)),
    );
  }

  FutureOr<void> _facebookLogin(
      FacebookLoginEvent event, Emitter<AuthState> emit) async {
    final Either<Failure, User> result =
        await facebookUseCase(const NoParameters());
    result.fold(
      (failure) => emit(AuthFailure(msg: failure.msg)),
      (user) => emit(AuthSuccess(user: user)),
    );
  }

  FutureOr<void> _twitterLogin(
      TwitterLoginEvent event, Emitter<AuthState> emit) async {
    final Either<Failure, User> result =
        await twitterUseCase(const NoParameters());
    result.fold(
      (failure) => emit(AuthFailure(msg: failure.msg)),
      (user) => emit(AuthSuccess(user: user)),
    );
  }

  FutureOr<void> _googleLogin(
      GoogleLoginEvent event, Emitter<AuthState> emit) async {
    final Either<Failure, User> result =
        await googleUseCase(const NoParameters());
    result.fold(
      (failure) => emit(AuthFailure(msg: failure.msg)),
      (user) => emit(AuthSuccess(user: user)),
    );
  }
}
