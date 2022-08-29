part of 'auth_bloc.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthPopUpLoading extends AuthState {}
class AuthSuccess extends AuthState {
  final AuthUser user;
  const AuthSuccess({required this.user});
}

class AuthRestSuccess extends AuthState {
  final bool isRested;
  const AuthRestSuccess({required this.isRested});
}

class AuthFailure extends AuthState {
  final String msg;
  final bool isPopup;
  const AuthFailure({
    required this.msg,
    this.isPopup = false,
  });
}

class AuthSocialPass extends AuthState {
  final AuthCredential authCredential;
  const AuthSocialPass({required this.authCredential});
}
