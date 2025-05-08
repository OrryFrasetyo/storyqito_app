import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:storyqito_app/core/localization/l10n/app_localizations.dart';
import 'package:storyqito_app/core/provider/setting_provider.dart';
import 'package:storyqito_app/core/routes/my_route_delegate.dart';
import 'package:storyqito_app/core/routes/my_route_information_parser.dart';
import 'package:storyqito_app/core/style/theme.dart';
import 'package:storyqito_app/core/style/util.dart';

class MyApp extends StatefulWidget {
  final SharedPreferences sharedPrefs;

  const MyApp({super.key, required this.sharedPrefs});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    final settingProvider = context.watch<SettingProvider>();
    final isDarkTheme = settingProvider.setting?.isDark ?? false;

    TextTheme textTheme = createTextTheme(context);
    MaterialTheme theme = MaterialTheme(textTheme);

    return MaterialApp.router(
      title: "StoryQito",
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: settingProvider.locale,
      theme: theme.lightWithCustomStyles(),
      darkTheme: theme.darkWithCustomStyles(),
      themeMode: isDarkTheme ? ThemeMode.dark : ThemeMode.light,
      debugShowCheckedModeBanner: true,
      routeInformationParser: context.read<MyRouteInformationParser>(),
      routerDelegate: context.read<MyRouteDelegate>(),
    );
  }
}
