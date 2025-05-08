class SimpleResponse {
  bool error;
  String message;

  SimpleResponse({required this.error, required this.message});

  factory SimpleResponse.fromJson(Map<String, dynamic> json) =>
      SimpleResponse(error: json["error"], message: json["message"]);

  Map<String, dynamic> toJson() => {"error": error, "message": message};
}
