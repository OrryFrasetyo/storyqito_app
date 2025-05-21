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
import 'package:storyqito_app/core/provider/app/app_provider.dart';
import 'package:storyqito_app/core/provider/upload/add_new_story_provider.dart';
import 'package:storyqito_app/core/provider/map/address_provider.dart';
import 'package:storyqito_app/core/provider/auth/auth_provider.dart';
import 'package:storyqito_app/core/provider/map/map_provider.dart';
import 'package:storyqito_app/core/provider/setting/setting_provider.dart';
import 'package:storyqito_app/core/provider/story/story_provider.dart';
import 'package:storyqito_app/core/provider/upload/upload_location_loading_provider.dart';
import 'package:storyqito_app/core/provider/upload/upload_map_controller_provider.dart';
import 'package:storyqito_app/core/routes/app_router.dart';
import 'package:storyqito_app/core/utils/constants.dart';
import 'package:storyqito_app/my_app.dart';

class AppRoot extends StatelessWidget {
  final SharedPreferences sharedPrefs;

  const AppRoot({super.key, required this.sharedPrefs});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider(create: (_) => SettingRepository(sharedPrefs)),
        Provider(
          create:
              (_) => ApiServices(
                httpClient: http.Client(),
                appService: AppService(),
              ),
        ),
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
        Provider(
          create:
              (context) => AppRouter(
                authProvider: context.read<AuthProvider>(),
                appProvider: context.read<AppProvider>(),
              ),
        ),
        ChangeNotifierProvider(create: (_) => AppProvider()),
        ChangeNotifierProvider(
          create: (context) => AuthProvider(context.read<AuthRepository>()),
        ),
        ChangeNotifierProvider(
          create: (context) => StoryProvider(context.read<StoryRepository>()),
        ),
        ChangeNotifierProvider(
          create:
              (context) => AddNewStoryProvider(
                storyRepository: context.read<StoryRepository>(),
                appService: AppService(),
              ),
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
          create: (context) => UploadLocationLoadingProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => UploadMapControllerProvider(),
        ),
      ],
      child: MyApp(),
    );
  }
}
