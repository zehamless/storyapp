import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:storyapp/component/story_card.dart';
import 'package:storyapp/model/story_model.dart';

import '../bloc/auth_bloc.dart';

class ListStoryScreen extends StatelessWidget {
  final Function() onLogout;
  const ListStoryScreen({super.key, required this.onLogout});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("List Story"),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: onLogout,
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: 20,
        itemBuilder: (context, index) {
          return StoryCard(
            onTap: () {
              // Define the onTap action here
            },
            story: Story(
              id: 'id_$index',
              name: 'List_$index',
              description: 'lorem ipsum dolor sit amet',
              photoUrl: 'https://picsum.photos/seed/picsum/300/200',
              createdAt: null,
              lat: null,
              lon: null,
            ),
          );
        },
      ),
    );
  }
}
