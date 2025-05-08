import 'package:flutter/material.dart';
import 'package:storyqito_app/core/data/model/user.dart';
import 'package:storyqito_app/core/data/network/response/stories_response.dart';
import 'package:storyqito_app/core/data/repository/story_repository.dart';

class StoryProvider extends ChangeNotifier {
  final StoryRepository _storyRepository;

  StoryProvider(this._storyRepository);

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
    if (refresh) {
      _currentPage = 1;
      _stories = [];
      _canLoadMoreStories = true;
    }

    if (!_canLoadMoreStories && !refresh) return;

    _isLoading = true;
    _errorMsg = "";
    notifyListeners();

    final result = await _storyRepository.getStories(
      page: _currentPage,
      size: _pageSize,
      user: user,
    );
    if (result.data != null && !result.data!.error) {
      if (refresh) {
        _stories = result.data!.listStory;
      } else {
        _stories.addAll(result.data!.listStory);
      }
      _canLoadMoreStories = result.data!.listStory.length >= _pageSize;
      _currentPage++;
    } else if (result.message != null) {
      _errorMsg = result.message!;
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> refreshStories({required User user}) async {
    await getStories(user: user, refresh: true);
  }
}
