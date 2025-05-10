import 'package:freezed_annotation/freezed_annotation.dart';

part 'setting.freezed.dart';

@freezed
abstract class Setting with _$Setting {
  const factory Setting({required bool isDark, required String locale}) = _Setting;
}
