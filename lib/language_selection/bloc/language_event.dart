part of 'language_bloc.dart';

/// {@template language_event}
/// Base class for all language-related events.
/// {@endtemplate}
abstract class LanguageEvent {
  const LanguageEvent();
}

/// {@template language_started}
/// Event triggered when the language feature is initialized.
/// {@endtemplate}
class LanguageStarted extends LanguageEvent {
  const LanguageStarted();
}

/// {@template language_changed_locally}
/// Event triggered when the user changes language locally.
/// {@endtemplate}
class LanguageChangedLocally extends LanguageEvent {
  const LanguageChangedLocally({
    required this.languageCode,
    required this.languageId,
  });

  /// The language code (e.g., 'en', 'hi', 'te', 'mr').
  final String languageCode;

  /// The language ID for the API.
  final String languageId;
}

/// {@template language_updated_on_server}
/// Event triggered to update the language preference on the server.
/// {@endtemplate}
class LanguageUpdatedOnServer extends LanguageEvent {
  const LanguageUpdatedOnServer({
    required this.languageId,
  });

  /// The language ID to update on the server.
  final String languageId;
}

/// {@template language_sync_requested}
/// Event triggered to sync local language with server.
/// {@endtemplate}
class LanguageSyncRequested extends LanguageEvent {
  const LanguageSyncRequested();
}
