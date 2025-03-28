class Response {
  Response({
    required this.error,
    required this.message,
    required this.loginResult,
  });

  final bool? error;
  final String? message;
  final LoginResult? loginResult;

  factory Response.fromJson(Map<String, dynamic> json) {
    return Response(
      error: json["error"],
      message: json["message"],
      loginResult:
          json["loginResult"] == null
              ? null
              : LoginResult.fromJson(json["loginResult"]),
    );
  }

  Map<String, dynamic> toJson() => {
    "error": error,
    "message": message,
    "loginResult": loginResult?.toJson(),
  };
}

class LoginResult {
  LoginResult({required this.userId, required this.name, required this.token});

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
}
