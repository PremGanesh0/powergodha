import 'package:dio/dio.dart';
import 'package:powergodha/app/app_logger_config.dart';

/// A Dio interceptor that provides beautiful logging of HTTP requests and responses
/// using the global AppLogger configuration.
class LoggingInterceptor extends Interceptor {

  /// Creates a new logging interceptor that uses the global AppLogger
  const LoggingInterceptor();

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final errorData = {
      'status': err.response?.statusCode,
      'method': err.requestOptions.method,
      'url': err.requestOptions.uri.toString(),
      'headers': _sanitizeHeaders(err.requestOptions.headers),
      'response_data': _truncateData(err.response?.data),
      'error_type': err.type.name,
      'error_message': err.message,
    };

    AppLogger.error(
      'API Request Failed',
      error: err,
      data: errorData,
    );

    handler.next(err);
  }

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // Add start time for response time calculation
    options.extra['start_time'] = DateTime.now().millisecondsSinceEpoch;

    final requestData = {
      'method': options.method,
      'url': options.uri.toString(),
      'headers': _sanitizeHeaders(options.headers),
      'data': _truncateData(options.data),
      'query_parameters': options.queryParameters,
    };

    AppLogger.info('API Request', data: requestData);
    handler.next(options);
  }

  @override
  void onResponse(Response<dynamic> response, ResponseInterceptorHandler handler) {
    final startTime = response.requestOptions.extra['start_time'] as int?;
    final responseTime = startTime != null
        ? '${DateTime.now().millisecondsSinceEpoch - startTime}ms'
        : 'unknown';

    final responseData = {
      'status': response.statusCode,
      'method': response.requestOptions.method,
      'url': response.requestOptions.uri.toString(),
      // 'headers': _sanitizeHeaders(response.headers.map),
      'data': _truncateData(response.data),
      'response_time': responseTime,
    };

    if (response.statusCode != null && response.statusCode! >= 200 && response.statusCode! < 300) {
      AppLogger.info('API Response Success', data: responseData);
    } else {
      AppLogger.warning('API Response Warning', data: responseData);
    }

    handler.next(response);
  }

  /// Sanitize headers to remove sensitive information
  Map<String, dynamic> _sanitizeHeaders(Map<String, dynamic> headers) {
    final sanitized = Map<String, dynamic>.from(headers);

    // Remove or mask sensitive headers
    const sensitiveHeaders = ['authorization', 'cookie', 'x-api-key', 'x-auth-token'];

    for (final header in sensitiveHeaders) {
      if (sanitized.containsKey(header)) {
        sanitized[header] = '***MASKED***';
      }
      // Also check lowercase versions
      if (sanitized.containsKey(header.toLowerCase())) {
        sanitized[header.toLowerCase()] = '***MASKED***';
      }
    }

    return sanitized;
  }

  /// Truncate large data to prevent log overflow
  dynamic _truncateData(data) {
    if (data == null) return null;

    final dataString = data.toString();
    const maxLength = 1000; // Maximum characters to log

    if (dataString.length <= maxLength) {
      return data;
    }

    return '${dataString.substring(0, maxLength)}... [TRUNCATED - ${dataString.length} chars total]';
  }
}
