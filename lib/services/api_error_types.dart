import 'package:dio/dio.dart';

enum APIErrorType {
  networkError,
  serverError,
  clientError,
  parsingError,
  unknownError,
}

class APIErrorClassifier {
  static APIErrorType categorizeError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.connectionError:
        return APIErrorType.networkError;

      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode;
        if (statusCode == null) return APIErrorType.unknownError;

        if (statusCode >= 500) {
          return APIErrorType.serverError;
        } else if (statusCode >= 400) {
          return APIErrorType.clientError;
        }
        return APIErrorType.unknownError;

      case DioExceptionType.badCertificate:
        return APIErrorType.networkError;

      case DioExceptionType.cancel:
        return APIErrorType.unknownError;

      case DioExceptionType.unknown:
        if ((error.message?.contains('FormatException') ?? false) ||
            (error.message?.contains('type') ?? false) &&
                (error.message?.contains('is not a subtype') ?? false)) {
          return APIErrorType.parsingError;
        }
        return APIErrorType.unknownError;
    }
  }

  static String getUserFriendlyMessage(APIErrorType errorType,
      {String? customMessage}) {
    if (customMessage != null && customMessage.isNotEmpty) {
      return customMessage;
    }

    switch (errorType) {
      case APIErrorType.networkError:
        return 'Unable to connect. Please check your internet connection'
            ' and try again.';

      case APIErrorType.serverError:
        return 'Servers are temporarily unavailable. '
            'Please try again in a few moments.';

      case APIErrorType.clientError:
        return 'There was an issue with your request. Please try again.';

      case APIErrorType.parsingError:
        return 'We received an unexpected response from the server. '
            'Please try again.';

      case APIErrorType.unknownError:
        return 'Something went wrong. Please try again later.';
    }
  }

  static String getErrorTitle(APIErrorType errorType) {
    switch (errorType) {
      case APIErrorType.networkError:
        return 'Network Error';
      case APIErrorType.serverError:
        return 'Server Error';
      case APIErrorType.clientError:
        return 'Client Error';
      case APIErrorType.parsingError:
        return 'Parsing Error';
      case APIErrorType.unknownError:
        return 'Unknown Error';
    }
  }

  static bool shouldTriggerConnectionManager(APIErrorType errorType) {
    return errorType == APIErrorType.networkError ||
        errorType == APIErrorType.serverError;
  }

  static bool shouldRetry(APIErrorType errorType, int attemptCount) {
    if (attemptCount >= 3) return false;

    switch (errorType) {
      case APIErrorType.networkError:
        return true;
      case APIErrorType.serverError:
        return true;
      case APIErrorType.clientError:
        return false;
      case APIErrorType.parsingError:
        return false;
      case APIErrorType.unknownError:
        return false;
    }
  }
}