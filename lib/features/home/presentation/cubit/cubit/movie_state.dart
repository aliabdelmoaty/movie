part of 'movie_cubit.dart';

sealed class MovieState extends Equatable {
  final bool isDarkMode;

  const MovieState({this.isDarkMode = false});

  @override
  List<Object> get props => [isDarkMode];
}

final class MovieInitial extends MovieState {
  const MovieInitial({super.isDarkMode = false});

  @override
  List<Object> get props => [isDarkMode];
}

final class MovieLoading extends MovieState {
  const MovieLoading({super.isDarkMode = false});

  @override
  List<Object> get props => [isDarkMode];
}

final class MovieLoaded extends MovieState {
  final List<MovieModel> movies;
  final int currentPage;
  final int totalPages;
  final bool hasMorePages;
  final bool isLoadingMore;

  const MovieLoaded({
    required this.movies,
    required this.currentPage,
    required this.totalPages,
    this.hasMorePages = true,
    this.isLoadingMore = false,
    super.isDarkMode = false,
  });

  MovieLoaded copyWith({
    List<MovieModel>? movies,
    int? currentPage,
    int? totalPages,
    bool? hasMorePages,
    bool? isLoadingMore,
    bool? isDarkMode,
  }) {
    return MovieLoaded(
      movies: movies ?? this.movies,
      currentPage: currentPage ?? this.currentPage,
      totalPages: totalPages ?? this.totalPages,
      hasMorePages: hasMorePages ?? this.hasMorePages,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      isDarkMode: isDarkMode ?? this.isDarkMode,
    );
  }

  @override
  List<Object> get props => [
    movies,
    currentPage,
    totalPages,
    hasMorePages,
    isLoadingMore,
    isDarkMode,
  ];
}

final class MovieError extends MovieState {
  final String message;

  const MovieError({required this.message, super.isDarkMode = false});

  @override
  List<Object> get props => [message, isDarkMode];
}
