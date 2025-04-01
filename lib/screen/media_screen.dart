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
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    captionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Post Story",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: BlocProvider(
        create: (context) => ImagePickerBloc(),
        child: BlocConsumer<ImagePickerBloc, ImagePickerState>(
          listener: (context, state) {
            if (state is ImageUploadSuccessState) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Image uploaded successfully!")),
              );
              widget.onClose();
            } else if (state is ImageUploadErrorState) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(state.errorMessage)));
            }
          },
          builder: (context, state) {
            return Form(
              key: formKey,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      flex: 4,
                      child: _buildImagePreview(context, state),
                    ),
                    const SizedBox(height: 16),

                    TextFormField(
                      controller: captionController,
                      minLines: 2,
                      maxLines: 3,
                      decoration: const InputDecoration(
                        labelText: "Caption",
                        border: OutlineInputBorder(),
                        hintText: "Write something about your image...",
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter a caption";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    if (state is ImagePickedState ||
                        state is ImageUploadLoadingState)
                      ElevatedButton.icon(
                        onPressed:
                            state is ImageUploadLoadingState
                                ? null
                                : () {
                                  if (formKey.currentState!.validate()) {
                                    context.read<ImagePickerBloc>().add(
                                      UploadImageEvent(
                                        (state as ImagePickedState).imagePath,
                                        (state).imageFile,
                                        captionController.text,
                                      ),
                                    );
                                  }
                                },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          backgroundColor: Theme.of(context).primaryColor,
                          foregroundColor: Colors.white,
                        ),
                        icon:
                            state is ImageUploadLoadingState
                                ? const SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                )
                                : const Icon(
                                  Icons.cloud_upload,
                                  color: Colors.white,
                                ),
                        label: Text(
                          state is ImageUploadLoadingState
                              ? "UPLOADING..."
                              : "UPLOAD",
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    const SizedBox(height: 8),

                    // Gallery/Camera button row
                    Row(
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
                  ],
                ),
              ),
            );
          },
        ),
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

      return ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Stack(
          fit: StackFit.expand,
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
              Container(
                color: Colors.black.withOpacity(0.3),
                child: const Center(
                  child: CircularProgressIndicator(color: Colors.white),
                ),
              ),
          ],
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Center(
        child: Icon(Icons.add_photo_alternate, size: 80, color: Colors.grey),
      ),
    );
  }
}
