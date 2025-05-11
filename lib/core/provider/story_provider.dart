import 'package:flutter/material.dart';
import 'package:storyqito_app/core/data/model/user.dart';
import 'package:storyqito_app/core/data/network/response/list_story.dart';
import 'package:storyqito_app/core/data/repository/story_repository.dart';

class StoryProvider extends ChangeNotifier {
  final StoryRepository _storyRepository;

  StoryProvider(this._storyRepository);

  // StoryLoadState _state = const StoryLoadState.initial();
  // StoryLoadState get state => _state;

  bool _isLoading = false;
  String _errorMsg = "";
  List<ListStory> _stories = [];
  bool _canLoadMoreStories = true;
  int _currentPage = 1;
  final int _pageSize = 10;

  bool get isLoading => _isLoading;
  String get errorMsg => _errorMsg;
  List<ListStory> get stories => _stories;
  bool get hasMoreStories => _canLoadMoreStories;

  Future<void> getStories({required User user, bool refresh = false}) async {
    // if (_isLoading && !refresh) return;

    if (refresh) {
      _currentPage = 1;
      _stories = [];
      _canLoadMoreStories = true;
    }

    if (!_canLoadMoreStories && !refresh) return;

    final result = await _storyRepository.getStories(
      page: _currentPage,
      size: _pageSize,
      user: user,
    );

    if (result.data != null && !result.data!.error) {
      if (refresh) {
        _stories = List<ListStory>.from(result.data!.listStory);
      } else {
        _stories = [..._stories, ...result.data!.listStory];
      }
      _canLoadMoreStories = result.data!.listStory.length >= _pageSize;
      _currentPage++;
      // _state = StoryLoadState.loaded(_stories);
    } else if (result.message != null) {
      // _state = StoryLoadState.error(result.message!);
      _errorMsg = result.message!;
    }

    _isLoading = false;
    notifyListeners();

    // if (refresh) {
    //   _state = const StoryLoadState.loading();
    // } else {
    //   _isLoading = true;
    // }
    // notifyListeners();

    //   try {
    //     final result = await _storyRepository.getStories(
    //       page: _currentPage,
    //       size: _pageSize,
    //       user: user,
    //     );
    //     if (result.data != null && !result.data!.error) {
    //       if (refresh) {
    //         _stories = List<ListStory>.from(result.data!.listStory);
    //       } else {
    //         _stories = [..._stories, ...result.data!.listStory];
    //       }
    //       _canLoadMoreStories = result.data!.listStory.length >= _pageSize;
    //       _currentPage++;
    //       _state = StoryLoadState.loaded(_stories);
    //     } else if (result.message != null) {
    //       _state = StoryLoadState.error(result.message!);
    //     }
    //   } catch (e) {
    //     _state = StoryLoadState.error(e.toString());
    //   } finally {
    //     _isLoading = false;
    //     notifyListeners();
    //   }
  }

  Future<void> refreshStories({required User user}) async {
    await getStories(user: user, refresh: true);
  }
}
