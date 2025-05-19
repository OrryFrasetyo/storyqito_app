import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:universal_html/js.dart' as js;

class MapsEnvironment {
  static EnvironmentProvider _environmentProvider =
      DefaultEnvironmentProvider();
  static JsContextWrapper _jsContextWrapper = JsContextWrapper();

  static void injectDependencies({
    EnvironmentProvider? environmentProvider,
    JsContextWrapper? jsContextWrapper,
  }) {
    if (environmentProvider != null) {
      _environmentProvider = environmentProvider;
    }
    if (jsContextWrapper != null) {
      _jsContextWrapper = jsContextWrapper;
    }
  }

  static void resetDependencies() {
    _environmentProvider = DefaultEnvironmentProvider();
    _jsContextWrapper = JsContextWrapper();
  }

  static Future<void> initialize() async {
    if (!_environmentProvider.isWebPlatform) {
      await _environmentProvider.loadEnvFile("assets/.env");
    }
  }

  static String get geocodeMapsApiKey {
    if (_environmentProvider.isWebPlatform) {
      try {
        final apiKey = _jsContextWrapper.getApiKey();
        if (apiKey != null) {
          return apiKey;
        }
      } catch (e) {
        debugPrint("Error accessing env from JavaScript: $e");
      }
      return 'NO_API_KEY';
    } else {
      return _environmentProvider.getEnvValue(
        'GEOCODE_API_KEY',
        fallback: 'NO_API_KEY',
      );
    }
  }
}

class JsContextWrapper {
  String? getApiKey() {
    try {
      final env = js.context['ENV'];
      if (env != null) {
        final apiKey = js.JsObject.fromBrowserObject(env)['GEOCODE_API_KEY'];
        if (apiKey != null) {
          return apiKey.toString();
        }
      }
    } catch (e) {
      debugPrint("Error accessing JS context: $e");
      return null;
    }
    return null;
  }
}

abstract class EnvironmentProvider {
  bool get isWebPlatform;
  Future<void> loadEnvFile(String fileName);
  String getEnvValue(String key, {required String fallback});
}

class DefaultEnvironmentProvider implements EnvironmentProvider {
  final JsContextWrapper _jsContextWrapper;

  DefaultEnvironmentProvider({JsContextWrapper? jsContextWrapper})
    : _jsContextWrapper = jsContextWrapper ?? JsContextWrapper();

  @override
  bool get isWebPlatform => kIsWeb;

  @override
  Future<void> loadEnvFile(String fileName) async {
    await dotenv.load(fileName: fileName);
  }

  @override
  String getEnvValue(String key, {required String fallback}) {
    return dotenv.get(key, fallback: fallback);
  }

  String? getJsApiKey() {
    return _jsContextWrapper.getApiKey();
  }
}
