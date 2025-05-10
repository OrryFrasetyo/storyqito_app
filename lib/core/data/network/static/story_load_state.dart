import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:storyqito_app/core/data/network/response/list_story.dart';

part 'story_load_state.freezed.dart';

@freezed
class StoryLoadState with _$StoryLoadState{
  const StoryLoadState._();

  const factory StoryLoadState.initial() = StoryLoadStateInitial;
  const factory StoryLoadState.loading() = StoryLoadStateLoading;
  const factory StoryLoadState.loaded(List<ListStory> data) =
      StoryLoadStateLoaded;
  const factory StoryLoadState.error(String message) = StoryLoadStateError;

  bool get isInitial => this is StoryLoadStateInitial;
  bool get isLoading => this is StoryLoadStateLoading;
  bool get isLoaded => this is StoryLoadStateLoaded;
  bool get isError => this is StoryLoadStateError;
  String? get errorMessage =>
      this is StoryLoadStateError
          ? (this as StoryLoadStateError).message
          : null;
}