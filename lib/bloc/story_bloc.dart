import 'package:bloc/bloc.dart';
import 'package:storyapp/repository/auth_repository.dart';

import '../model/story_model.dart';

abstract class StoryEvent {}

class FetchStoryEvent extends StoryEvent {
  final String storyId;

  FetchStoryEvent(this.storyId);
}

class FetchAllStoriesEvent extends StoryEvent {}

abstract class StoryState {}

class StoryInitial extends StoryState {}

class StoryLoading extends StoryState {}

class StoryListLoaded extends StoryState {
  final List<Story> stories;

  StoryListLoaded(this.stories);
}

class StoryLoaded extends StoryState {
  final Story story;

  StoryLoaded(this.story);
}

class StoryLoadError extends StoryState {
  final String message;

  StoryLoadError(this.message);
}

class StoryBloc extends Bloc<StoryEvent, StoryState> {
  final AuthRepository _authRepository;

  StoryBloc(this._authRepository) : super(StoryInitial()) {
    on<FetchStoryEvent>(_onFetchStory);
    on<FetchAllStoriesEvent>(_onFetchAllStories);
  }

  Future<void> _onFetchAllStories(
    FetchAllStoriesEvent event,
    Emitter<StoryState> emit,
  ) async {
    emit(StoryLoading());
    final List<Story> stories = await _authRepository.fetchAllStories();
    if (stories.isNotEmpty) {
      emit(StoryListLoaded(stories));
    } else {
      emit(StoryLoadError('Failed to load stories'));
    }
  }

  Future<void> _onFetchStory(
    FetchStoryEvent event,
    Emitter<StoryState> emit,
  ) async {
    emit(StoryLoading());
    final Story? story = await _authRepository.fetchStory(event.storyId);
    if (story != null) {
      emit(StoryLoaded(story));
    } else {
      emit(StoryLoadError('Failed to load story'));
    }
  }
}
