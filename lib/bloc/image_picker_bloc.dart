import 'package:bloc/bloc.dart';
import 'package:image_picker/image_picker.dart';

// Events
abstract class ImagePickerEvent {}

class PickImageEvent extends ImagePickerEvent {
  final ImageSource source;
  final int? imageQuality;

  PickImageEvent(this.source, {this.imageQuality = 50});
}

class ClearImageEvent extends ImagePickerEvent {}

class UploadImageEvent extends ImagePickerEvent {
  final String imagePath;
  final XFile imageFile;

  UploadImageEvent(this.imagePath, this.imageFile);
}

// States
abstract class ImagePickerState {}

class ImagePickerInitial extends ImagePickerState {}

class ImagePickerLoadingState extends ImagePickerState {}

class ImagePickedState extends ImagePickerState {
  final String imagePath;
  final XFile imageFile;

  ImagePickedState(this.imagePath, this.imageFile);
}

class ImagePickerErrorState extends ImagePickerState {
  final String errorMessage;

  ImagePickerErrorState(this.errorMessage);
}

class ImageUploadLoadingState extends ImagePickerState {
  final String imagePath;
  final XFile imageFile;

  ImageUploadLoadingState(this.imagePath, this.imageFile);
}

class ImageUploadSuccessState extends ImagePickerState {
  final String imagePath;
  final XFile imageFile;

  ImageUploadSuccessState(this.imagePath, this.imageFile);
}

class ImageUploadErrorState extends ImagePickerState {
  final String errorMessage;

  ImageUploadErrorState(this.errorMessage);
}

// Bloc
class ImagePickerBloc extends Bloc<ImagePickerEvent, ImagePickerState> {
  final ImagePicker _imagePicker;

  ImagePickerBloc({ImagePicker? imagePicker})
    : _imagePicker = imagePicker ?? ImagePicker(),
      super(ImagePickerInitial()) {
    on<PickImageEvent>(_onPickImage);
    on<UploadImageEvent>(_uploadImage);
    on<ClearImageEvent>((event, emit) => emit(ImagePickerInitial()));
  }

  Future<void> _uploadImage(
    UploadImageEvent event,
    Emitter<ImagePickerState> emit,
  ) async {
    emit(ImageUploadLoadingState(event.imagePath, event.imageFile));
    try {
      await Future.delayed(Duration(seconds: 5));
      emit(ImageUploadSuccessState(event.imagePath, event.imageFile));
    } catch (e) {
      emit(ImageUploadErrorState(e.toString()));
    }
  }

  Future<void> _onPickImage(
    PickImageEvent event,
    Emitter<ImagePickerState> emit,
  ) async {
    emit(ImagePickerLoadingState());
    try {
      final pickedFile = await _imagePicker.pickImage(
        source: event.source,
        imageQuality: event.imageQuality,
      );

      if (pickedFile != null) {
        emit(ImagePickedState(pickedFile.path, pickedFile));
      } else {
        emit(state is ImagePickedState ? state : ImagePickerInitial());
      }
    } catch (e) {
      emit(ImagePickerErrorState(e.toString()));
    }
  }
}
