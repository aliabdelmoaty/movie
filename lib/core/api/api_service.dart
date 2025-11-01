import 'package:dio/dio.dart';
import '../constants/api_constants.dart';

class ApiService {
  late final Dio _dio;

  ApiService() {
    _dio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        headers: {
          'Authorization': 'Bearer ${ApiConstants.bearerToken}',
          'accept': 'application/json',
        },
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
      ),
    );
  }

  Future<Response> getPopularMovies({
    int page = 1,
    String language = 'en-US',
  }) async {
    try {
      final response = await _dio.get(
        ApiConstants.popularMoviesEndpoint,
        queryParameters: {'language': language, 'page': page},
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }
}
