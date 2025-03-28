import 'dart:convert';
import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String? email;
  final String? password;

  const User({this.email, this.password});

  @override
  String toString() => 'User(email: $email, password: $password)';

  Map<String, dynamic> toMap() {
    return {'email': email, 'password': password};
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(email: map['email'], password: map['password']);
  }

  String toJson() => json.encode(toMap());

  factory User.fromJson(String source) => User.fromMap(json.decode(source));

  @override
  List<Object?> get props => [email, password];
}
