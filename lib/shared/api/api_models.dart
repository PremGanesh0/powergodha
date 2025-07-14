/// Common API Response Models
///
/// This file contains the base response models used across all API endpoints.
/// These models provide a consistent structure for handling API responses.
library;

import 'dart:ui';

/// {@template about_app_data}
/// Model for about app data response.
///
/// This model represents the structure of the about app data API response,
/// which includes various types of content like 'about_us', 'contact_us', etc.
/// {@endtemplate}
class AboutAppData {
  /// Creates an [AboutAppData] instance.
  const AboutAppData({required this.type, required this.languageId, required this.content});

  /// Factory constructor for JSON deserialization.
  factory AboutAppData.fromJson(Map<String, dynamic> json) {
    return AboutAppData(
      type: json['type'] as String? ?? '',
      languageId: json['language_id'] as int? ?? 0,
      content: json['content'] as String? ?? '',
    );
  }

  /// The type of content (e.g., 'about_us', 'contact_us').
  final String type;

  /// The language ID for the content.
  final int languageId;

  /// The HTML content.
  final String content;

  @override
  int get hashCode => type.hashCode ^ languageId.hashCode ^ content.hashCode;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AboutAppData &&
        other.type == type &&
        other.languageId == languageId &&
        other.content == content;
  }

  /// Converts the instance to JSON.
  Map<String, dynamic> toJson() {
    return {'type': type, 'language_id': languageId, 'content': content};
  }

  @override
  String toString() {
    return 'AboutAppData(type: $type, languageId: $languageId, content: ${content.substring(0, content.length > 50 ? 50 : content.length)}...)';
  }
}

/// {@template api_error}
/// API error response structure.
/// {@endtemplate}
class ApiError {
  /// Creates an [ApiError] instance.
  const ApiError({required this.message, required this.status, this.details});

  /// Factory constructor for JSON deserialization.
  factory ApiError.fromJson(Map<String, dynamic> json) {
    return ApiError(
      message: json['message'] as String? ?? 'Unknown error',
      status: json['status'] as int? ?? 500,
      details: json['details'] as String?,
    );
  }

  /// Error message.
  final String message;

  /// HTTP status code.
  final int status;

  /// Additional error details.
  final String? details;

  /// Converts the instance to JSON.
  Map<String, dynamic> toJson() {
    return {'message': message, 'status': status, 'details': details};
  }

  @override
  String toString() {
    return 'ApiError(message: $message, status: $status, details: $details)';
  }
}

/// {@template api_response}
/// Base API response wrapper that matches the backend response structure.
///
/// All APIs return a consistent structure with:
/// - `data`: The actual response payload
/// - `message`: Success/error message from the server
/// - `status`: HTTP status code
/// {@endtemplate}
class ApiResponse {
  /// Creates an [ApiResponse] instance.
  const ApiResponse({
    required this.data,
    required this.message,
    required this.status,
  });

  /// Factory constructor for JSON deserialization.
  factory ApiResponse.fromJson(Map<String, dynamic> json) {
    return ApiResponse(
      data: json['data'],
      message: json['message'] as String? ?? '',
      status: json['status'] as int? ?? 500,
    );
  }

  /// The response data payload.
  final dynamic data;

  /// Response message from the API.
  final String message;

  /// HTTP status code.
  final int status;

  /// Whether the API request failed.
  bool get failed => !success;

  /// Whether the response indicates an error.
  bool get hasError => status >= 400;

  @override
  int get hashCode => data.hashCode ^ message.hashCode ^ status.hashCode;

  /// Whether the API request was successful.
  /// Success is determined by status code 200 and message "success".
  bool get success => status == 200 && message.toLowerCase() == 'success';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ApiResponse &&
        other.data == data &&
        other.message == message &&
        other.status == status;
  }

  /// Converts the instance to JSON.
  Map<String, dynamic> toJson() {
    return {
      'data': data,
      'message': message,
      'status': status,
    };
  }

  @override
  String toString() {
    return 'ApiResponse(data: $data, message: $message, status: $status, success: $success)';
  }
}

/// {@template notification_count}
/// Model for notification count data from the API.
/// {@endtemplate}
class NotificationCount {
  /// Creates a [NotificationCount] instance.
  const NotificationCount({required this.count});

