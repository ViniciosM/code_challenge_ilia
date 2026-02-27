// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Users';

  @override
  String get name => 'Name';

  @override
  String get email => 'Email';

  @override
  String get save => 'Save';

  @override
  String get newUser => 'New User';

  @override
  String get userCreated => 'User created successfully!';

  @override
  String get emailRequired => 'Email is required';

  @override
  String get invalidEmail => 'Invalid email format';

  @override
  String get nameRequired => 'Name is required';

  @override
  String minLength(Object field, Object length) {
    return '$field must have at least $length characters';
  }
}
