import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:storyapp/bloc/image_picker_bloc.dart';

class MediaScreen extends StatefulWidget {
  final Function() onClose;

  const MediaScreen({super.key, required this.onClose});

  @override
  State<MediaScreen> createState() => _MediaScreenState();
}

class _MediaScreenState extends State<MediaScreen> {
  final TextEditingController captionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ImagePickerBloc(),
      child: BlocBuilder<ImagePickerBloc, ImagePickerState>(
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              title: const Text(
                'Post Story',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Expanded(
                    flex: 5,
                    child: Center(child: _buildImagePreview(context, state)),
                  ),
                  if (state is ImagePickedState)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: BlocConsumer<ImagePickerBloc, ImagePickerState>(
                        listener: (context, state) {
                          if (state is ImageUploadSuccessState) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Image uploaded successfully!"),
                              ),
                            );
                            widget.onClose();
                          } else if (state is ImageUploadErrorState) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(state.errorMessage)),
                            );
                          }
                        },
                        builder: (context, state) {
                          if (state is ImageUploadLoadingState) {
                            return const CircularProgressIndicator();
                          }
                          return ElevatedButton.icon(
                            onPressed: () {
                              if (state is ImagePickedState) {
                                context.read<ImagePickerBloc>().add(
                                  UploadImageEvent(
                                    state.imagePath,
                                    state.imageFile,
                                  ),
                                );
                              }
                            },
                            icon: const Icon(Icons.cloud_upload),
                            label: const Text(
                              "UPLOAD",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          );
                        },
                      ),
                    ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () => _galleryPick(context),
                            icon: const Icon(Icons.photo_library),
                            label: const Text("Gallery"),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () => _cameraPick(context),
                            icon: const Icon(Icons.camera_alt),
                            label: const Text("Camera"),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _galleryPick(BuildContext context) {
    if (defaultTargetPlatform != TargetPlatform.android) return;
    context.read<ImagePickerBloc>().add(PickImageEvent(ImageSource.gallery));
  }

  void _cameraPick(BuildContext context) {
    if (defaultTargetPlatform != TargetPlatform.android) return;
    context.read<ImagePickerBloc>().add(PickImageEvent(ImageSource.camera));
  }

  Widget _buildImagePreview(BuildContext context, ImagePickerState state) {
    if (state is ImagePickedState ||
        state is ImageUploadLoadingState ||
        state is ImageUploadSuccessState) {
      String imagePath =
          (state is ImagePickedState)
              ? state.imagePath
              : (state is ImageUploadLoadingState)
              ? state.imagePath
              : (state as ImageUploadSuccessState).imagePath;

      return Stack(
        children: [
          Image.file(File(imagePath), fit: BoxFit.cover),
          if (state is! ImageUploadLoadingState)
            Positioned(
              top: 10,
              right: 10,
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(20),
                  onTap:
                      () => context.read<ImagePickerBloc>().add(
                        ClearImageEvent(),
                      ),
                  child: Ink(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.5),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.delete,
                      color: Colors.red,
                      size: 20,
                    ),
                  ),
                ),
              ),
            ),
          if (state is ImageUploadLoadingState)
            const Center(child: CircularProgressIndicator(color: Colors.white)),
        ],
      );
    }
    return const Icon(Icons.image, size: 100);
  }
}
