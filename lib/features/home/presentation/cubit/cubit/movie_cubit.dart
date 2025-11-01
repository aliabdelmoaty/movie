import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../data/models/movie_model.dart';
import '../../../data/repositories/movie_repository_impl.dart';

part 'movie_state.dart';

class MovieCubit extends Cubit<MovieState> {
  final MovieRepository repository;
  final SharedPreferences sharedPreferences;
  static const String _themeKey = 'is_dark_mode';

  MovieCubit({required this.repository, required this.sharedPreferences})
    : super(MovieInitial(isDarkMode: false)) {
    _loadThemePreference();
    fetchMovies();
  }

  Future<void> _loadThemePreference() async {
    try {
      final isDarkMode = sharedPreferences.getBool(_themeKey) ?? false;
      final currentState = state;
      if (currentState is MovieLoaded) {
        emit(currentState.copyWith(isDarkMode: isDarkMode));
      } else {
        emit(MovieInitial(isDarkMode: isDarkMode));
      }
    } catch (e) {
      // Use default theme if error
    }
  }

  Future<void> toggleTheme() async {
    try {
      final currentState = state;
      final newDarkMode = !currentState.isDarkMode;

      await sharedPreferences.setBool(_themeKey, newDarkMode);

      if (currentState is MovieLoaded) {
        emit(currentState.copyWith(isDarkMode: newDarkMode));
      } else if (currentState is MovieError) {
        emit(
          MovieError(message: currentState.message, isDarkMode: newDarkMode),
        );
      } else if (currentState is MovieLoading) {
        emit(MovieLoading(isDarkMode: newDarkMode));
      } else {
        emit(MovieInitial(isDarkMode: newDarkMode));
      }
    } catch (e) {
      // Ignore theme persistence errors
    }
  }

  Future<void> fetchMovies({bool forceRefresh = false}) async {
    try {
      final currentState = state;
      final isDarkMode = currentState.isDarkMode;

      if (!forceRefresh &&
          currentState is MovieLoaded &&
          currentState.movies.isNotEmpty) {
        // Don't reload if we already have data
        return;
      }

      emit(MovieLoading(isDarkMode: isDarkMode));

      final response = await repository.getPopularMovies(
        page: 1,
        forceRefresh: forceRefresh,
      );

      emit(
        MovieLoaded(
          movies: response.results,
          currentPage: response.page,
          totalPages: response.totalPages,
          hasMorePages: response.page < response.totalPages,
          isLoadingMore: false,
          isDarkMode: isDarkMode,
        ),
      );
    } catch (e) {
      final currentState = state;
      emit(
        MovieError(
          message: e.toString().replaceAll('Exception: ', ''),
          isDarkMode: currentState.isDarkMode,
        ),
      );
    }
  }

  Future<void> loadMoreMovies() async {
    final currentState = state;
    if (currentState is MovieLoaded) {
      if (currentState.isLoadingMore || !currentState.hasMorePages) {
        return;
      }

      try {
        emit(currentState.copyWith(isLoadingMore: true));

        final nextPage = currentState.currentPage + 1;
        final response = await repository.getPopularMovies(page: nextPage);

        final updatedMovies = [...currentState.movies, ...response.results];
        final hasMorePages = response.page < response.totalPages;

        emit(
          currentState.copyWith(
            movies: updatedMovies,
            currentPage: response.page,
            totalPages: response.totalPages,
            hasMorePages: hasMorePages,
            isLoadingMore: false,
          ),
        );
      } catch (e) {
        emit(currentState.copyWith(isLoadingMore: false));
      }
    }
  }
}
