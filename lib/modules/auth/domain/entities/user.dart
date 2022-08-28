import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String id, name, email;
  final String? pic;

  const User(
      {required this.id, required this.name, required this.email, this.pic});
  @override
  List<Object?> get props => [id, name, email, pic];
}
