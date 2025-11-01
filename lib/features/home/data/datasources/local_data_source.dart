import 'package:hive_flutter/hive_flutter.dart';
import '../models/movie_model.dart';

abstract class LocalDataSource {
  Future<List<MovieModel>> getCachedMovies({int page = 1});
  Future<void> cacheMovies(List<MovieModel> movies, {int page = 1});
  Future<DateTime?> getCacheTimestamp();
  Future<void> clearCache();
}

class LocalDataSourceImpl implements LocalDataSource {
  static const String moviesBoxName = 'movies_box';
  static const String cacheTimestampKey = 'cache_timestamp';
  static const Duration cacheValidDuration = Duration(hours: 1);

  @override
  Future<List<MovieModel>> getCachedMovies({int page = 1}) async {
    try {
      final box = await Hive.openBox<dynamic>(moviesBoxName);
      final cacheKey = 'movies_page_$page';
      final cachedData = box.get(cacheKey);

      if (cachedData != null && cachedData is Map) {
        final moviesList = cachedData['movies'] as List<dynamic>?;
        if (moviesList != null) {
          return moviesList
              .map(
                (movie) => MovieModel.fromJson(movie as Map<String, dynamic>),
              )
              .toList();
        }
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  @override
  Future<void> cacheMovies(List<MovieModel> movies, {int page = 1}) async {
    try {
      final box = await Hive.openBox<dynamic>(moviesBoxName);
      final cacheKey = 'movies_page_$page';
      final moviesJson = movies.map((movie) => movie.toJson()).toList();

      await box.put(cacheKey, {
        'movies': moviesJson,
        'page': page,
        'timestamp': DateTime.now().toIso8601String(),
      });

      await box.put(cacheTimestampKey, {
        'timestamp': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      // Ignore cache errors
    }
  }

  @override
  Future<DateTime?> getCacheTimestamp() async {
    try {
      final box = await Hive.openBox<dynamic>(moviesBoxName);
      final timestampData = box.get(cacheTimestampKey);
      if (timestampData != null && timestampData is Map) {
        final timestampString = timestampData['timestamp'] as String?;
        if (timestampString != null) {
          return DateTime.parse(timestampString);
        }
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> clearCache() async {
    try {
      final box = await Hive.openBox<dynamic>(moviesBoxName);
      await box.clear();
    } catch (e) {
      // Ignore cache errors
    }
  }

  bool isCacheValid(DateTime? timestamp) {
    if (timestamp == null) return false;
    final now = DateTime.now();
    return now.difference(timestamp) < cacheValidDuration;
  }
}
