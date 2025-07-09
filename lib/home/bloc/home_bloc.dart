import 'package:bloc/bloc.dart';
import 'package:powergodha/shared/api/api_models.dart';
import 'package:powergodha/shared/localization_service.dart';
import 'package:powergodha/shared/retrofit_client.dart';
import 'package:powergodha/shared/services/notification_count_service.dart';
import 'package:powergodha/shared/services/slider_articles_service.dart';

part 'home_event.dart';
part 'home_state.dart';

/// {@template home_bloc}
/// BLoC that manages the state of the home screen.
///
/// This BLoC handles:
/// * Loading dashboard data
/// * Fetching profit/loss reports
/// * Getting farm analytics
/// * Handling error states
/// * Refreshing data
///
/// **Usage:**
/// ```dart
/// // In your widget
/// BlocProvider(
///   create: (context) => HomeBloc()..add(const HomeStarted()),
///   child: HomePage(),
/// );
///
/// // Trigger events
/// context.read<HomeBloc>().add(const GetProfitLossReport());
/// ```
/// {@endtemplate}
class HomeBloc extends Bloc<HomeEvent, HomeState> {
  /// {@macro home_bloc}
  HomeBloc({
    RetrofitClient? apiClient,
  }) : _apiClient = apiClient ?? RetrofitClient(),
       super(const HomeState()) {
    on<HomeStarted>(_onHomeStarted);
    on<GetProfitLossReport>(_onGetProfitLossReport);
    on<GetSliderArticles>(_onGetSliderArticles);
    on<GetNotificationCount>(_onGetNotificationCount);
    on<GetDashboardData>(_onGetDashboardData);
    on<GetFarmAnalytics>(_onGetFarmAnalytics);
    on<RefreshHomeData>(_onRefreshHomeData);
  }

  final RetrofitClient _apiClient;

  /// Helper method to get language ID from language code
  String _getLanguageId(String languageCode) {
    switch (languageCode) {
      case 'en':
        return '1';
      case 'hi':
        return '2';
      case 'te':
        return '3';
      case 'mr':
        return '4';
      default:
        return '2'; // Default to Hindi
    }
  }

  /// Private method to get notification count
  Future<int> _getNotificationCount(String languageId) async {
    try {
      final service = NotificationCountService();
      final notificationCount = await service.getNotificationCount(languageId);

      return notificationCount.count;
    } catch (e) {
      print('❌ Notification Count API Exception: $e'); // Debug log
      throw Exception('Notification count API call failed: $e');
    }
  }

  /// Private method to get profit/loss report
  Future<Map<String, dynamic>?> _getProfitLossReport() async {
    try {
      final response = await _apiClient.getLatestProfitLossReport();

      print('🔍 Raw API Response: $response'); // Debug log
      print('🔍 Response.success: ${response.success}'); // Debug log
      print('🔍 Response.data: ${response.data}'); // Debug log
      print('🔍 Response.message: ${response.message}'); // Debug log
      print('🔍 Response.status: ${response.status}'); // Debug log

      // Now the ApiResponse.success getter properly checks status == 200 and message == "success"
      if (response.success && response.data != null) {
        final data = response.data as Map<String, dynamic>;
        print('✅ Profit/Loss API Success: $data'); // Debug log

        // Create a structured response that matches the expected format
        final profitLossData = ProfitLossData.fromJson(data);
        print('📊 Parsed Profit/Loss Data: $profitLossData'); // Debug log

        // Return the entire response structure to maintain UI compatibility
        return {'data': data, 'message': response.message, 'status': response.status};
      }

      print('❌ Profit/Loss API Failed: ${response.message}'); // Debug log
      throw Exception(response.message.isNotEmpty ? response.message : 'Unknown API error');
    } catch (e) {
      print('❌ Profit/Loss API Exception: $e'); // Debug log
      throw Exception('Profit/Loss report API call failed: $e');
    }
  }

  /// Private method to get slider articles
  Future<List<Map<String, dynamic>>> _getSliderArticles(String languageId) async {
    try {
      final service = SliderArticlesService();
      final articles = await service.getSliderArticles(languageId);

      // Convert SliderArticle objects to Maps for compatibility
      return articles.map((article) => article.toJson()).toList();
    } catch (e) {
      print('❌ Slider Articles API Exception: $e'); // Debug log
      throw Exception('Slider articles API call failed: $e');
    }
  }

  /// Handles the [GetDashboardData] event
  Future<void> _onGetDashboardData(
    GetDashboardData event,
    Emitter<HomeState> emit,
  ) async {
    // TODO: Implement later
    emit(state.copyWith(
      status: HomeStatus.error,
      errorMessage: 'Dashboard API not implemented yet',
    ));

    // emit(state.copyWith(status: HomeStatus.loading));
    //
    // try {
    //   final dashboard = await _getDashboardData();
    //
    //   emit(state.copyWith(
    //     status: HomeStatus.success,
    //     dashboardData: dashboard,
    //   ));
    // } catch (e) {
    //   emit(state.copyWith(
    //     status: HomeStatus.error,
    //     errorMessage: 'Failed to load dashboard data: ${e.toString()}',
    //   ));
    // }
  }

