import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:storyapp/bloc/image_picker_bloc.dart';

class MediaScreen extends StatelessWidget {
  final Function() onClose;

  const MediaScreen({super.key, required this.onClose});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ImagePickerBloc(),
      child: BlocBuilder<ImagePickerBloc, ImagePickerState>(
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              title: Text(
                'Post Story',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),
                Expanded(
                  child: Center(child: _buildImagePreview(context, state)),
                ),
                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: () => _galleryPick(context),
                        child: const Text("Gallery"),
                      ),
                      ElevatedButton(
                        onPressed: () => _cameraPick(context),
                        child: const Text("Camera"),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _galleryPick(BuildContext context) {
    if (defaultTargetPlatform != TargetPlatform.android) {
      return;
    }
    context.read<ImagePickerBloc>().add(PickImageEvent(ImageSource.gallery));
  }

  void _cameraPick(BuildContext context) {
    if (defaultTargetPlatform != TargetPlatform.android) {
      return;
    }
    context.read<ImagePickerBloc>().add(PickImageEvent(ImageSource.camera));
  }

  Widget _buildImagePreview(BuildContext context, ImagePickerState state) {
    if (state is ImagePickedState) {
      return Stack(
        children: [
          Image.file(File(state.imagePath), fit: BoxFit.cover),
          Positioned(
            top: 10,
            right: 10,
            child: IconButton(
              icon: const Icon(Icons.close, color: Colors.red),
              onPressed: () {
                context.read<ImagePickerBloc>().add(ClearImageEvent());
                onClose();
              },
            ),
          )
        ],
      );
    }
    return const Icon(
      Icons.image,
      size: 100,
    );
  }
}
