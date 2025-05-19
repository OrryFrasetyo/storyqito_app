import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:storyqito_app/core/data/network/static/address_load_state.dart';
import 'package:storyqito_app/core/provider/app/app_provider.dart';
import 'package:storyqito_app/core/provider/map/address_provider.dart';
import 'package:storyqito_app/features/detail/widget/story_location_map_widget.dart';

class DetailFullScreenMapsWidget extends StatelessWidget {
  const DetailFullScreenMapsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final story = context.read<AppProvider>().selectedStory!;
    final address = context.watch<AddressProvider>().state.getAddressOrFallback(
      context,
    );

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Stack(
          children: [
            StoryLocationMapWidget(
              latitude: story.lat!,
              longitude: story.lon!,
              title: story.name,
              location: address,
              height: MediaQuery.of(context).size.height,
              controlsEnabled: true,
            ),
            Positioned(
              top: 16,
              left: 16,
              child: FloatingActionButton.small(
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
                child: const Icon(Icons.close),
                onPressed: () {
                  context.read<AppProvider>().closeDetailFullScreenMap();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
