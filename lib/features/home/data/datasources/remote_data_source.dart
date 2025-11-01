import 'package:dio/dio.dart';
import '../../../../core/api/api_service.dart';
import '../models/movie_model.dart';

abstract class RemoteDataSource {
  Future<PopularMoviesResponse> getPopularMovies({int page = 1});
}

class RemoteDataSourceImpl implements RemoteDataSource {
  final ApiService apiService;

  RemoteDataSourceImpl({required this.apiService});

  @override
  Future<PopularMoviesResponse> getPopularMovies({int page = 1}) async {
    try {
      final response = await apiService.getPopularMovies(page: page);
      return PopularMoviesResponse.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception('Failed to load movies: ${e.message}');
    } catch (e) {
      throw Exception('Failed to load movies: $e');
    }
  }
}
