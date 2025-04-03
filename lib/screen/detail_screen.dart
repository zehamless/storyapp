import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:storyapp/l10n/app_localizations.dart';
import 'package:storyapp/model/story_model.dart';

class DetailScreen extends StatelessWidget {
  final Story story;

  const DetailScreen({super.key, required this.story});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.detailTitle,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image with hero animation
            Hero(
              tag: story.id,
              child: CachedNetworkImage(
                imageUrl: story.photoUrl,
                height: 300,
                width: double.infinity,
                fit: BoxFit.cover,
                placeholder:
                    (context, url) =>
                        const Center(child: CircularProgressIndicator()),
                errorWidget:
                    (context, url, error) => const Center(
                      child: Icon(Icons.error, size: 50, color: Colors.red),
                    ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    story.name,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 8),

                  const Divider(),

                  const SizedBox(height: 8),
                  Text(
                    AppLocalizations.of(context)!.detailDescription,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    story.description,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
