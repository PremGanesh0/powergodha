part of 'language_bloc.dart';

/// {@template language_state}
/// Represents the state of the language selection and synchronization.
/// {@endtemplate}
class LanguageState {
  const LanguageState({
    this.status = LanguageStatus.initial,
    this.selectedLanguageCode,
    this.selectedLanguageId,
    this.availableLanguages = const [],
    this.errorMessage,
  });

  /// The current status of the language operations.
  final LanguageStatus status;

  /// The currently selected language code (e.g., 'en', 'hi').
  final String? selectedLanguageCode;

  /// The currently selected language ID for API calls.
  final String? selectedLanguageId;

  /// List of available languages.
  final List<SupportedLanguage> availableLanguages;

  /// Error message if any operation fails.
  final String? errorMessage;

  @override
  int get hashCode {
    return status.hashCode ^
        selectedLanguageCode.hashCode ^
        selectedLanguageId.hashCode ^
        availableLanguages.hashCode ^
        errorMessage.hashCode;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is LanguageState &&
        other.status == status &&
        other.selectedLanguageCode == selectedLanguageCode &&
        other.selectedLanguageId == selectedLanguageId &&
        other.availableLanguages == availableLanguages &&
        other.errorMessage == errorMessage;
  }

  /// Creates a copy of this state with the given fields replaced with new values.
  LanguageState copyWith({
    LanguageStatus? status,
    String? selectedLanguageCode,
    String? selectedLanguageId,
    List<SupportedLanguage>? availableLanguages,
    String? errorMessage,
  }) {
    return LanguageState(
      status: status ?? this.status,
      selectedLanguageCode: selectedLanguageCode ?? this.selectedLanguageCode,
      selectedLanguageId: selectedLanguageId ?? this.selectedLanguageId,
      availableLanguages: availableLanguages ?? this.availableLanguages,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

/// {@template language_status}
/// Enum representing the different states of language operations.
/// {@endtemplate}
enum LanguageStatus {
  /// Initial state when the language feature is first created.
  initial,

  /// Loading state when language operations are in progress.
  loading,

  /// Success state when language operations complete successfully.
  success,

  /// Error state when language operations fail.
  error,

  /// Syncing state when updating language preference on server.
  syncing,
}

/// {@template supported_language}
/// Represents a supported language in the application.
/// {@endtemplate}
class SupportedLanguage {
  const SupportedLanguage({
    required this.code,
    required this.id,
    required this.name,
    required this.nativeName,
  });

  /// Language code (e.g., 'en', 'hi', 'te', 'mr').
  final String code;

  /// Language ID for API calls.
  final String id;

  /// Language name in English.
  final String name;

  /// Language name in native script.
  final String nativeName;

  @override
  int get hashCode {
    return code.hashCode ^ id.hashCode ^ name.hashCode ^ nativeName.hashCode;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is SupportedLanguage &&
        other.code == code &&
        other.id == id &&
        other.name == name &&
        other.nativeName == nativeName;
  }

  @override
  String toString() {
    return 'SupportedLanguage(code: $code, id: $id, name: $name, nativeName: $nativeName)';
  }
}
