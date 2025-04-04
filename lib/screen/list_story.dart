import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:storyapp/bloc/story_bloc.dart';
import 'package:storyapp/component/flag.dart';
import 'package:storyapp/component/story_card.dart';
import 'package:storyapp/l10n/app_localizations.dart';
import 'package:storyapp/model/story_model.dart';

class ListStoryScreen extends StatelessWidget {
  final Function() onLogout;
  final Function() onPressedFloating;
  final Function(Story) onTap;

  const ListStoryScreen({
    super.key,
    required this.onLogout,
    required this.onTap,
    required this.onPressedFloating,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.listStories,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        elevation: 2,
        actions: [
          FlagIconWidget(),
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: AppLocalizations.of(context)!.logout,
            onPressed: onLogout,
          ),
        ],
      ),
      body: BlocBuilder<StoryBloc, StoryState>(
        builder: (context, state) {
          if (state is StoryLoading || state is StoryInitial) {
            return _buildLoadingView(context);
          } else if (state is StoryListLoaded) {
            return _buildStoryList(context, state.stories);
          } else if (state is StoryLoadError) {
            return _buildErrorView(context, state.message);
          }
          return const SizedBox();
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: onPressedFloating,
        tooltip: AppLocalizations.of(context)!.addStory,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildLoadingView(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(),
          const SizedBox(height: 16),
          Text(
            AppLocalizations.of(context)!.loadingStory,
            style: const TextStyle(color: Colors.grey),
          ),
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
              AppLocalizations.of(context)!.emptyStory,
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(color: Colors.grey[600]),
            ),
            const SizedBox(height: 8),
            Text(
              AppLocalizations.of(context)!.createStoryMessage,
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
            AppLocalizations.of(context)!.errorLoadingStory,
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
            label: Text(AppLocalizations.of(context)!.refresh),
          ),
        ],
      ),
    );
  }
}
