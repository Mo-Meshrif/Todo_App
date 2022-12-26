import '/modules/auth/domain/entities/user.dart';

class UserModel extends AuthUser {
  const UserModel({
    required String id,
    required String name,
    required String email,
    required String deviceToken,
    String? pic,
  }) : super(
            id: id,
            name: name,
            email: email,
            pic: pic,
            deviceToken: deviceToken);
  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        id: json['id'],
        name: json['name'],
        email: json['email'],
        pic: json['pic'],
        deviceToken: json['deviceToken'],
      );
  toJson() => {
        'id': id,
        'name': name,
        'email': email,
        'pic': pic,
        'deviceToken': deviceToken,
      };
}
