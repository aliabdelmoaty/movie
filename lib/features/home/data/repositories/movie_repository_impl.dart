import '../datasources/local_data_source.dart';
import '../datasources/remote_data_source.dart';
import '../models/movie_model.dart';

abstract class MovieRepository {
  Future<PopularMoviesResponse> getPopularMovies({
    int page = 1,
    bool forceRefresh = false,
  });
}

class MovieRepositoryImpl implements MovieRepository {
  final RemoteDataSource remoteDataSource;
  final LocalDataSource localDataSource;

  MovieRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<PopularMoviesResponse> getPopularMovies({
    int page = 1,
    bool forceRefresh = false,
  }) async {
    // If not forcing refresh, check cache first
    if (!forceRefresh) {
      final cachedMovies = await localDataSource.getCachedMovies(page: page);
      final cacheTimestamp = await localDataSource.getCacheTimestamp();

      if (cachedMovies.isNotEmpty &&
          localDataSource is LocalDataSourceImpl &&
          (localDataSource as LocalDataSourceImpl).isCacheValid(
            cacheTimestamp,
          )) {
        // Return cached data
        final totalPages =
            500; // Approximate, will be updated when fetching from API
        return PopularMoviesResponse(
          page: page,
          results: cachedMovies,
          totalPages: totalPages,
          totalResults: cachedMovies.length,
        );
      }
    }

    // Fetch from remote
    try {
      final response = await remoteDataSource.getPopularMovies(page: page);

      // Cache the results
      await localDataSource.cacheMovies(response.results, page: page);

      return response;
    } catch (e) {
      // If remote fails, try to return cached data even if expired
      final cachedMovies = await localDataSource.getCachedMovies(page: page);
      if (cachedMovies.isNotEmpty) {
        final totalPages = 500; // Approximate
        return PopularMoviesResponse(
          page: page,
          results: cachedMovies,
          totalPages: totalPages,
          totalResults: cachedMovies.length,
        );
      }
      rethrow;
    }
  }
}