  /// Factory constructor for JSON deserialization.
  factory NotificationCount.fromJson(Map<String, dynamic> json) {
    return NotificationCount(count: json['count'] as int? ?? 0);
  }

  /// The number of unread notifications.
  final int count;

  @override
  int get hashCode => count.hashCode;

  /// Whether there are any unread notifications.
  bool get hasNotifications => count > 0;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is NotificationCount && other.count == count;
  }

  /// Converts the instance to JSON.
  Map<String, dynamic> toJson() {
    return {'count': count};
  }

  @override
  String toString() {
    return 'NotificationCount(count: $count)';
  }
}

/// {@template pagination_meta}
/// Pagination metadata for paginated API responses.
/// {@endtemplate}
class PaginationMeta {
  /// Creates a [PaginationMeta] instance.
  const PaginationMeta({
    required this.currentPage,
    required this.totalPages,
    required this.totalItems,
    required this.itemsPerPage,
    required this.hasNextPage,
    required this.hasPreviousPage,
  });

  /// Factory constructor for JSON deserialization.
  factory PaginationMeta.fromJson(Map<String, dynamic> json) {
    return PaginationMeta(
      currentPage: json['current_page'] as int? ?? 1,
      totalPages: json['total_pages'] as int? ?? 1,
      totalItems: json['total_items'] as int? ?? 0,
      itemsPerPage: json['items_per_page'] as int? ?? 20,
      hasNextPage: json['has_next_page'] as bool? ?? false,
      hasPreviousPage: json['has_previous_page'] as bool? ?? false,
    );
  }

  /// Current page number (1-based).
  final int currentPage;

  /// Total number of pages.
  final int totalPages;

  /// Total number of items across all pages.
  final int totalItems;

  /// Number of items per page.
  final int itemsPerPage;

  /// Whether there is a next page available.
  final bool hasNextPage;

  /// Whether there is a previous page available.
  final bool hasPreviousPage;

  /// Converts the instance to JSON.
  Map<String, dynamic> toJson() {
    return {
      'current_page': currentPage,
      'total_pages': totalPages,
      'total_items': totalItems,
      'items_per_page': itemsPerPage,
      'has_next_page': hasNextPage,
      'has_previous_page': hasPreviousPage,
    };
  }

  @override
  String toString() {
    return 'PaginationMeta(currentPage: $currentPage, totalPages: $totalPages, totalItems: $totalItems)';
  }
}

/// {@template profit_loss_data}
/// Profit/Loss report data structure.
/// {@endtemplate}
class ProfitLossData {
  /// Creates a [ProfitLossData] instance.
  const ProfitLossData({
    required this.date,
    required this.profitLoss,
    required this.key,
  });

  /// Factory constructor for JSON deserialization.
  factory ProfitLossData.fromJson(Map<String, dynamic> json) {
    return ProfitLossData(
      date: json['date'] as String? ?? '',
      profitLoss: json['profit_loss'] as String? ?? '0',
      key: json['key'] as String? ?? 'unknown',
    );
  }

  /// The date of the profit/loss report.
  final String date;

  /// The profit/loss amount as a string.
  final String profitLoss;

  /// The type of report: 'profit' or 'loss'.
  final String key;

  /// The absolute amount (without negative sign).
  double get absoluteAmount => profitLossAmount.abs();

  /// Whether this is a loss report.
  bool get isLoss => key.toLowerCase() == 'loss';

  /// Whether this is a profit report.
  bool get isProfit => key.toLowerCase() == 'profit';

  /// The profit/loss amount as a double.
  double get profitLossAmount {
    try {
      return double.parse(profitLoss);
    } catch (e) {
      return 0;
    }
  }

  /// Converts the instance to JSON.
  Map<String, dynamic> toJson() {
    return {
      'date': date,
      'profit_loss': profitLoss,
      'key': key,
    };
  }

  @override
  String toString() {
    return 'ProfitLossData(date: $date, profitLoss: $profitLoss, key: $key)';
  }
}

/// {@template slider_article}
/// Model for slider article data from the API.
/// {@endtemplate}
class SliderArticle {
  /// Creates a [SliderArticle] instance.
  const SliderArticle({
    required this.sliderArticleId,
    required this.languageId,
    required this.name,
    required this.image,
    required this.webUrl,
    required this.subtitle,
    required this.thumbnail,
    required this.createdAt,
  });

