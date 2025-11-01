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
          style: AppTextStyles.s16w700.c(
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
                    size: 48.r,
                    color: Theme.of(context).colorScheme.error,
                  ),
                  SizedBox(height: 12.h),
                  Text(
                    'Error',
                    style: AppTextStyles.s16w700.c(
                      Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                  SizedBox(height: 6.h),
                  Text(
                    state.message,
                    style: AppTextStyles.s14w400.c(
                      Theme.of(context).colorScheme.onSurface,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 12.h),
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
                  style: AppTextStyles.s14w500.c(
                    Theme.of(context).colorScheme.onSurface,
                  ),
                ),
              );
            }

            return Padding(
              padding: EdgeInsets.all(6.0.r),
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
                  SizedBox(height: 8.h),
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
                              style: AppTextStyles.s14w500,
                            ),
                    )
                  else
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 6.h),
                      child: Text(
                        'No more movies to load',
                        style: AppTextStyles.s12w400.c(
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
      margin: EdgeInsets.only(bottom: 6.h),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
      child: Padding(
        padding: EdgeInsets.all(6.0.r),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(6.r),
              child: movie.fullPosterPath.isNotEmpty
                  ? CachedNetworkImage(
                      imageUrl: movie.fullPosterPath,
                      width: 60.w,
                      height: 90.h,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                        width: 60.w,
                        height: 90.h,
                        color: Colors.grey[300],
                        child: const Center(
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      ),
                      errorWidget: (context, url, error) => Container(
                        width: 60.w,
                        height: 90.h,
                        color: Colors.grey[300],
                        child: Icon(Icons.image_not_supported, size: 24.r),
                      ),
                    )
                  : Container(
                      width: 60.w,
                      height: 90.h,
                      color: Colors.grey[300],
                      child: Icon(Icons.image_not_supported, size: 24.r),
                    ),
            ),
            SizedBox(width: 8.w),
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
                          style: AppTextStyles.s14w700.c(
                            Theme.of(context).colorScheme.onSurface,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 3.h),
                        Row(
                          children: [
                            Icon(Icons.star, size: 12.r, color: Colors.amber),
                            SizedBox(width: 3.w),
                            Text(
                              '${movie.voteAverage.toStringAsFixed(1)}/10',
                              style: AppTextStyles.s12w500.c(
                                Theme.of(context).colorScheme.onSurface,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          movie.releaseDate.isNotEmpty
                              ? movie.releaseDate.substring(0, 4)
                              : 'N/A',
                          style: AppTextStyles.s10w400.c(
                            Theme.of(
                              context,
                            ).colorScheme.onSurface.withOpacity(0.7),
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: Icon(Icons.arrow_forward_ios, size: 16.r),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
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
