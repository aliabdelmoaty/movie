import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/theme/text_styles.dart';
import '../../../details/presentation/view/details_screen.dart';
import '../../data/models/movie_model.dart';
import '../cubit/cubit/movie_cubit.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Popular Movies',
          style: AppTextStyles.s20w700.c(
            Theme.of(context).colorScheme.onPrimary,
          ),
        ),
        centerTitle: true,
        actions: [
          BlocBuilder<MovieCubit, MovieState>(
            builder: (context, state) {
              final isDarkMode = state.isDarkMode;
              return IconButton(
                onPressed: () {
                  context.read<MovieCubit>().toggleTheme();
                },
                icon: Icon(isDarkMode ? Icons.light_mode : Icons.dark_mode),
              );
            },
          ),
        ],
      ),
      body: BlocBuilder<MovieCubit, MovieState>(
        builder: (context, state) {
          if (state is MovieLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is MovieError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 64.r,
                    color: Theme.of(context).colorScheme.error,
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    'Error',
                    style: AppTextStyles.s20w700.c(
                      Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    state.message,
                    style: AppTextStyles.s16w400.c(
                      Theme.of(context).colorScheme.onSurface,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 16.h),
                  ElevatedButton(
                    onPressed: () {
                      context.read<MovieCubit>().fetchMovies(
                        forceRefresh: true,
                      );
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (state is MovieLoaded) {
            if (state.movies.isEmpty) {
              return Center(
                child: Text(
                  'No movies found',
                  style: AppTextStyles.s18w500.c(
                    Theme.of(context).colorScheme.onSurface,
                  ),
                ),
              );
            }

            return Padding(
              padding: EdgeInsets.all(8.0.r),
              child: Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: state.movies.length,
                      itemBuilder: (context, index) {
                        final movie = state.movies[index];
                        return InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    DetailsScreen(movie: movie),
                              ),
                            );
                          },
                          child: CardItem(movie: movie),
                        );
                      },
                    ),
                  ),
                  SizedBox(height: 10.h),
                  if (state.hasMorePages)
                    ElevatedButton(
                      onPressed: state.isLoadingMore
                          ? null
                          : () {
                              context.read<MovieCubit>().loadMoreMovies();
                            },
                      child: state.isLoadingMore
                          ? SizedBox(
                              width: 20.w,
                              height: 20.h,
                              child: const CircularProgressIndicator(
                                strokeWidth: 2,
                              ),
                            )
                          : Text(
                              'Load More Movies',
                              style: AppTextStyles.s16w500,
                            ),
                    )
                  else
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.h),
                      child: Text(
                        'No more movies to load',
                        style: AppTextStyles.s14w400.c(
                          Theme.of(
                            context,
                          ).colorScheme.onSurface.withOpacity(0.6),
                        ),
                      ),
                    ),
                ],
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}

class CardItem extends StatelessWidget {
  final MovieModel movie;

  const CardItem({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: EdgeInsets.only(bottom: 8.h),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
      child: Padding(
        padding: EdgeInsets.all(8.0.r),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8.r),
              child: movie.fullPosterPath.isNotEmpty
                  ? CachedNetworkImage(
                      imageUrl: movie.fullPosterPath,
                      width: 100.w,
                      height: 150.h,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                        width: 100.w,
                        height: 150.h,
                        color: Colors.grey[300],
                        child: const Center(child: CircularProgressIndicator()),
                      ),
                      errorWidget: (context, url, error) => Container(
                        width: 100.w,
                        height: 150.h,
                        color: Colors.grey[300],
                        child: const Icon(Icons.image_not_supported),
                      ),
                    )
                  : Container(
                      width: 100.w,
                      height: 150.h,
                      color: Colors.grey[300],
                      child: const Icon(Icons.image_not_supported),
                    ),
            ),
            SizedBox(width: 10.w),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          movie.title,
                          style: AppTextStyles.s18w700.c(
                            Theme.of(context).colorScheme.onSurface,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 4.h),
                        Row(
                          children: [
                            Icon(Icons.star, size: 16.r, color: Colors.amber),
                            SizedBox(width: 4.w),
                            Text(
                              '${movie.voteAverage.toStringAsFixed(1)}/10',
                              style: AppTextStyles.s16w500.c(
                                Theme.of(context).colorScheme.onSurface,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 8.h),
                        Text(
                          movie.releaseDate.isNotEmpty
                              ? movie.releaseDate.substring(0, 4)
                              : 'N/A',
                          style: AppTextStyles.s14w400.c(
                            Theme.of(
                              context,
                            ).colorScheme.onSurface.withOpacity(0.7),
                          ),
                        ),
                        SizedBox(height: 4.h),
                        if (movie.overview.isNotEmpty)
                          Text(
                            movie.overview,
                            style: AppTextStyles.s12w400.c(
                              Theme.of(
                                context,
                              ).colorScheme.onSurface.withOpacity(0.6),
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.arrow_forward_ios),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
