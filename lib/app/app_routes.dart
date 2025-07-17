/// Application routing configuration and constants.
///
/// This file defines the central routing system for the PowerGodha application.
/// It provides:
/// * Route name constants for type-safe navigation
/// * Route generation logic with proper error handling
/// * Integration with existing page route methods
/// * Centralized route management for maintainability
///
/// **Architecture:**
/// * Uses static route constants to prevent typos and enable refactoring
/// * Integrates with existing page static route() methods
/// * Provides fallback for unknown routes
/// * Supports route parameters through RouteSettings
///
/// **Usage:**
/// ```dart
/// // Navigate using route constants
/// Navigator.pushNamed(context, AppRoutes.login);
///
/// // Or use the route generator directly
/// MaterialApp(onGenerateRoute: AppRoutes.onGenerateRoute)
/// ```
library;

import 'package:flutter/material.dart';
import 'package:powergodha/breeding/breeding.dart';
import 'package:powergodha/dashboard/pages/dashboard.dart';
import 'package:powergodha/farm/farm.dart';
import 'package:powergodha/forgot_password/view/forgot_password_page.dart';
import 'package:powergodha/home/view/help/how_to_use_app_api.dart';
import 'package:powergodha/home/view/home_page.dart';
import 'package:powergodha/home/view/info/about_app_page_api.dart';
import 'package:powergodha/home/view/info/about_us_page_api.dart';
import 'package:powergodha/home/view/info/contact_us_page_api.dart';
import 'package:powergodha/home/view/premium/on_tap_buy_premium.dart';
import 'package:powergodha/language_selection/language_selection.dart';
import 'package:powergodha/login/view/login_page.dart';
import 'package:powergodha/otp_verification/view/otp_verification_page.dart';
import 'package:powergodha/profile/profile.dart';
import 'package:powergodha/records_reports/daily_records.dart';
import 'package:powergodha/records_reports/reports.dart';
import 'package:powergodha/signup/view/signup_page.dart';
import 'package:powergodha/splash/view/splash_page.dart';

/// {@template app_routes}
/// Central routing configuration for the PowerGodha application.
///
/// This class provides:
/// * Static route name constants for type-safe navigation
/// * Route generation logic that maps route names to pages
/// * Integration with existing page route methods
/// * Error handling for unknown routes
///
/// **Route Constants:**
/// All route names are defined as static constants to:
/// * Prevent typos in route navigation
/// * Enable IDE autocompletion and refactoring
/// * Provide a single source of truth for route names
/// * Make route changes easier to manage
///
/// **Route Generation:**
/// The [onGenerateRoute] method handles mapping route names to actual
/// page widgets using their existing static route() methods. This
/// maintains compatibility with existing code while providing centralized
/// route management.
///
/// **Error Handling:**
/// Unknown routes are handled gracefully by returning a route to the
/// splash page, preventing navigation crashes.
/// {@endtemplate}
abstract final class AppRoutes {
  static const String splash = '/';
  static const String login = '/login';
  static const String signup = '/signup';
  static const String otpVerification = '/otp-verification';
  static const String forgotPassword = '/forgot-password';
  static const String home = '/home';
  static const String languageSelection = '/language-selection';
  static const String profile = '/profile';
  static const String farmInformation = '/farm-information';
  static const String farmInvestmentDetails = '/farm-investment-details';
  static const String pedigreeReport = '/pedigree-report';
  static const String products = '/products';
  static const String reports = '/reports';
  static const String vaccinationDetails = '/vaccination-details';
  static const String aboutApp = '/about-app';
  static const String howToUseApp = '/how-to-use-app';
  static const String aboutUs = '/about-us';
  static const String contactUs = '/contact-us';
  static const String dailyRecords = '/daily-records';
  static const String dashboard = '/dashboard';
  static const String cowDetails = '/cow-details';
  static const String buffaloDetails = '/buffalo-details';
  static const String breedingDetails = '/breeding-details';
  static const String recordHeat = '/record-heat';
  static const String recordDelivery = '/record-delivery';
  static const String recordAi = '/record-ai';
  static const String recordDrying = '/record-drying';
  static const String recordPregnancy = '/record-pregnancy';
  static const String  buyPremium= '/buy-premium';