  /// Factory constructor for JSON deserialization.
  factory SliderArticle.fromJson(Map<String, dynamic> json) {
    return SliderArticle(
      sliderArticleId: json['sliderArticleId'] as int? ?? 0,
      languageId: json['language_id'] as int? ?? 0,
      name: json['name'] as String? ?? '',
      image: json['image'] as String? ?? '',
      webUrl: json['web_url'] as String? ?? '',
      subtitle: json['subtitle'] as String? ?? '',
      thumbnail: json['thumbnail'] as String? ?? '',
      createdAt: json['created_at'] as String? ?? '',
    );
  }

  /// The unique identifier for the slider article.
  final int sliderArticleId;

  /// The language ID for the article.
  final int languageId;

  /// The name/title of the article.
  final String name;

  /// The main image URL for the article.
  final String image;

  /// The web URL or action for the article.
  final String webUrl;

  /// The subtitle/description of the article.
  final String subtitle;

  /// The thumbnail image URL for the article.
  final String thumbnail;

  /// The creation date of the article.
  final String createdAt;

  @override
  int get hashCode {
    return sliderArticleId.hashCode ^
        languageId.hashCode ^
        name.hashCode ^
        image.hashCode ^
        webUrl.hashCode ^
        subtitle.hashCode ^
        thumbnail.hashCode ^
        createdAt.hashCode;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is SliderArticle &&
        other.sliderArticleId == sliderArticleId &&
        other.languageId == languageId &&
        other.name == name &&
        other.image == image &&
        other.webUrl == webUrl &&
        other.subtitle == subtitle &&
        other.thumbnail == thumbnail &&
        other.createdAt == createdAt;
  }

  /// Converts the instance to JSON.
  Map<String, dynamic> toJson() {
    return {
      'sliderArticleId': sliderArticleId,
      'language_id': languageId,
      'name': name,
      'image': image,
      'web_url': webUrl,
      'subtitle': subtitle,
      'thumbnail': thumbnail,
      'created_at': createdAt,
    };
  }

  @override
  String toString() {
    return 'SliderArticle(sliderArticleId: $sliderArticleId, name: $name, subtitle: $subtitle)';
  }
}

/// {@template user_language_update_request}
/// Request model for updating user language preference.
/// {@endtemplate}
class UserLanguageUpdateRequest {
  /// Creates a [UserLanguageUpdateRequest] instance.
  const UserLanguageUpdateRequest({
    required this.languageId,
  });

  /// Factory constructor for creating an instance with language ID.
  factory UserLanguageUpdateRequest.fromLanguageId(String languageId) {
    return UserLanguageUpdateRequest(languageId: languageId);
  }

  /// The language ID to set for the user.
  final String languageId;

  @override
  int get hashCode => languageId.hashCode;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is UserLanguageUpdateRequest && other.languageId == languageId;
  }

  /// Converts the instance to JSON for API request.
  Map<String, dynamic> toJson() {
    return {
      'language_id': languageId,
    };
  }

  @override
  String toString() {
    return 'UserLanguageUpdateRequest(languageId: $languageId)';
  }
}

class ProfitableDairyFarmingData{
  ProfitableDairyFarmingData({
    required this.id,
    required this.coverImg,
    required this.header,
    required this.summary,
    required this.images,
    required this.content
  });

  factory ProfitableDairyFarmingData.fromJson(Map<String, dynamic> json){
    return ProfitableDairyFarmingData(
        id: json['article_id'] is int
            ? json['article_id'] as int
            : int.tryParse(json['article_id'].toString()) ?? 0,
        coverImg: json['article_thumb'] as String ?? '',
        header: json['article_header'] as String ?? '',
        summary: json['article_summary'] as String ?? '',
        images: (json['article_images'] as List<dynamic>? ?? [])
            .map((e) => ImagesList.fromJson(e as Map<String,dynamic>))
            .toList(),
        content: json['article_body'] as String ?? '',
    );
  }

  final int id;
  final String coverImg;
  final String header;
  final String summary;
  final List<ImagesList> images;
  final String content;
}

class ImagesList {
  ImagesList({required this.name, required this.img});

  factory ImagesList.fromJson(Map<String, dynamic> json){
    return ImagesList(
    name: json['name'] as String ?? '',
    img: json['img'] as String  ?? ''
   );
  }

  final String name;
  final String img;
}
