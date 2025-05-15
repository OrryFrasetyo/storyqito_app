import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:storyqito_app/core/data/network/responses/list_story.dart';
import 'package:storyqito_app/core/provider/auth/auth_provider.dart';
import 'package:storyqito_app/core/provider/story/story_provider.dart';
import 'package:storyqito_app/features/map/service/map_service.dart';

class MapProvider extends ChangeNotifier {
  final MapService _mapService = MapService();
  final ScrollController scrollController = ScrollController();
  final AuthProvider _authProvider;
  final StoryProvider _storyProvider;

  MapProvider({
    required AuthProvider authProvider,
    required StoryProvider storyProvider,
  }) : _authProvider = authProvider,
       _storyProvider = storyProvider {
    _initScrollListener();
  }

  MapType _selectedMapType = MapType.normal;
  bool isMapReady = false;

  MapType get selectedMapType => _selectedMapType;
  Set<Marker> get markers => _mapService.markers;

  int _validLocationCount = 0;
  int _processedIdsCount = 0;

  bool get shouldShowLocationWarning =>
      _validLocationCount > 0 && _validLocationCount < _processedIdsCount / 4;

  String get locationWarningMessage =>
      "Only $_validLocationCount out of $_processedIdsCount stories have location data";

  @override
  void dispose() {
    scrollController.dispose();
    if (isMapReady) {
      _mapService.disposeController();
    }
    super.dispose();
  }

  void _initScrollListener() {
    scrollController.addListener(() {
      if (scrollController.position.pixels >=
          scrollController.position.maxScrollExtent - 500) {
        _loadMoreStoriesIfNeeded();
      }
    });
  }

  void _loadMoreStoriesIfNeeded() {
    if (!_storyProvider.state.isLoading &&
        _storyProvider.hasMoreStories &&
        _authProvider.user != null) {
      _storyProvider.getStories(user: _authProvider.user!).then((_) {
        if (isMapReady) {
          updateMarkersFromStories(_storyProvider.stories);
        }
      });
    }
  }

  Future<void> initData() async {
    await _authProvider.getUser();

    if (_authProvider.user != null) {
      await _storyProvider.getStories(user: _authProvider.user!);

      if (isMapReady) {
        updateMarkersFromStories(_storyProvider.stories);
      }
    }
  }

  Future<void> refreshStories() async {
    if (_authProvider.user != null) {
      await _storyProvider.refreshStories(user: _authProvider.user!);

      if (isMapReady) {
        updateMarkersFromStories(_storyProvider.stories);
      }
    }
  }

  void toggleMapType() {
    if (_selectedMapType == MapType.normal) {
      _selectedMapType = MapType.satellite;
    } else {
      _selectedMapType = MapType.normal;
    }
    notifyListeners();
  }

  void updateMarkersFromStories(List<ListStory> stories) {
    _mapService.updateMarkers(
      stories,
      onStoryTap: (position) {
        _mapService.animateCameraToPosition(position, 15);
      },
    );

    _validLocationCount = _mapService.getValidLocationCount();
    _processedIdsCount = _mapService.getProcessedIds().length;
    notifyListeners();
  }

  void onMapCreated(GoogleMapController controller) {
    _mapService.setController(controller);
    isMapReady = true;

    if (_storyProvider.stories.isNotEmpty) {
      updateMarkersFromStories(_storyProvider.stories);
    }

    notifyListeners();
  }

  void onStoryTap(ListStory story) {
    if (story.lat != null && story.lon != null && isMapReady) {
      final position = LatLng(story.lat!, story.lon!);
      _mapService.animateCameraToPosition(position, 11);
    }
  }
}
