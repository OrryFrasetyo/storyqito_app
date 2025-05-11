import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:storyqito_app/core/localization/l10n/app_localizations.dart';
import 'package:storyqito_app/core/provider/auth_provider.dart';
import 'package:storyqito_app/core/provider/map_provider.dart';
import 'package:storyqito_app/core/provider/story_provider.dart';
import 'package:storyqito_app/features/map/ui/layout/landscape_layout.dart';
import 'package:storyqito_app/features/map/ui/layout/potrait_layout.dart';

class StoryMapScreen extends StatefulWidget {
  const StoryMapScreen({super.key});

  @override
  State<StoryMapScreen> createState() => _StoryMapScreenState();
}

class _StoryMapScreenState extends State<StoryMapScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MapProvider>().initData();
    });
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final isLandscape = MediaQuery.of(context).size.width > 600;
    final mapProvider = context.watch<MapProvider>();

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Text(
              localizations.map,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: mapProvider.refreshStories,
            tooltip: localizations.refresh,
          ),
          const SizedBox(width: 4.0),
          IconButton(
            icon: const Icon(Icons.layers),
            onPressed: mapProvider.toggleMapType,
            tooltip: localizations.change_map_type,
          ),
          const SizedBox(width: 8.0),
        ],
      ),
      body: Consumer2<AuthProvider, StoryProvider>(
        builder: (context, authProvider, storyProvider, child) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mapProvider.shouldShowLocationWarning) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(mapProvider.locationWarningMessage),
                  duration: const Duration(seconds: 3),
                  action: SnackBarAction(label: localizations.ok, onPressed: () {}),
                ),
              );
            }
          });

          if (authProvider.isLoadingLogin) {
            return const Center(child: CircularProgressIndicator());
          }

          if (authProvider.errorMsg.isNotEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 64, color: Colors.red),
                  const SizedBox(height: 16),
                  Text(
                    "${localizations.error}: ${authProvider.errorMsg}",
                    style: const TextStyle(fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          }

          if (authProvider.user == null) {
            return Center(child: Text(localizations.no_user_data));
          }

          return isLandscape ? LandscapeLayout() : PotraitLayout();
        },
      ),
    );
  }
}
