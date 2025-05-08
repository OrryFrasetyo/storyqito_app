import 'package:flutter/material.dart';
import 'package:storyqito_app/core/localization/l10n/app_localizations.dart';
import 'package:storyqito_app/ui/home/home_screen.dart';
import 'package:storyqito_app/ui/setting/setting_screen.dart';
import 'package:storyqito_app/ui/upload/upload_story_screen.dart';

class MainScreen extends StatelessWidget {
  final VoidCallback onLogout;
  final int selectedIndex;
  final Function(int) onTabSelected;

  const MainScreen({
    super.key,
    required this.onLogout,
    required this.selectedIndex,
    required this.onTabSelected,
  });

  static const int tabletWidthThreshold = 600;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < tabletWidthThreshold;
    final localizations = AppLocalizations.of(context)!;

    Widget tabContent = IndexedStack(
      index: selectedIndex,
      children: [
        HomeScreen(onLogout: onLogout),
        UploadStoryScreen(),
        SettingScreen(onLogout: onLogout),
      ],
    );

    return Scaffold(
      body:
          isMobile
              ? tabContent
              : Row(
                children: [
                  NavigationRail(
                    destinations: [
                      NavigationRailDestination(
                        icon: Icon(Icons.home),
                        label: Text(localizations.home),
                      ),
                      NavigationRailDestination(
                        icon: Icon(Icons.upload),
                        label: Text(localizations.upload),
                      ),
                      NavigationRailDestination(
                        icon: Icon(Icons.settings),
                        label: Text(localizations.setting),
                      ),
                    ],
                    selectedIndex: selectedIndex,
                    onDestinationSelected: onTabSelected,
                    labelType: NavigationRailLabelType.all,
                  ),
                  const VerticalDivider(width: 1),
                  Expanded(child: tabContent),
                ],
              ),
      bottomNavigationBar:
          isMobile
              ? ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12.0),
                  topRight: Radius.circular(12.0),
                ),
                child: NavigationBar(
                  destinations: [
                    NavigationDestination(
                      icon: Icon(Icons.home),
                      label: localizations.home,
                      tooltip: localizations.home,
                    ),
                    NavigationDestination(
                      icon: Icon(Icons.upload),
                      label: localizations.upload,
                      tooltip: localizations.upload,
                    ),
                    NavigationDestination(
                      icon: Icon(Icons.settings),
                      label: localizations.setting,
                      tooltip: localizations.setting,
                    ),
                  ],
                  selectedIndex: selectedIndex,
                  onDestinationSelected: onTabSelected,
                ),
              )
              : null,
    );
  }
}
