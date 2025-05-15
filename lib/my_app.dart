import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:storyqito_app/core/localization/l10n/app_localizations.dart';
import 'package:storyqito_app/core/provider/setting/setting_provider.dart';
import 'package:storyqito_app/core/routes/app_router.dart';
import 'package:storyqito_app/core/style/theme.dart';
import 'package:storyqito_app/core/style/util.dart';
import 'package:storyqito_app/core/variant/build_config.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    late String appName;
    final settingProvider = context.watch<SettingProvider>();
    final isDarkTheme = settingProvider.setting?.isDark ?? false;
    final router = context.read<AppRouter>().router;

    TextTheme textTheme = createTextTheme(context);
    MaterialTheme theme = MaterialTheme(textTheme);

    if (kIsWeb) {
      final appFlavor = const String.fromEnvironment(
        "APP_FLAVOR",
        defaultValue: "free",
      );
      final isPaidVersion = appFlavor == "paid";
      appName = isPaidVersion == true ? "Storyqito Premium" : "Storyqito Free";
    } else {
      appName = BuildConfig.appName;
    }

    return MaterialApp.router(
      title: appName,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: settingProvider.locale,
      theme: theme.lightWithCustomStyles(),
      darkTheme: theme.darkWithCustomStyles(),
      themeMode: isDarkTheme ? ThemeMode.dark : ThemeMode.light,
      debugShowCheckedModeBanner: true,
      routerConfig: router,
    );
  }
}
