import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:storyqito_app/core/data/network/responses/list_story.dart';
import 'package:storyqito_app/core/data/network/static/address_load_state.dart';
import 'package:storyqito_app/core/provider/address_provider.dart';
import 'package:storyqito_app/features/detail/widget/address_widget.dart';
import 'package:storyqito_app/features/detail/widget/story_location_map_widget.dart';

class LocationWidget extends StatefulWidget {
  final ListStory listStory;
  final bool mapControlsEnabled;
  final String mapKeyPrefix;

  const LocationWidget({
    super.key,
    required this.listStory,
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
          widget.listStory.lat!,
          widget.listStory.lon!,
        );
      });
      _requestAddress = true;
    }
  }

  void _showStoryMapDialog() {
    final address = context.read<AddressProvider>().state.getAddressOrFallback(
      context,
    );

    showDialog(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.9),
      builder: (_) {
        return Scaffold(
          backgroundColor: Colors.transparent,
          body: SafeArea(
            child: Stack(
              children: [
                StoryLocationMapWidget(
                  latitude: widget.listStory.lat!,
                  longitude: widget.listStory.lon!,
                  title: widget.listStory.name,
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
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Icon(Icons.close),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final address = context.watch<AddressProvider>().state.getAddressOrFallback(
      context,
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Divider(),
        const SizedBox(height: 16.0),

        AddressWidget(
          latitude: widget.listStory.lat!,
          longitude: widget.listStory.lon!,
          storyId: widget.listStory.id,
        ),

        const SizedBox(height: 16.0),

        Stack(
          children: [
            StoryLocationMapWidget(
              key: ValueKey(
                "${widget.mapKeyPrefix}-location-map-${widget.listStory.id}",
              ),
              latitude: widget.listStory.lat!,
              longitude: widget.listStory.lon!,
              height: 400.0,
              title: widget.listStory.name,
              controlsEnabled: widget.mapControlsEnabled,
              location: address,
            ),
            Positioned(
              top: 12.0,
              right: 12.0,
              child: FloatingActionButton.small(
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
                onPressed: _showStoryMapDialog,
                child: const Icon(Icons.fullscreen),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
