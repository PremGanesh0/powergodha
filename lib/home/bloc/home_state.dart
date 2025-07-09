part of 'home_bloc.dart';

/// {@template home_state}
/// Represents the state of the home screen.
/// {@endtemplate}
class HomeState {
  const HomeState({
    this.status = HomeStatus.initial,
    this.dashboardData,
    this.profitLossReport,
    this.farmAnalytics,
    this.sliderArticles = const [],
    this.notificationCount = 0,
    this.errorMessage,
  });

  /// The current status of the home screen
  final HomeStatus status;

  /// Dashboard data containing overview statistics
  final Map<String, dynamic>? dashboardData;

  /// Latest profit/loss report data
  final Map<String, dynamic>? profitLossReport;

  /// Farm analytics data
  final Map<String, dynamic>? farmAnalytics;

  /// List of slider articles for the carousel
  final List<Map<String, dynamic>> sliderArticles;

  /// Number of unread notifications
  final int notificationCount;

  /// Error message if any operation fails
  final String? errorMessage;

  @override
  int get hashCode {
    return status.hashCode ^
        dashboardData.hashCode ^
        profitLossReport.hashCode ^
        farmAnalytics.hashCode ^
        sliderArticles.hashCode ^
        notificationCount.hashCode ^
        errorMessage.hashCode;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is HomeState &&
        other.status == status &&
        other.dashboardData == dashboardData &&
        other.profitLossReport == profitLossReport &&
        other.farmAnalytics == farmAnalytics &&
        other.sliderArticles == sliderArticles &&
        other.notificationCount == notificationCount &&
        other.errorMessage == errorMessage;
  }

  /// Creates a copy of this state with the given fields replaced with new values.
  HomeState copyWith({
    HomeStatus? status,
    Map<String, dynamic>? dashboardData,
    Map<String, dynamic>? profitLossReport,
    Map<String, dynamic>? farmAnalytics,
    List<Map<String, dynamic>>? sliderArticles,
    int? notificationCount,
    String? errorMessage,
  }) {
    return HomeState(
      status: status ?? this.status,
      dashboardData: dashboardData ?? this.dashboardData,
      profitLossReport: profitLossReport ?? this.profitLossReport,
      farmAnalytics: farmAnalytics ?? this.farmAnalytics,
      sliderArticles: sliderArticles ?? this.sliderArticles,
      notificationCount: notificationCount ?? this.notificationCount,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

/// {@template home_status}
/// Enum representing the different states of the home screen.
/// {@endtemplate}
enum HomeStatus {
  /// Initial state when the home screen is first created
  initial,

  /// Loading state when data is being fetched
  loading,

  /// Success state when data has been loaded successfully
  success,

  /// Error state when an error occurs
  error,

  /// Refreshing state when data is being refreshed
  refreshing,
}
