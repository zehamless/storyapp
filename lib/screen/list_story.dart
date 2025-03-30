import 'package:flutter/material.dart';
import 'package:storyapp/component/story_card.dart';
import 'package:storyapp/model/list_story_model.dart';

class ListStoryScreen extends StatelessWidget {
  const ListStoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("List Story")),
      body: ListView.builder(
        itemCount: 20,
        itemBuilder: (context, index) {
          return StoryCard(
            onTap: () {
              // Define the onTap action here
            },
            story: ListStory(
              id: 'id_$index', name: 'List_$index', description: 'lorem ipsum dolor sit amet', photoUrl: 'https://picsum.photos/seed/picsum/300/200', createdAt: null, lat: null, lon: null,

            ),
          );
        },
      ),
    );
  }
}
