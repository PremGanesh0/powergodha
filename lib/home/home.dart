/// Home Module Barrel Export
///
/// This file serves as the main entry point for the home module,
/// providing convenient access to all home-related components.
///
/// **Exported Components:**
/// * [HomePage] - Main authenticated user dashboard
/// * Home-specific UI components and widgets
/// * User information display components
///
/// **Module Structure:**
/// * `view/` - UI components including the main home page
/// * `home.dart` - This barrel export file
///
/// **Usage:**
/// ```dart
/// import 'package:powergodha/home/home.dart';
///
/// // Home components are now available
/// Navigator.pushAndRemoveUntil(
///   context,
///   HomePage.route(),
///   (route) => false,
/// );
/// ```
///
/// **Purpose:**
/// * Provides the main interface for authenticated users
/// * Serves as a dashboard or landing page after login
/// * Demonstrates user data integration with authentication system
/// * Provides logout functionality
/// * Foundation for future authenticated features
///
/// **Integration:**
/// * Integrates with [AuthenticationBloc] for user data and logout
/// * Accessed after successful authentication
/// * Provides user information display
/// * Handles logout flow back to login screen
///
/// **Features:**
/// * User ID display
/// * Logout functionality
/// * Clean, centered layout
/// * Real-time integration with authentication state
/// * Responsive design
///
/// This module represents the authenticated user experience and can be
/// expanded with additional features like user profiles, settings, and
/// application-specific functionality.
library home;

import 'package:powergodha/authentication/authentication.dart' show AuthenticationBloc;
import 'package:powergodha/authentication/bloc/authentication_bloc.dart' show AuthenticationBloc;
import 'package:powergodha/home/home.dart' show HomePage;
import 'package:powergodha/home/view/home_page.dart' show HomePage;

export 'view/home_page.dart';
