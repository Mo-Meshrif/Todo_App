import 'package:equatable/equatable.dart';

class AuthUser extends Equatable {
  final String id, name, email;
  final String? pic;
  final String deviceToken;

  const AuthUser({
    required this.id,
    required this.name,
    required this.email,
    this.pic,
    required this.deviceToken,
  });
  @override
  List<Object?> get props => [id, name, email, pic,deviceToken];
}
