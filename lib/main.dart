import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:storyqito_app/app_root.dart';
import 'package:storyqito_app/core/utils/maps_environment.dart';
import 'package:storyqito_app/core/variant/build_config.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await MapsEnvironment.initialize();
  final sharedPrefs = await SharedPreferences.getInstance();

  if (!kIsWeb) {
    debugPrint(
      'Running ${BuildConfig.isPaidVersion ? "PAID" : "FREE"} version',
    );
  }
  runApp(AppRoot(sharedPrefs: sharedPrefs));
}
