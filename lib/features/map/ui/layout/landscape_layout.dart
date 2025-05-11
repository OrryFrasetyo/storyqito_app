import 'package:flutter/widgets.dart';
import 'package:storyqito_app/features/map/ui/layout/vertical_split_layout.dart';
import 'package:storyqito_app/features/map/ui/widgets/map_widget.dart';
import 'package:storyqito_app/features/map/ui/widgets/story_map_list_widget.dart';

class LandscapeLayout extends StatelessWidget {
  const LandscapeLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return VerticalSplitLayout(
      left: StoryMapListWidget(),
      right: MapWidget(),
      ratio: 0.25,
    );
  }
}
