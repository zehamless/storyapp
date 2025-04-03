import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_id.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('id')
  ];

  /// No description provided for @detailTitle.
  ///
  /// In en, this message translates to:
  /// **'Detail Story'**
  String get detailTitle;

  /// No description provided for @detailDescription.
  ///
  /// In en, this message translates to:
  /// **'This is the detail page of the story.'**
  String get detailDescription;

  /// No description provided for @listStories.
  ///
  /// In en, this message translates to:
  /// **'List of Stories'**
  String get listStories;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// No description provided for @logoutMessage.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to logout?'**
  String get logoutMessage;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// No description provided for @addStory.
  ///
  /// In en, this message translates to:
  /// **'Add Story'**
  String get addStory;

  /// No description provided for @loadingStory.
  ///
  /// In en, this message translates to:
  /// **'Loading Stories...'**
  String get loadingStory;

  /// No description provided for @errorLoadingStory.
  ///
  /// In en, this message translates to:
  /// **'Error loading stories'**
  String get errorLoadingStory;

  /// No description provided for @emptyStory.
  ///
  /// In en, this message translates to:
  /// **'No stories available'**
  String get emptyStory;

  /// No description provided for @createStoryMessage.
  ///
  /// In en, this message translates to:
  /// **'Create a new story by tapping the + button'**
  String get createStoryMessage;

  /// No description provided for @refresh.
  ///
  /// In en, this message translates to:
  /// **'Try again'**
  String get refresh;

  /// No description provided for @emailValidation.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email address'**
  String get emailValidation;

  /// No description provided for @passwordValidation.
  ///
  /// In en, this message translates to:
  /// **'Password enter your password'**
  String get passwordValidation;

  /// No description provided for @invalidAuth.
  ///
  /// In en, this message translates to:
  /// **'Invalid email or password'**
  String get invalidAuth;

  /// No description provided for @loginButton.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get loginButton;

  /// No description provided for @registerButton.
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get registerButton;

  /// No description provided for @successUpload.
  ///
  /// In en, this message translates to:
  /// **'Success upload story'**
  String get successUpload;

  /// No description provided for @uploadTitle.
  ///
  /// In en, this message translates to:
  /// **'Upload Story'**
  String get uploadTitle;

  /// No description provided for @captionLabel.
  ///
  /// In en, this message translates to:
  /// **'Caption'**
  String get captionLabel;

  /// No description provided for @captionHint.
  ///
  /// In en, this message translates to:
  /// **'Write something about your image...'**
  String get captionHint;

  /// No description provided for @captionValidation.
  ///
  /// In en, this message translates to:
  /// **'Please enter a caption'**
  String get captionValidation;

  /// No description provided for @gallery.
  ///
  /// In en, this message translates to:
  /// **'Gallery'**
  String get gallery;

  /// No description provided for @camera.
  ///
  /// In en, this message translates to:
  /// **'Camera'**
  String get camera;

  /// No description provided for @registerFailed.
  ///
  /// In en, this message translates to:
  /// **'Register failed'**
  String get registerFailed;

  /// No description provided for @nameValidation.
  ///
  /// In en, this message translates to:
  /// **'Please enter your name'**
  String get nameValidation;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'id'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en': return AppLocalizationsEn();
    case 'id': return AppLocalizationsId();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
