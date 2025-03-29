import 'package:equatable/equatable.dart';
import 'package:storyapp/model/list_story_model.dart';

import 'login_model.dart';

class Response extends Equatable {
  const Response({
    required this.error,
    required this.message,
    this.listStory,
    this.loginResult,
  });

  final bool? error;
  final String? message;
  final List<ListStory>? listStory;
  final LoginResult? loginResult;

  factory Response.fromJson(Map<String, dynamic> json) {
    return Response(
      error: json["error"],
      message: json["message"],
      listStory:
          json["listStory"] == null
              ? []
              : List<ListStory>.from(
                json["listStory"]!.map((x) => ListStory.fromJson(x)),
              ),
      loginResult:
          json["loginResult"] == null
              ? null
              : LoginResult.fromJson(json["loginResult"]),
    );
  }

  Map<String, dynamic> toJson() => {
    "error": error,
    "message": message,
    "listStory": listStory?.map((x) => x.toJson()).toList(),
    "loginResult": loginResult?.toJson(),
  };

  @override
  List<Object?> get props => [error, message, listStory, loginResult];
}
