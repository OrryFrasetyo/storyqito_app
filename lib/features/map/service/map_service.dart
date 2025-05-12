import 'dart:developer';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:storyqito_app/core/data/network/responses/list_story.dart';
import 'package:storyqito_app/features/map/model/map_bounds.dart';

class MapService {
  late GoogleMapController _mapController;
  final Set<Marker> _markers = {};
  int _validLocationCount = 0;
  final Set<String> _processedIds = {};

  Set<Marker> get markers => _markers;
  int getValidLocationCount() => _validLocationCount;
  Set<String> getProcessedIds() => _processedIds;

  void setController(GoogleMapController controller) {
    _mapController = controller;
  }

  void disposeController() {
    _mapController.dispose();
  }

  void animateCameraToPosition(LatLng position, double zoom) {
    _mapController.animateCamera(CameraUpdate.newLatLngZoom(position, zoom));
  }

  void updateMarkers(
    List<ListStory> stories, {
    required Function(LatLng) onStoryTap,
  }) {
    _markers.clear();
    _processedIds.clear();
    _validLocationCount = 0;
    final List<LatLng> locations = [];

    log("Updating markers for ${stories.length} stories");

    for (final story in stories) {
      if (_processedIds.contains(story.id)) continue;
      _processedIds.add(story.id);

      if (story.lat != null && story.lon != null) {
        _validLocationCount++;
        final position = LatLng(story.lat!, story.lon!);
        locations.add(position);

        _markers.add(
          Marker(
            markerId: MarkerId(story.id),
            position: position,
            infoWindow: InfoWindow(
              title: story.name,
              snippet:
                  story.description.length > 50
                      ? '${story.description.substring(0, 50)}...'
                      : story.description,
            ),
            onTap: () => onStoryTap(position),
          ),
        );
      }
    }

    log(
      "Created $_validLocationCount markers out of ${_processedIds.length} unique stories",
    );

    if (locations.isNotEmpty) {
      final MapBounds bounds = MapBounds.fromLatLngList(locations);
      _mapController.animateCamera(
        CameraUpdate.newLatLngBounds(bounds.toBounds(), 50),
      );
    }
  }
}