  /// Generates routes based on [RouteSettings].
  ///
  /// This method serves as the central route generator for the application.
  /// It maps route names to their corresponding page widgets using the
  /// existing static route() methods from each page.
  ///
  /// **Parameters:**
  /// * [settings] - Contains the route name and optional arguments
  ///
  /// **Returns:**
  /// * [Route] - The appropriate route for the requested page
  /// * Falls back to splash page for unknown routes
  ///   /// **Supported Routes:**
  /// * `/` or `/splash` → [SplashPage]
  /// * `/login` → [LoginPage]
  /// * `/signup` → [SignupPage]
  /// * `/forgot-password` → [ForgotPasswordPage]
  /// * `/home` → [HomePage]
  /// * `/language-selection` → [LanguageSelectionPage]
  ///
  /// **Usage:**
  /// ```dart
  /// MaterialApp(
  ///   onGenerateRoute: AppRoutes.onGenerateRoute,
  ///   initialRoute: AppRoutes.splash,
  /// )
  /// ```
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splash:
        return MaterialPageRoute<dynamic>(
          builder: (context) => const SplashPage(),
          settings: settings,
        );
      case login:
        return LoginPage.route();
      case signup:
        return SignupPage.route();
      case otpVerification:
        // Extract arguments for OTP verification
        final args = settings.arguments as Map<String, dynamic>?;
        final phoneNumber = args?['phoneNumber'] as String? ?? '';
        final userId = args?['userId'] as int? ?? 0;
        final otp = args?['otp'] as String? ?? '';
        return OtpVerificationPage.route(
          phoneNumber: phoneNumber,
          userId: userId,
          otp: otp,
        );
      case forgotPassword:
        return ForgotPasswordPage.route();
      case home:
        return HomePage.route();
      case languageSelection:
        return LanguageSelectionPage.route();
      case profile:
        return ProfilePage.route();
      case farmInformation:
        return FarmInformationPage.route();
      case farmInvestmentDetails:
        return FarmInvestmentDetailsPage.route();
      case pedigreeReport:
        return PedigreeReportPage.route();
      case products:
        return ProductsPage.route();
      case reports:
        return ReportsPage.route();
      case vaccinationDetails:
        return VaccinationDetailsPage.route();
      case aboutApp:
        return AboutAppPage.route();
      case howToUseApp:
        return HowToUseAppPage.route();
      case aboutUs:
        return AboutUsPage.route();
      case contactUs:
        return ContactUsPage.route();
      case dailyRecords:
        return DailyRecordsPage.route();
      case dashboard:
        return DashboardPage.route();
      case breedingDetails:
        return BreedingDetailsPage.route();
      case buyPremium:
        return OnTapBuyPremium.route();
      case recordHeat:
        // Extract arguments for record heat page
        final args = settings.arguments as Map<String, dynamic>?;
        final animalType = args?['animalType'] as String? ?? 'Cow';
        final animalNumber = args?['animalNumber'] as String? ?? '0';
        return RecordHeatPage.route(animalType: animalType, animalNumber: animalNumber);
      case recordDelivery:
        // Extract arguments for record delivery page
        final args = settings.arguments as Map<String, dynamic>?;
        final animalType = args?['animalType'] as String? ?? 'Cow';
        final animalNumber = args?['animalNumber'] as String? ?? '0';
        return RecordDeliveryPage.route(animalType: animalType, animalNumber: animalNumber);
      case recordAi:
        // Extract arguments for record AI page
        final args = settings.arguments as Map<String, dynamic>?;
        final animalType = args?['animalType'] as String? ?? 'Cow';
        final animalNumber = args?['animalNumber'] as String? ?? '0';
        return RecordAiPage.route(animalType: animalType, animalNumber: animalNumber);
      case recordDrying:
        // Extract arguments for record drying page
        final args = settings.arguments as Map<String, dynamic>?;
        final animalType = args?['animalType'] as String? ?? 'Cow';
        final animalNumber = args?['animalNumber'] as String? ?? '0';
        return RecordDryingPage.route(animalType: animalType, animalNumber: animalNumber);
      case recordPregnancy:
        // Extract arguments for record pregnancy page
        final args = settings.arguments as Map<String, dynamic>?;
        final animalType = args?['animalType'] as String? ?? 'Cow';
        final animalNumber = args?['animalNumber'] as String? ?? '0';
        return RecordPregnancyPage.route(animalType: animalType, animalNumber: animalNumber);
      default:
        // Fallback to splash page for unknown routes
        return MaterialPageRoute<dynamic>(
          builder: (context) => const SplashPage(),
          settings: settings,
        );
    }
  }
}
