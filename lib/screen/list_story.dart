import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:storyapp/bloc/story_bloc.dart';
import 'package:storyapp/component/story_card.dart';

class ListStoryScreen extends StatelessWidget {
  final Function() onLogout;

  const ListStoryScreen({super.key, required this.onLogout});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("List Story"),
        actions: [
          IconButton(icon: const Icon(Icons.logout), onPressed: onLogout),
        ],
      ),
      body: BlocProvider(
        create:
            (context) =>
                StoryBloc()..add(
                  FetchAllStoriesEvent(),
                ), // Load stories when the bloc is created
        child: BlocBuilder<StoryBloc, StoryState>(
          builder: (context, state) {
            if (state is StoryLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is StoryListLoaded) {
              return ListView.builder(
                itemCount: state.stories.length,
                itemBuilder: (context, index) {
                  return StoryCard(
                    story: state.stories[index],
                    onTap: () {}, // Provide a valid onTap function
                  );
                },
              );
            } else if (state is StoryLoadError) {
              return Center(child: Text(state.message));
            }
            return const SizedBox();
          },
        ),
      ),
    );
  }
}
