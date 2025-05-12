import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:storyqito_app/core/data/network/responses/list_story.dart';
import 'package:storyqito_app/core/provider/auth_provider.dart';
import 'package:storyqito_app/core/provider/story_provider.dart';
import 'package:storyqito_app/features/map/service/map_service.dart';

class MapController {
  final BuildContext context;
  final ScrollController scrollController = ScrollController();
  final MapService _mapService = MapService();

  MapType selectedMapType = MapType.normal;
  bool isMapReady = false;

  MapController(this.context) {
    scrollController.addListener(_scrollListener);
  }

  Set<Marker> get markers => _mapService.markers;

  void dispose() {
    scrollController.removeListener(_scrollListener);
    scrollController.dispose();
    if (isMapReady) {
      _mapService.disposeController();
    }
  }

  void _scrollListener() {
    if (scrollController.position.pixels >=
        scrollController.position.maxScrollExtent - 500) {
      final authProvider = context.read<AuthProvider>();
      final storyProvider = context.read<StoryProvider>();

      if (!storyProvider.isLoading &&
          storyProvider.hasMoreStories &&
          authProvider.user != null) {
        storyProvider.getStories(user: authProvider.user!).then((_) {
          if (isMapReady) {
            updateMarkersFromStories(storyProvider.stories);
          }
        });
      }
    }
  }

  Future<void> initData() async {
    final authProvider = context.read<AuthProvider>();
    await authProvider.getUser();

    if (authProvider.user != null && context.mounted) {
      final storyProvider = context.read<StoryProvider>();
      await storyProvider.getStories(user: authProvider.user!);

      if (isMapReady) {
        updateMarkersFromStories(storyProvider.stories);
      }
    }
  }

  void toggleMapType() {
    selectedMapType =
        selectedMapType == MapType.normal ? MapType.satellite : MapType.normal;
  }

  void updateMarkersFromStories(List<ListStory> stories) {
    _mapService.updateMarkers(
      stories,
      onStoryTap: (position) {
        _mapService.animateCameraToPosition(position, 15);
      },
    );

    final validLocationCount = _mapService.getValidLocationCount();
    final processedIds = _mapService.getProcessedIds();

    if (validLocationCount > 0 &&
        validLocationCount < processedIds.length / 4) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Only $validLocationCount out of ${processedIds.length} stories have location data",
          ),
          duration: Duration(seconds: 3),
          action: SnackBarAction(label: "OK", onPressed: () {}),
        ),
      );
    }
  }

  void onMapCreated(GoogleMapController controller) {
    _mapService.setController(controller);
    isMapReady = true;

    final storyProvider = context.read<StoryProvider>();
    if (storyProvider.stories.isNotEmpty) {
      updateMarkersFromStories(storyProvider.stories);
    }
  }

  void onStoryTap(ListStory story) {
    if (story.lat != null && story.lon != null && isMapReady) {
      final position = LatLng(story.lat!, story.lon!);
      _mapService.animateCameraToPosition(position, 15);
    }
  }

  Future<void> refreshStories() async {
    final authProvider = context.read<AuthProvider>();
    if (authProvider.user != null) {
      final storyProvider = context.read<StoryProvider>();
      await storyProvider.refreshStories(user: authProvider.user!);

      if (isMapReady) {
        updateMarkersFromStories(storyProvider.stories);
      }
    }
  }
}
