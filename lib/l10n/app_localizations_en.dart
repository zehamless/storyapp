// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get detailTitle => 'Detail Story';

  @override
  String get detailDescription => 'Detail of story:';

  @override
  String get listStories => 'List of Stories';

  @override
  String get logout => 'Logout';

  @override
  String get logoutMessage => 'Are you sure you want to logout?';

  @override
  String get cancel => 'Cancel';

  @override
  String get login => 'Login';

  @override
  String get addStory => 'Add Story';

  @override
  String get loadingStory => 'Loading Stories...';

  @override
  String get errorLoadingStory => 'Error loading stories';

  @override
  String get emptyStory => 'No stories available';

  @override
  String get createStoryMessage => 'Create a new story by tapping the + button';

  @override
  String get refresh => 'Try again';

  @override
  String get emailValidation => 'Please enter a valid email address';

  @override
  String get passwordValidation => 'Password enter your password';

  @override
  String get invalidAuth => 'Invalid email or password';

  @override
  String get loginButton => 'Login';

  @override
  String get registerButton => 'Register';

  @override
  String get successUpload => 'Success upload story';

  @override
  String get uploadTitle => 'Upload Story';

  @override
  String get captionLabel => 'Caption';

  @override
  String get captionHint => 'Write something about your image...';

  @override
  String get captionValidation => 'Please enter a caption';

  @override
  String get gallery => 'Gallery';

  @override
  String get camera => 'Camera';

  @override
  String get registerFailed => 'Register failed';

  @override
  String get nameValidation => 'Please enter your name';
}
