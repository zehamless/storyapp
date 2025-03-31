import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:storyapp/bloc/story_bloc.dart';
import 'package:storyapp/component/story_card.dart';
import 'package:storyapp/model/story_model.dart';
import 'package:storyapp/repository/auth_repository.dart';

class ListStoryScreen extends StatelessWidget {
  final Function() onLogout;
  final Function(Story) onTap;

  const ListStoryScreen({
    super.key,
    required this.onLogout,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (context) =>
              StoryBloc(context.read<AuthRepository>())
                ..add(FetchAllStoriesEvent()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            "Stories",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          elevation: 2,
          actions: [
            IconButton(
              icon: const Icon(Icons.logout),
              tooltip: "Logout",
              onPressed: () {
                showDialog(
                  context: context,
                  builder:
                      (context) => AlertDialog(
                        title: const Text("Logout"),
                        content: const Text("Are you sure you want to logout?"),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text("CANCEL"),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                              onLogout();
                            },
                            child: const Text("LOGOUT"),
                          ),
                        ],
                      ),
                );
              },
            ),
          ],
        ),
        body: BlocBuilder<StoryBloc, StoryState>(
          builder: (context, state) {
            if (state is StoryLoading || state is StoryInitial) {
              return _buildLoadingView();
            } else if (state is StoryListLoaded) {
              return _buildStoryList(context, state.stories);
            } else if (state is StoryLoadError) {
              return _buildErrorView(context, state.message);
            }
            return const SizedBox();
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            // Add navigation to create story screen
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Add story feature coming soon")),
            );
          },
          tooltip: 'Add Story',
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  Widget _buildLoadingView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          CircularProgressIndicator(),
          SizedBox(height: 16),
          Text("Loading stories...", style: TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }

  Widget _buildStoryList(BuildContext context, List<Story> stories) {
    if (stories.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.article_outlined, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              "No stories yet",
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(color: Colors.grey[600]),
            ),
            const SizedBox(height: 8),
            Text(
              "Create a new story by tapping the + button",
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () async {
        context.read<StoryBloc>().add(FetchAllStoriesEvent());
      },
      child: ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.only(top: 8, bottom: 80),
        itemCount: stories.length,
        itemBuilder: (context, index) {
          return StoryCard(
            story: stories[index],
            onTap: () => onTap(stories[index]),
          );
        },
      ),
    );
  }

  Widget _buildErrorView(BuildContext context, String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 64, color: Colors.red[300]),
          const SizedBox(height: 16),
          Text(
            "Something went wrong",
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              message,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () {
              context.read<StoryBloc>().add(FetchAllStoriesEvent());
            },
            icon: const Icon(Icons.refresh),
            label: const Text("Try Again"),
          ),
        ],
      ),
    );
  }
}
