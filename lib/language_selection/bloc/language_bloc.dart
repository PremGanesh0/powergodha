import 'package:bloc/bloc.dart';
import 'package:powergodha/shared/api/api_models.dart';
import 'package:powergodha/shared/localization_service.dart';
import 'package:powergodha/shared/retrofit_client.dart';

part 'language_event.dart';
part 'language_state.dart';

/// {@template language_bloc}
/// BLoC that manages language selection and synchronization with the server.
///
/// This BLoC handles:
/// * Loading available languages
/// * Changing language locally
/// * Syncing language preference with the server
/// * Handling error states
/// * Maintaining language state consistency
///
/// **Usage:**
/// ```dart
/// // In your widget
/// BlocProvider(
///   create: (context) => LanguageBloc()..add(const LanguageStarted()),
///   child: LanguageSelectionPage(),
/// );
///
/// // Change language
/// context.read<LanguageBloc>().add(const LanguageChangedLocally(
///   languageCode: 'hi',
///   languageId: '2',
/// ));
/// ```
/// {@endtemplate}
class LanguageBloc extends Bloc<LanguageEvent, LanguageState> {
  /// {@macro language_bloc}
  LanguageBloc({
    RetrofitClient? apiClient,
  }) : _apiClient = apiClient ?? RetrofitClient(),
       super(const LanguageState()) {
    on<LanguageStarted>(_onLanguageStarted);
    on<LanguageChangedLocally>(_onLanguageChangedLocally);
    on<LanguageUpdatedOnServer>(_onLanguageUpdatedOnServer);
    on<LanguageSyncRequested>(_onLanguageSyncRequested);
  }

  /// Supported languages with their API IDs
  static const List<SupportedLanguage> _supportedLanguages = [
    SupportedLanguage(
      code: 'en',
      id: '1',
      name: 'English',
      nativeName: 'English',
    ),
    SupportedLanguage(
      code: 'hi',
      id: '2',
      name: 'Hindi',
      nativeName: 'हिंदी',
    ),
    SupportedLanguage(
      code: 'te',
      id: '3',
      name: 'Telugu',
      nativeName: 'తెలుగు',
    ),
    SupportedLanguage(
      code: 'mr',
      id: '4',
      name: 'Marathi',
      nativeName: 'मराठी',
    ),
  ];

  final RetrofitClient _apiClient;

  /// Gets the supported language by code
  SupportedLanguage? getLanguageByCode(String code) {
    try {
      return _supportedLanguages.firstWhere((lang) => lang.code == code);
    } catch (e) {
      return null;
    }
  }

  /// Gets the supported language by ID
  SupportedLanguage? getLanguageById(String id) {
    try {
      return _supportedLanguages.firstWhere((lang) => lang.id == id);
    } catch (e) {
      return null;
    }
  }

  /// Handles the [LanguageChangedLocally] event
  Future<void> _onLanguageChangedLocally(
    LanguageChangedLocally event,
    Emitter<LanguageState> emit,
  ) async {
    try {
      // Update local language
      await LocalizationService.setLanguage(event.languageCode);

      emit(
        state.copyWith(
          status: LanguageStatus.success,
          selectedLanguageCode: event.languageCode,
          selectedLanguageId: event.languageId,
        ),
      );

      // Automatically sync with server
      add(LanguageUpdatedOnServer(languageId: event.languageId));
    } catch (e) {
      emit(
        state.copyWith(
          status: LanguageStatus.error,
          errorMessage: 'Failed to change language locally: $e',
        ),
      );
    }
  }

  /// Handles the [LanguageStarted] event
  Future<void> _onLanguageStarted(
    LanguageStarted event,
    Emitter<LanguageState> emit,
  ) async {
    emit(state.copyWith(status: LanguageStatus.loading));

    try {
      // Load the current language from local storage
      final currentLanguageCode = await LocalizationService.getCurrentLanguage();
      final currentLanguage = _supportedLanguages.firstWhere(
        (lang) => lang.code == currentLanguageCode,
        orElse: () => _supportedLanguages.first,
      );

      emit(state.copyWith(
        status: LanguageStatus.success,
        selectedLanguageCode: currentLanguage.code,
        selectedLanguageId: currentLanguage.id,
        availableLanguages: _supportedLanguages,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: LanguageStatus.error,
          errorMessage: 'Failed to load language preferences: $e',
      ));
    }
  }

  /// Handles the [LanguageSyncRequested] event
  Future<void> _onLanguageSyncRequested(
    LanguageSyncRequested event,
    Emitter<LanguageState> emit,
  ) async {
    if (state.selectedLanguageId != null) {
      add(LanguageUpdatedOnServer(languageId: state.selectedLanguageId!));
    }
  }

  /// Handles the [LanguageUpdatedOnServer] event
  Future<void> _onLanguageUpdatedOnServer(
    LanguageUpdatedOnServer event,
    Emitter<LanguageState> emit,
  ) async {
    emit(state.copyWith(status: LanguageStatus.syncing));

    try {
      final request = UserLanguageUpdateRequest(languageId: event.languageId);
      final response = await _apiClient.updateUserLanguage(request.toJson());

      print('🌐 Language Update API Response: $response'); // Debug log

      if (response.success) {
        print('✅ Language updated on server successfully'); // Debug log
        emit(state.copyWith(
          status: LanguageStatus.success,
          selectedLanguageId: event.languageId,
        ));
      } else {
        print('❌ Language update failed: ${response.message}'); // Debug log
        emit(state.copyWith(
          status: LanguageStatus.error,
          errorMessage: 'Failed to update language on server: ${response.message}',
        ));
      }
    } catch (e) {
      print('❌ Language update exception: $e'); // Debug log
      emit(state.copyWith(
        status: LanguageStatus.error,
          errorMessage: 'Failed to update language on server: $e',
      ));
    }
  }
}
