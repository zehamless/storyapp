import 'package:bloc/bloc.dart';

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
  StoryBloc() : super(StoryInitial()) {
    on<FetchStoryEvent>(_onFetchStory);
    on<FetchAllStoriesEvent>(_onFetchAllStories);
  }

  Future<void> _onFetchAllStories(
    FetchAllStoriesEvent event,
    Emitter<StoryState> emit,
  ) async {
    emit(StoryLoading());
    await Future.delayed(const Duration(seconds: 2));
    emit(
      StoryListLoaded(
        List.generate(
          20,
          (index) => Story(
            id: 'id_$index',
            name: 'List_$index',
            description: 'lorem ipsum dolor sit amet',
            photoUrl: 'https://picsum.photos/seed/picsum/300/200',
            createdAt: DateTime.now(),
            lat: 0.0,
            lon: 0.0,
          ),
        ),
      ),
    );
  }

  Future<void> _onFetchStory(
    FetchStoryEvent event,
    Emitter<StoryState> emit,
  ) async {
    emit(StoryLoading());
    await Future.delayed(const Duration(seconds: 1));
    emit(
      StoryLoaded(
        Story(
          id: event.storyId,
          name: 'Sample Story',
          description: 'This is a sample story description.',
          photoUrl: 'https://picsum.photos/seed/picsum/300/200',
          createdAt: DateTime.now(),
          lat: 0.0,
          lon: 0.0,
        ),
      ),
    );
  }
}
