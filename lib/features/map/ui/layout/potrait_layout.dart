import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:storyqito_app/core/provider/map/map_provider.dart';
import 'package:storyqito_app/features/map/ui/layout/horizontal_split_layout.dart';
import 'package:storyqito_app/features/map/ui/widgets/map_widget.dart';
import 'package:storyqito_app/features/map/ui/widgets/story_map_list_widget.dart';

class PotraitLayout extends StatefulWidget {
  const PotraitLayout({super.key});

  @override
  State<PotraitLayout> createState() => _PotraitLayoutState();
}

class _PotraitLayoutState extends State<PotraitLayout> {
  final GlobalKey<HorizontalSplitLayoutState> _splitLayoutKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return HorizontalSplitLayout(
      key: _splitLayoutKey,
      top: MapWidget(),
      bottom: StoryMapListWidget(
        onStoryTap: (story) {
          context.read<MapProvider>().onStoryTap(story);

          _splitLayoutKey.currentState?.expandTopView();
        },
      ),
      totalHeight: MediaQuery.of(context).size.height,
      ratio: 0.3,
    );
  }
}
