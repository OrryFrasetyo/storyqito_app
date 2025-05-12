import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:storyqito_app/app_root.dart';
import 'package:storyqito_app/core/utils/maps_environment.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await MapsEnvironment.initialize();
  final sharedPrefs = await SharedPreferences.getInstance();
  runApp(AppRoot(sharedPrefs: sharedPrefs));
}
