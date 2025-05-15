import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:storyqito_app/app_root.dart';
import 'package:storyqito_app/core/utils/maps_environment.dart';
import 'package:storyqito_app/core/variant/build_config.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  GoRouter.optionURLReflectsImperativeAPIs = true;

  await MapsEnvironment.initialize();
  
  await BuildConfig.initialize();

  final sharedPrefs = await SharedPreferences.getInstance();

  runApp(AppRoot(sharedPrefs: sharedPrefs));
}
