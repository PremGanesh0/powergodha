/// Temporary localization helper until Flutter localization is set up.
///
/// This class provides localized strings for the app until the proper
/// Flutter localization system is configured and working.
library;

/// {@template app_strings}
/// Temporary localization helper that provides translated strings
/// based on language code.
///
/// This will be replaced by proper Flutter localization once
/// the build system is set up correctly.
/// {@endtemplate}
class AppStrings {
  /// Gets localized strings for the given language code.
  static Map<String, String> getStrings(String languageCode) {
    switch (languageCode) {
      case 'hi':
        return _hindiStrings;
      case 'te':
        return _teluguStrings;
      case 'mr':
        return _marathiStrings;
      case 'en':
      default:
        return _englishStrings;
    }
  }

  /// English strings (default)
  static const Map<String, String> _englishStrings = {
    'appTitle': 'PowerGodha',
    'selectLanguage': 'Select Language',
    'selectLanguageDescription': 'Please select your preferred language to continue',
    'continueText': 'Continue',
    'welcome': 'Welcome',
    'login': 'Login',
    'signup': 'Sign Up',
    'email': 'Email',
    'password': 'Password',
    'forgotPassword': 'Forgot Password?',
    'dontHaveAccount': "Don't have an account?",
    'alreadyHaveAccount': 'Already have an account?',
    'english': 'English',
    'hindi': 'हिंदी',
    'telugu': 'తెలుగు',
    'marathi': 'मराठी',
  };

  /// Hindi strings
  static const Map<String, String> _hindiStrings = {
    'appTitle': 'पावरगोधा',
    'selectLanguage': 'भाषा चुनें',
    'selectLanguageDescription': 'कृपया जारी रखने के लिए अपनी पसंदीदा भाषा चुनें',
    'continueText': 'जारी रखें',
    'welcome': 'स्वागत',
    'login': 'लॉग इन',
    'signup': 'साइन अप',
    'email': 'ईमेल',
    'password': 'पासवर्ड',
    'forgotPassword': 'पासवर्ड भूल गए?',
    'dontHaveAccount': 'खाता नहीं है?',
    'alreadyHaveAccount': 'पहले से खाता है?',
    'english': 'English',
    'hindi': 'हिंदी',
    'telugu': 'తెలుగు',
    'marathi': 'मराठी',
  };

  /// Telugu strings
  static const Map<String, String> _teluguStrings = {
    'appTitle': 'పవర్గోధా',
    'selectLanguage': 'భాష ఎంచుకోండి',
    'selectLanguageDescription': 'దయచేసి కొనసాగించడానికి మీ ఇష్టమైన భాషను ఎంచుకోండి',
    'continueText': 'కొనసాగించు',
    'welcome': 'స్వాగతం',
    'login': 'లాగిన్',
    'signup': 'సైన్ అప్',
    'email': 'ఇమెయిల్',
    'password': 'పాస్వర్డ్',
    'forgotPassword': 'పాస్వర్డ్ మర్చిపోయారా?',
    'dontHaveAccount': 'ఖాతా లేదా?',
    'alreadyHaveAccount': 'ఇప్పటికే ఖాతా ఉందా?',
    'english': 'English',
    'hindi': 'हिंदी',
    'telugu': 'తెలుగు',
    'marathi': 'मराठी',
  };

  /// Marathi strings
  static const Map<String, String> _marathiStrings = {
    'appTitle': 'पावरगोधा',
    'selectLanguage': 'भाषा निवडा',
    'selectLanguageDescription': 'कृपया पुढे जाण्यासाठी तुमची आवडती भाषा निवडा',
    'continueText': 'सुरू ठेवा',
    'welcome': 'स्वागत',
    'login': 'लॉगिन',
    'signup': 'साइन अप',
    'email': 'ईमेल',
    'password': 'पासवर्ड',
    'forgotPassword': 'पासवर्ड विसरलात?',
    'dontHaveAccount': 'खाते नाही?',
    'alreadyHaveAccount': 'आधीच खाते आहे?',
    'english': 'English',
    'hindi': 'हिंदी',
    'telugu': 'తెలుగు',
    'marathi': 'मराठी',
  };
}
