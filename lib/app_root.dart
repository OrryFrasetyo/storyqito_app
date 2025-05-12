import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:storyqito_app/core/data/network/service/api_services.dart';
import 'package:storyqito_app/core/data/network/service/maps_api_service.dart';
import 'package:storyqito_app/core/data/repository/auth_repository.dart';
import 'package:storyqito_app/core/data/repository/maps_repository.dart';
import 'package:storyqito_app/core/data/repository/setting_repository.dart';
import 'package:storyqito_app/core/data/repository/story_repository.dart';
import 'package:storyqito_app/core/provider/add_new_story_provider.dart';
import 'package:storyqito_app/core/provider/address_provider.dart';
import 'package:storyqito_app/core/provider/auth_provider.dart';
import 'package:storyqito_app/core/provider/map_provider.dart';
import 'package:storyqito_app/core/provider/setting_provider.dart';
import 'package:storyqito_app/core/provider/story_provider.dart';
import 'package:storyqito_app/core/routes/my_route_delegate.dart';
import 'package:storyqito_app/core/routes/my_route_information_parser.dart';
import 'package:storyqito_app/my_app.dart';

class AppRoot extends StatelessWidget {
  final SharedPreferences sharedPrefs;

  const AppRoot({super.key, required this.sharedPrefs});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider(create: (_) => SettingRepository(sharedPrefs)),
        Provider(create: (_) => MyRouteInformationParser()),
        Provider(create: (_) => ApiServices(httpClient: http.Client())),
        Provider(create: (_) => MapsApiService(httpClient: http.Client())),
        Provider(
          create:
              (context) =>
                  AuthRepository(sharedPrefs, context.read<ApiServices>()),
        ),
        Provider(
          create: (context) => StoryRepository(context.read<ApiServices>()),
        ),
        Provider(
          create: (context) => MapsRepository(context.read<MapsApiService>()),
        ),
        ChangeNotifierProvider(
          create: (context) => AuthProvider(context.read<AuthRepository>()),
        ),
        ChangeNotifierProvider(
          create: (context) => StoryProvider(context.read<StoryRepository>()),
        ),
        ChangeNotifierProvider(
          create:
              (context) => AddNewStoryProvider(context.read<StoryRepository>()),
        ),
        ChangeNotifierProvider(
          create:
              (context) => SettingProvider(context.read<SettingRepository>()),
        ),
        ChangeNotifierProvider(
          create:
              (context) => MapProvider(
                authProvider: context.read<AuthProvider>(),
                storyProvider: context.read<StoryProvider>(),
              ),
        ),
        ChangeNotifierProvider(
          create: (context) => AddressProvider(context.read<MapsRepository>()),
        ),
        ChangeNotifierProvider(
          create:
              (context) => MyRouteDelegate(
                context.read<AuthProvider>(),
                context.read<SettingProvider>(),
              ),
        ),
      ],
      child: MyApp(),
    );
  }
}
