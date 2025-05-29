import 'package:flutter/material.dart';
import 'package:storyqito_app/core/localization/l10n/app_localizations.dart';
import 'package:storyqito_app/core/utils/constants.dart';
import 'package:storyqito_app/features/home/screen/home_screen.dart';
import 'package:storyqito_app/features/main/animation/animate_tab_switcher';
import 'package:storyqito_app/features/map/ui/screen/story_map_screen.dart';
import 'package:storyqito_app/features/setting/setting_screen.dart';
import 'package:storyqito_app/features/upload/screen/upload_story_screen.dart';

class MainScreen extends StatefulWidget {
  final Widget child;
  final Function(int) onTabSelected;
  final VoidCallback onLogout;
  final Object? routeExtra;
  final int selectedIndex;

  const MainScreen({
    super.key,
    required this.onLogout,
    required this.selectedIndex,
    required this.onTabSelected,
    required this.child,
    this.routeExtra,
  });

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  bool _isMobile = true;
  double _previousWidth = 0;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final localizations = AppLocalizations.of(context)!;

    if ((screenWidth - _previousWidth).abs() > 5) {
      _isMobile = screenWidth < tabletWidthThreshold;
      _previousWidth = screenWidth;
    }

    final tabContent = AnimateTabSwitcher(
      index: widget.selectedIndex,
      children: [
        const HomeScreen(),
        const UploadStoryScreen(),
        const StoryMapScreen(),
        const SettingScreen(),
      ],
    );

    return Scaffold(
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 800),
        child:
            _isMobile
                ? tabContent
                : Row(
                  key: const ValueKey("desktop_layout"),
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
                          icon: Icon(Icons.map_rounded),
                          label: Text(localizations.map),
                        ),
                        NavigationRailDestination(
                          icon: Icon(Icons.settings),
                          label: Text(localizations.setting),
                        ),
                      ],
                      selectedIndex: widget.selectedIndex,
                      onDestinationSelected: widget.onTabSelected,
                      labelType: NavigationRailLabelType.all,
                    ),
                    const VerticalDivider(width: 1),
                    Expanded(child: tabContent),
                  ],
                ),
      ),
      bottomNavigationBar: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        transitionBuilder: (Widget child, Animation<double> animation) {
          return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, 1),
              end: Offset.zero,
            ).animate(animation),
            child: FadeTransition(opacity: animation, child: child),
          );
        },
        child:
            _isMobile
                ? ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12.0),
                    topRight: Radius.circular(12.0),
                  ),
                  child: NavigationBar(
                    key: const ValueKey("bottom_navbar"),
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
                        icon: Icon(Icons.map_rounded),
                        label: localizations.map,
                        tooltip: localizations.map,
                      ),
                      NavigationDestination(
                        icon: Icon(Icons.settings),
                        label: localizations.setting,
                        tooltip: localizations.setting,
                      ),
                    ],
                    selectedIndex: widget.selectedIndex,
                    onDestinationSelected: widget.onTabSelected,
                  ),
                )
                : const SizedBox.shrink(),
      ),
    );
  }
}
