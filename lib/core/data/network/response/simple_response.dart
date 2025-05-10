import 'package:freezed_annotation/freezed_annotation.dart';

part 'simple_response.freezed.dart';
part 'simple_response.g.dart';

@freezed
abstract class SimpleResponse with _$SimpleResponse {
  const factory SimpleResponse({required bool error, required String message}) =
      _SimpleResponse;

  factory SimpleResponse.fromJson(Map<String, dynamic> json) =>
      _$SimpleResponseFromJson(json);
}
