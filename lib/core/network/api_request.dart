import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:rawg/core/constants/api_constants.dart';
import 'package:rawg/core/secrets/app_secrets.dart';

class ApiRequest {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: ApiConstants.baseUrl,
      connectTimeout: const Duration(seconds: 30),
      headers: const {'Content-Type': 'application/json', 'Accept': 'application/json'},
      queryParameters: {'key': AppSecrets.rawgApiKey},
      receiveTimeout: const Duration(seconds: 30),
      sendTimeout: const Duration(seconds: 30),
    ),
  )..interceptors.add(PrettyDioLogger(compact: true, error: true, requestBody: true, requestHeader: true, responseBody: true, responseHeader: false));

  Future<Response<T>> get<T>(String path, {Map<String, dynamic>? queryParameters}) => _dio.get<T>(path, queryParameters: queryParameters);
}
