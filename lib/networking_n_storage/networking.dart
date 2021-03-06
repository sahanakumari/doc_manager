import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio_http_cache/dio_http_cache.dart';
import 'package:doc_manager/models/networking.dart';
import 'package:doc_manager/networking_n_storage/session.dart';
import 'package:doc_manager/utils/app_config.dart';
import 'package:doc_manager/utils/exceptions.dart';

class Networking {
  static const Map<String, dynamic> defaultHeaders = {
    HttpHeaders.contentTypeHeader: "application/json",
  };

  static Future<NetworkResponse> post(
    String endpoint, {
    bool authenticate = true,
    Map<String, dynamic>? headers,
    String contentType = "application/json",
    String? baseUrl,
    dynamic body,
    bool enableCaching = false,
    CacheConfig? cacheConfig,
    bool forceRefresh = false,
  }) async {
    try {
      if (authenticate && !Session.isLoggedIn) throw LoginException();
      var _dio = Dio(
        BaseOptions(baseUrl: baseUrl ?? AppConfig.kBaseUrl, headers: headers),
      );

      Options? options;
      if (enableCaching) {
        _dio.interceptors.add(DioCacheManager(
          cacheConfig ?? CacheConfig(baseUrl: AppConfig.kBaseUrl),
        ).interceptor);
        options = buildCacheOptions(
          cacheConfig?.defaultMaxAge ?? const Duration(minutes: 5),
          forceRefresh: forceRefresh,
        );
      }
      var res = await _dio.post(endpoint, data: body, options: options);

      return NetworkResponse(res.statusCode, res.data);
    } on DioError catch (e) {
      if (e.type == DioErrorType.response) {
        print("${e.response?.statusCode} => ${e.response?.data}");
        if (e.response?.statusCode == 403) {
          throw LoginException("sessionExpired");
        }
        throw ErrorResponse(e.response?.statusCode, e.response?.data);
      }
      throw ErrorResponse(null, e.message);
    } on LoginException {
      rethrow;
    } catch (e) {
      throw ErrorResponse(null, "$e");
    }
  }

  static Future<NetworkResponse> get(
    String endpoint, {
    Map<String, String>? queryParams,
    Map<String, dynamic>? headers,
    String contentType = "application/json",
    String? baseUrl,
    dynamic body,
    bool enableCaching = false,
    CacheConfig? cacheConfig,
    bool forceRefresh = false,
  }) async {
    try {
      var _dio = Dio(
        BaseOptions(baseUrl: baseUrl ?? AppConfig.kBaseUrl, headers: headers),
      );

      Options? options;
      if (enableCaching) {
        _dio.interceptors.add(DioCacheManager(
          cacheConfig ?? CacheConfig(baseUrl: AppConfig.kBaseUrl),
        ).interceptor);
        options = buildCacheOptions(
          cacheConfig?.defaultMaxAge ?? const Duration(minutes: 5),
          forceRefresh: forceRefresh,
        );
      }
      var res = await _dio.get(endpoint,
          queryParameters: queryParams, options: options);

      return NetworkResponse(res.statusCode, res.data);
    } on DioError catch (e) {
      if (e.type == DioErrorType.response) {
        print("${e.response?.statusCode} => ${e.response?.data}");
        if (e.response?.statusCode == 403) {
          throw LoginException("sessionExpired");
        }
        throw ErrorResponse(e.response?.statusCode, e.response?.data);
      }
      throw ErrorResponse(null, e.message);
    } on LoginException {
      rethrow;
    } catch (e) {
      if (e is SocketException) throw ErrorResponse(null, "noInternet");
      throw ErrorResponse(null, "somethingWrong");
    }
  }
}
