import 'package:equatable/equatable.dart';

class LoginResult extends Equatable {
  const LoginResult({required this.userId, required this.name, required this.token});

  final String? userId;
  final String? name;
  final String? token;

  factory LoginResult.fromJson(Map<String, dynamic> json) {
    return LoginResult(
      userId: json["userId"],
      name: json["name"],
      token: json["token"],
    );
  }

  Map<String, dynamic> toJson() => {
    "userId": userId,
    "name": name,
    "token": token,
  };

  @override
  List<Object?> get props => [userId, name, token];
}
