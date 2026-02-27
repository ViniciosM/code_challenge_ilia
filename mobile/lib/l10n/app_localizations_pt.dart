// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get appTitle => 'Usuários';

  @override
  String get name => 'Nome';

  @override
  String get email => 'Email';

  @override
  String get save => 'Salvar';

  @override
  String get newUser => 'Novo Usuário';

  @override
  String get userCreated => 'Usuário cadastrado com sucesso!';

  @override
  String get emailRequired => 'Email é obrigatório';

  @override
  String get invalidEmail => 'Email inválido';

  @override
  String get nameRequired => 'Nome é obrigatório';

  @override
  String minLength(Object field, Object length) {
    return '$field deve ter pelo menos $length caracteres';
  }
}
