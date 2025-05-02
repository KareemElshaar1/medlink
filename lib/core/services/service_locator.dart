import 'package:dio/dio.dart';

/// Represents different sources of potential API errors
enum ErrorSource {
  noContent,
  badRequest,
  forbidden,
  unauthorized,
  notFound,
  internalServerError,
  connectTimeout,
  cancel,
  receiveTimeout,
  sendTimeout,
  cacheError,
  noInternetConnection,
  defaultError
}

/// Manages HTTP and application-specific response codes
class ApiResponseCode {
  static const int success = 200;
  static const int noContent = 201;
  static const int badRequest = 400;
  static const int unauthorized = 401;
  static const int forbidden = 403;
  static const int notFound = 404;
  static const int apiLogicError = 422;
  static const int internalServerError = 500;

  // Local error codes
  static const int connectTimeout = -1;
  static const int cancel = -2;
  static const int receiveTimeout = -3;
  static const int sendTimeout = -4;
  static const int cacheError = -5;
  static const int noInternetConnection = -6;
  static const int defaultError = -7;
}

/// Manages error messages for different error scenarios
class ApiResponseMessage {
  static const String noContent = 'No content available';
  static const String badRequest = 'Invalid request';
  static const String unauthorized = 'Unauthorized access';
  static const String forbidden = 'Access forbidden';
  static const String notFound = 'Resource not found';
  static const String internalServerError = 'Server error occurred';
  static const String connectTimeout = 'Connection timeout';
  static const String receiveTimeout = 'Receive timeout';
  static const String sendTimeout = 'Send timeout';
  static const String cacheError = 'Cache error';
  static const String noInternetConnection = 'No internet connection';
  static const String defaultError = 'Unexpected error occurred';
}

/// Represents an API error with a code and message
class ApiError {
  final int code;
  final String message;

  const ApiError({required this.code, required this.message});

  factory ApiError.fromJson(Map<String, dynamic> json) {
    return ApiError(
      code: json['code'] ?? ApiResponseCode.defaultError,
      message: json['message'] ?? ApiResponseMessage.defaultError,
    );
  }
}

/// Handles conversion of error sources to specific API errors
extension ErrorSourceExtension on ErrorSource {
  ApiError toApiError() {
    switch (this) {
      case ErrorSource.noContent:
        return ApiError(
          code: ApiResponseCode.noContent,
          message: ApiResponseMessage.noContent,
        );
      case ErrorSource.badRequest:
        return ApiError(
          code: ApiResponseCode.badRequest,
          message: ApiResponseMessage.badRequest,
        );
      case ErrorSource.forbidden:
        return ApiError(
          code: ApiResponseCode.forbidden,
          message: ApiResponseMessage.forbidden,
        );
      case ErrorSource.unauthorized:
        return ApiError(
          code: ApiResponseCode.unauthorized,
          message: ApiResponseMessage.unauthorized,
        );
      case ErrorSource.notFound:
        return ApiError(
          code: ApiResponseCode.notFound,
          message: ApiResponseMessage.notFound,
        );
      case ErrorSource.internalServerError:
        return ApiError(
          code: ApiResponseCode.internalServerError,
          message: ApiResponseMessage.internalServerError,
        );
      case ErrorSource.connectTimeout:
        return ApiError(
          code: ApiResponseCode.connectTimeout,
          message: ApiResponseMessage.connectTimeout,
        );
      case ErrorSource.cancel:
        return ApiError(
          code: ApiResponseCode.cancel,
          message: ApiResponseMessage.defaultError,
        );
      case ErrorSource.receiveTimeout:
        return ApiError(
          code: ApiResponseCode.receiveTimeout,
          message: ApiResponseMessage.receiveTimeout,
        );
      case ErrorSource.sendTimeout:
        return ApiError(
          code: ApiResponseCode.sendTimeout,
          message: ApiResponseMessage.sendTimeout,
        );
      case ErrorSource.cacheError:
        return ApiError(
          code: ApiResponseCode.cacheError,
          message: ApiResponseMessage.cacheError,
        );
      case ErrorSource.noInternetConnection:
        return ApiError(
          code: ApiResponseCode.noInternetConnection,
          message: ApiResponseMessage.noInternetConnection,
        );
      case ErrorSource.defaultError:
        return ApiError(
          code: ApiResponseCode.defaultError,
          message: ApiResponseMessage.defaultError,
        );
    }
  }
}

/// Centralized error handler for API-related exceptions
class ApiErrorHandler {
  static ApiError handle(dynamic error) {
    if (error is DioException) {
      return _handleDioError(error);
    }
    return ErrorSource.defaultError.toApiError();
  }

  static ApiError _handleDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
        return ErrorSource.connectTimeout.toApiError();
      case DioExceptionType.sendTimeout:
        return ErrorSource.sendTimeout.toApiError();
      case DioExceptionType.receiveTimeout:
        return ErrorSource.receiveTimeout.toApiError();
      case DioExceptionType.badResponse:
        return _handleBadResponse(error);
      case DioExceptionType.cancel:
        return ErrorSource.cancel.toApiError();
      case DioExceptionType.unknown:
      case DioExceptionType.connectionError:
      case DioExceptionType.badCertificate:
      default:
        return ErrorSource.defaultError.toApiError();
    }
  }

  static ApiError _handleBadResponse(DioException error) {
    try {
      if (error.response?.data != null) {
        return ApiError.fromJson(error.response!.data);
      }
      return ErrorSource.defaultError.toApiError();
    } catch (_) {
      return ErrorSource.defaultError.toApiError();
    }
  }
}

/// Represents the internal status of API operations
class ApiStatus {
  static const int success = 0;
  static const int failure = 1;
}
