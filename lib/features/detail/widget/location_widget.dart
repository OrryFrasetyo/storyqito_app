import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:storyqito_app/core/data/network/static/address_load_state.dart';
import 'package:storyqito_app/core/provider/app/app_provider.dart';
import 'package:storyqito_app/core/provider/map/address_provider.dart';
import 'package:storyqito_app/features/detail/widget/address_widget.dart';
import 'package:storyqito_app/features/detail/widget/story_location_map_widget.dart';

class LocationWidget extends StatefulWidget {
  final bool mapControlsEnabled;
  final String mapKeyPrefix;

  const LocationWidget({
    super.key,
    this.mapControlsEnabled = true,
    this.mapKeyPrefix = "detail",
  });

  @override
  State<LocationWidget> createState() => _LocationWidgetState();
}

class _LocationWidgetState extends State<LocationWidget> {
  bool _requestAddress = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!_requestAddress) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.read<AddressProvider>().getAddressFromCoordinates(
          context.read<AppProvider>().selectedStory!.lat!,
          context.read<AppProvider>().selectedStory!.lon!,
        );
      });
      _requestAddress = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    final story = context.read<AppProvider>().selectedStory!;
    final address = context.watch<AddressProvider>().state.getAddressOrFallback(
      context,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Divider(),
        const SizedBox(height: 16.0),

        AddressWidget(
          latitude: story.lat!,
          longitude: story.lon!,
          storyId: story.id,
        ),

        const SizedBox(height: 16.0),

        Stack(
          children: [
            StoryLocationMapWidget(
              key: ValueKey("${widget.mapKeyPrefix}-location-map-${story.id}"),
              latitude: story.lat!,
              longitude: story.lon!,
              height: 400.0,
              title: story.name,
              controlsEnabled: widget.mapControlsEnabled,
              location: address,
            ),
          ],
        ),
      ],
    );
  }
}
