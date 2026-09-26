import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';

abstract final class ErrorHandler {
  static String messageFor(DioException error) => switch (error.type) {
    DioExceptionType.connectionTimeout => 'errors.connectionTimeout',
    DioExceptionType.sendTimeout => 'errors.sendTimeout',
    DioExceptionType.receiveTimeout => 'errors.receiveTimeout',
    DioExceptionType.badResponse => switch (error.response?.statusCode) {
      400 => 'errors.badRequest',
      401 => 'errors.unauthorized',
      403 => 'errors.accessDenied',
      404 => 'errors.notFound',
      500 => 'errors.serverError',
      _ => 'errors.default',
    },
    DioExceptionType.cancel => 'errors.cancelled',
    DioExceptionType.connectionError => 'errors.noInternet',
    _ => 'errors.default',
  }.tr();
}
