
import 'package:dio/dio.dart';
import 'package:dio_smart_retry/dio_smart_retry.dart';
import '../config/get_it.dart';
import '../constants/api_constants.dart';
import 'dio_interceptors.dart';

class DioConfig {
  static late Dio _dio;

  static Dio get dio => _dio;

  static void initialize() {
    _dio = Dio(BaseOptions(
      baseUrl: ApiConstants.baseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      sendTimeout: const Duration(seconds: 30),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      followRedirects: true,
      maxRedirects: 3,
    ));

    _addInterceptors();

    getIt<LoggerService>()
        .info('Dio initialized with base URL: ${ApiConstants.baseUrl}');
  }

  static void _addInterceptors() {
    _dio.interceptors.add(TimingInterceptor());

    _dio.interceptors.add(AuthInterceptor());

    _dio.interceptors.add(LoggerServiceInterceptor());

    _dio.interceptors.add(ErrorHandlerInterceptor());

    _dio.interceptors.add(
      RetryInterceptor(
        dio: _dio,
        logPrint: (message) =>
            getIt<LoggerService>().debug('Retry: $message'),
        retryDelays: const [
          Duration(seconds: 1),
          Duration(seconds: 2),
          Duration(seconds: 4),
        ],
        retryableExtraStatuses: {502, 503, 504},
      ),
    );

    getIt<LoggerService>().info('All Dio interceptors configured');
  }

  static Dio createUploadDio() {
    final uploadDio = Dio(BaseOptions(
      baseUrl: ApiConstants.baseUrl,
      connectTimeout: const Duration(minutes: 2),
      receiveTimeout: const Duration(minutes: 5),
      sendTimeout: const Duration(minutes: 5),
      headers: {
        'Accept': 'application/json',
      },
    ));

    uploadDio.interceptors.addAll([
      AuthInterceptor(),
      LoggerServiceInterceptor(),
      ErrorHandlerInterceptor(),
    ]);

    getIt<LoggerService>()
        .info('Upload Dio instance created with extended timeouts');
    return uploadDio;
  }

  static Dio createExternalDio({required String baseUrl}) {
    final externalDio = Dio(BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 60),
      receiveTimeout: const Duration(seconds: 60),
      sendTimeout: const Duration(seconds: 60),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ));

    externalDio.interceptors.addAll([
      LoggerServiceInterceptor(),
    ]);

    getIt<LoggerService>()
        .info('External Dio instance created for: $baseUrl');
    return externalDio;
  }

  static void reset() {
    _dio.close();
    initialize();
    getIt<LoggerService>().info('Dio configuration reset');
  }

  static Map<String, dynamic> getConfigInfo() {
    return {
      'baseUrl': _dio.options.baseUrl,
      'connectTimeout': _dio.options.connectTimeout?.inSeconds,
      'receiveTimeout': _dio.options.receiveTimeout?.inSeconds,
      'sendTimeout': _dio.options.sendTimeout?.inSeconds,
      'interceptorsCount': _dio.interceptors.length,
      'defaultHeaders': _dio.options.headers,
    };
  }
}
