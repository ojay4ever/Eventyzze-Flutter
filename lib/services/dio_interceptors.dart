import 'dart:convert';
import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:eventyzze/services/auth_services.dart';
import '../config/get_it.dart';
import 'api_error_types.dart' show APIErrorClassifier, APIErrorType;
import 'connection_status_manager.dart';

class LoggerServiceInterceptor extends Interceptor {
  final LoggerService _logger = getIt<LoggerService>();

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.extra['start_time'] = DateTime.now().millisecondsSinceEpoch;

    _logger.info('[${options.method}] ${options.uri}');

    if (options.headers.isNotEmpty) {
      _logger.debug('Headers: ${_sanitizeHeaders(options.headers)}');
    }

    if (options.data != null) {
      _logger.debug('Request Body: ${_formatBody(options.data)}');
    }

    if (options.queryParameters.isNotEmpty) {
      _logger.debug('Query Params: ${options.queryParameters}');
    }

    super.onRequest(options, handler);
  }

  @override
  void onResponse(
    Response<dynamic> response,
    ResponseInterceptorHandler handler,
  ) {
    final startTime = response.requestOptions.extra['start_time'] as int? ?? 0;
    final duration = DateTime.now().millisecondsSinceEpoch - startTime;

    _logger.info(
      '[${response.statusCode}] ${response.requestOptions.uri} '
      '(${duration}ms)',
    );

    if (response.data != null) {
      _logger.success(' Response: ${_formatBody(response.data)}');
    }

    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final startTime = err.requestOptions.extra['start_time'] as int? ?? 0;
    final duration = startTime > 0
        ? DateTime.now().millisecondsSinceEpoch - startTime
        : 0;

    _logger.error(
      '[${err.response?.statusCode ?? 'NETWORK'}] ${err.requestOptions.uri} '
      '${duration > 0 ? '(${duration}ms)' : ''}',
      err,
      err.stackTrace,
    );

    if (err.response?.data != null) {
      _logger.debug('Error Response: ${_formatBody(err.response!.data)}');
    }

    if (err.message != null) {
      _logger.debug('Error Message: ${err.message}');
    }

    super.onError(err, handler);
  }

  Map<String, dynamic> _sanitizeHeaders(Map<String, dynamic> headers) {
    final sanitized = Map<String, dynamic>.from(headers);

    if (sanitized.containsKey('Authorization')) {
      final auth = sanitized['Authorization'] as String;
      if (auth.startsWith('Bearer ')) {
        sanitized['Authorization'] = 'Bearer ***';
      } else {
        sanitized['Authorization'] = '***';
      }
    }

    const sensitiveHeaders = ['Cookie', 'Set-Cookie', 'X-API-Key'];
    for (final header in sensitiveHeaders) {
      if (sanitized.containsKey(header)) {
        sanitized[header] = '***';
      }
    }
    return sanitized;
  }

  String _formatBody(dynamic data) {
    try {
      if (data == null) return 'null';

      String dataStr;
      if (data is String) {
        dataStr = data;
      } else if (data is Map || data is List) {
        dataStr = jsonEncode(data);
      } else {
        dataStr = data.toString();
      }

      if (dataStr.length > 1000) {
        return '${dataStr.substring(0, 1000)}... '
            '(${dataStr.length} chars total)';
      }

      return dataStr;
    } on Exception catch (e) {
      return 'Unable to format body: $e';
    }
  }
}

class AuthInterceptor extends Interceptor {
  final LoggerService _logger = getIt<LoggerService>();

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    try {
      final token = await AuthService().getBearerToken();

      log('debug token: $token');

      if (token != null && token.isNotEmpty) {
        options.headers['Authorization'] = 'Bearer $token';
      } else {
        _logger.warning('No token available for request: ${options.uri}');
        // Try to get a fresh token one more time
        try {
          final freshToken = await AuthService().getBearerToken();
          if (freshToken != null && freshToken.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $freshToken';
            _logger.info('Retrieved fresh token for request: ${options.uri}');
          } else {
            _logger.error(
              'Failed to retrieve token after retry for: ${options.uri}',
            );
          }
        } catch (e) {
          _logger.error('Error retrieving fresh token: $e');
        }
      }

      // Only set Content-Type if it's not already set and not multipart/form-data
      // For FormData, Dio will automatically set Content-Type with boundary
      if (!options.headers.containsKey('Content-Type') &&
          !(options.data is FormData)) {
        options.headers['Content-Type'] = 'application/json';
      }
    } on Exception catch (e, stackTrace) {
      _logger.error('Failed to add auth headers', e, stackTrace);
    }

    super.onRequest(options, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (err.response?.statusCode == 401) {
      _logger.warning('Authentication failed - token may be expired');
    }

    super.onError(err, handler);
  }
}

class ErrorHandlerInterceptor extends Interceptor {
  final LoggerService _logger = getIt<LoggerService>();
  final ConnectionStatusManager _connectionManager = ConnectionStatusManager();

  @override
  void onResponse(
    Response<dynamic> response,
    ResponseInterceptorHandler handler,
  ) {
    _connectionManager.handleSuccess();
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final errorType = APIErrorClassifier.categorizeError(err);
    final errorTitle = APIErrorClassifier.getErrorTitle(errorType);

    _logger.error('$errorTitle: ${err.message}', err, err.stackTrace);

    if (APIErrorClassifier.shouldTriggerConnectionManager(errorType)) {
      switch (errorType) {
        case APIErrorType.networkError:
          _connectionManager.handleNetworkError();
        case APIErrorType.serverError:
          _connectionManager.handleServerError();
        default:
      }
    }

    _logger.debug('Connection Status: ${_connectionManager.getStatusInfo()}');

    super.onError(err, handler);
  }
}

class TimingInterceptor extends Interceptor {
  final LoggerService _logger = getIt<LoggerService>();

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.extra['request_start_time'] = DateTime.now();
    super.onRequest(options, handler);
  }

  @override
  void onResponse(
    Response<dynamic> response,
    ResponseInterceptorHandler handler,
  ) {
    final startTime =
        response.requestOptions.extra['request_start_time'] as DateTime?;
    if (startTime != null) {
      final duration = DateTime.now().difference(startTime);
      response.extra['request_duration'] = duration;

      if (duration.inSeconds > 5) {
        _logger.warning(
          'Slow request detected: ${response.requestOptions.uri} took '
          '${duration.inMilliseconds}ms',
        );
      }
    }
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final startTime =
        err.requestOptions.extra['request_start_time'] as DateTime?;
    if (startTime != null) {
      final duration = DateTime.now().difference(startTime);
      err.requestOptions.extra['request_duration'] = duration;
    }
    super.onError(err, handler);
  }
}
