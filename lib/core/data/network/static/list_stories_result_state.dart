import 'package:storyqito_app/core/data/network/response/stories_response.dart';

sealed class ListStoriesResultState {}

class ListStoriesNoneState extends ListStoriesResultState {}

class ListStoriesLoadingState extends ListStoriesResultState {}

class ListStoriesErrorState extends ListStoriesResultState {
  final String error;

  ListStoriesErrorState(this.error);
}

class ListStoriesLoadedState extends ListStoriesResultState {
  final List<ListStory> data;

  ListStoriesLoadedState(this.data);
}