  /// Handles the [GetFarmAnalytics] event
  Future<void> _onGetFarmAnalytics(
    GetFarmAnalytics event,
    Emitter<HomeState> emit,
  ) async {
    // TODO: Implement later
    emit(state.copyWith(
      status: HomeStatus.error,
      errorMessage: 'Farm Analytics API not implemented yet',
    ));

    // emit(state.copyWith(status: HomeStatus.loading));
    //
    // try {
    //   final analytics = await _getFarmAnalytics();
    //
    //   emit(state.copyWith(
    //     status: HomeStatus.success,
    //     farmAnalytics: analytics,
    //   ));
    // } catch (e) {
    //   emit(state.copyWith(
    //     status: HomeStatus.error,
    //     errorMessage: 'Failed to load farm analytics: ${e.toString()}',
    //   ));
    // }
  }

  /// Handles the [GetNotificationCount] event
  Future<void> _onGetNotificationCount(
    GetNotificationCount event,
    Emitter<HomeState> emit,
  ) async {
    try {
      final count = await _getNotificationCount(event.languageId);

      emit(state.copyWith(
        notificationCount: count,
      ));
    } catch (e) {
      print('❌ Notification Count Error: $e'); // Debug log
      // Don't fail the entire state for notification count
      // Just log the error and continue
    }
  }

  /// Handles the [GetProfitLossReport] event
  Future<void> _onGetProfitLossReport(GetProfitLossReport event,
    Emitter<HomeState> emit,
  ) async {
    emit(state.copyWith(status: HomeStatus.loading));

    try {
      final report = await _getProfitLossReport();

      emit(state.copyWith(
        status: HomeStatus.success,
        profitLossReport: report,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: HomeStatus.error,
          errorMessage: 'Failed to load profit/loss report: $e',
      ));
    }
  }

  /// Handles the [GetSliderArticles] event
  Future<void> _onGetSliderArticles(GetSliderArticles event, Emitter<HomeState> emit) async {
    try {
      final articles = await _getSliderArticles(event.languageId);

      emit(state.copyWith(sliderArticles: articles));
    } catch (e) {
      print('❌ Slider Articles Error: $e'); // Debug log
      // Don't fail the entire state for slider articles
      // Just log the error and continue
    }
  }

  /// Handles the [HomeStarted] event
  Future<void> _onHomeStarted(HomeStarted event, Emitter<HomeState> emit) async {
    emit(state.copyWith(status: HomeStatus.loading));

    try {
      // For now, load profit/loss report and slider articles
      final profitLossReport = await _getProfitLossReport();

      // Get current language and load slider articles and notification count
      final currentLanguage = await LocalizationService.getCurrentLanguage();
      final languageId = _getLanguageId(currentLanguage);
      final sliderArticles = await _getSliderArticles(languageId);
      final notificationCount = await _getNotificationCount(languageId);

      emit(
        state.copyWith(
          status: HomeStatus.success,
          profitLossReport: profitLossReport,
          sliderArticles: sliderArticles,
          notificationCount: notificationCount,
        ),
      );
    } catch (e) {
      emit(state.copyWith(status: HomeStatus.error, errorMessage: 'Failed to load home data: $e'));
    }
  }

  /// Handles the [RefreshHomeData] event
  Future<void> _onRefreshHomeData(RefreshHomeData event, Emitter<HomeState> emit) async {
    emit(state.copyWith(status: HomeStatus.refreshing));

    try {
      // Refresh profit/loss report, slider articles, and notification count
      final profitLossReport = await _getProfitLossReport();

      // Get current language and refresh slider articles and notification count
      final currentLanguage = await LocalizationService.getCurrentLanguage();
      final languageId = _getLanguageId(currentLanguage);
      final sliderArticles = await _getSliderArticles(languageId);
      final notificationCount = await _getNotificationCount(languageId);

      emit(
        state.copyWith(
          status: HomeStatus.success,
          profitLossReport: profitLossReport,
          sliderArticles: sliderArticles,
          notificationCount: notificationCount,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(status: HomeStatus.error, errorMessage: 'Failed to refresh home data: $e'),
      );
    }
  }

  // TODO: Implement these methods later when needed

  // /// Private method to get dashboard data
  // Future<Map<String, dynamic>?> _getDashboardData() async {
  //   try {
  //     final response = await _apiClient.getDashboard();
  //
  //     if (response.success && response.data != null) {
  //       return response.data as Map<String, dynamic>;
  //     } else {
  //       throw Exception(response.message);
  //     }
  //   } catch (e) {
  //     throw Exception('Dashboard API call failed: $e');
  //   }
  // }

  // /// Private method to get farm analytics
  // Future<Map<String, dynamic>?> _getFarmAnalytics() async {
  //   try {
  //     final response = await _apiClient.getDashboardAnalytics('monthly', null);
  //
  //     if (response.success && response.data != null) {
  //       return response.data as Map<String, dynamic>;
  //     } else {
  //       throw Exception(response.message);
  //     }
  //   } catch (e) {
  //     throw Exception('Farm analytics API call failed: $e');
  //   }
  // }
}
