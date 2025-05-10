import 'dart:convert';

import 'package:freezed_annotation/freezed_annotation.dart';

part 'user.freezed.dart';
part 'user.g.dart';

@freezed
abstract class User with _$User {
  const factory User({
    String? name,
    String? email,
    String? password,
    String? token,
  }) = _User;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
}

extension UserExtension on User {
  String toJsonString() => json.encode(toJson());

  static User fromJsonString(String source) {
    if (source.isEmpty) {
      throw const FormatException('Empty JSON string');
    }
    return User.fromJson(json.decode(source) as Map<String, dynamic>);
  }
}
