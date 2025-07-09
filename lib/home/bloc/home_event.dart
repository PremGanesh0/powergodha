part of 'home_bloc.dart';

/// {@template home_event}
/// Base class for all home screen events.
/// {@endtemplate}
abstract class HomeEvent {
  const HomeEvent();
}

/// {@template home_started}
/// Event triggered when the home screen is initialized.
/// This loads initial data like dashboard info and recent reports.
/// {@endtemplate}
class HomeStarted extends HomeEvent {
  const HomeStarted();
}

/// {@template get_profit_loss_report}
/// Event to fetch the latest profit/loss report.
/// This is triggered when user taps on the profit/loss card.
/// {@endtemplate}
class GetProfitLossReport extends HomeEvent {
  const GetProfitLossReport();
}

/// {@template get_dashboard_data}
/// Event to fetch dashboard statistics and overview data.
/// {@endtemplate}
class GetDashboardData extends HomeEvent {
  const GetDashboardData();
}

/// {@template get_farm_analytics}
/// Event to fetch farm analytics data.
/// {@endtemplate}
class GetFarmAnalytics extends HomeEvent {
  const GetFarmAnalytics();
}

/// {@template refresh_home_data}
/// Event to refresh all home screen data.
/// This is typically triggered by pull-to-refresh.
/// {@endtemplate}
class RefreshHomeData extends HomeEvent {
  const RefreshHomeData();
}

/// {@template get_slider_articles}
/// Event to fetch slider articles for the carousel.
/// {@endtemplate}
class GetSliderArticles extends HomeEvent {
  const GetSliderArticles({
    required this.languageId,
  });

  /// The language ID to fetch articles for.
  final String languageId;
}

/// {@template get_notification_count}
/// Event to fetch notification count.
/// {@endtemplate}
class GetNotificationCount extends HomeEvent {
  const GetNotificationCount({
    required this.languageId,
  });

  /// The language ID to fetch notification count for.
  final String languageId;
}
