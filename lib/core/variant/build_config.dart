import 'package:package_info_plus/package_info_plus.dart';

enum BuildVariant { free, paid }

class BuildConfig {
  static late final bool _isPaidVersion;
  static bool _initialized = false;

  static Future<void> initialize() async {
    if (_initialized) return;

    final packageInfo = await PackageInfo.fromPlatform();
    _isPaidVersion = packageInfo.packageName.contains(".paid");
    _initialized = true;
  }

  static bool get isPaidVersion {
    assert(_initialized, "BuildConfig must be initialized before use");
    return _isPaidVersion;
  }

  static bool get isFreeVersion => !isPaidVersion;

  static String get appName =>
      isPaidVersion ? "Storyqito Premium" : "Storyqito Free";

  static bool get canAddLocation => isPaidVersion;
}
