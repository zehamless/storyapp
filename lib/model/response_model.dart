import 'package:equatable/equatable.dart';
import 'package:storyapp/model/story_model.dart';

import 'login_model.dart';

class Response extends Equatable {
  const Response({
    this.story,
    required this.error,
    required this.message,
    this.listStory,
    this.loginResult,
  });

  final bool? error;
  final String? message;
  final List<Story>? listStory;
  final LoginResult? loginResult;
  final Story? story;

  factory Response.fromJson(Map<String, dynamic> json) {
    return Response(
      error: json["error"],
      message: json["message"],
      story: json["story"] == null ? null : Story.fromJson(json["story"]),
      listStory:
          json["listStory"] == null
              ? []
              : List<Story>.from(
                json["listStory"]!.map((x) => Story.fromJson(x)),
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
