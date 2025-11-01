import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/theme/text_styles.dart';
import '../../../home/data/models/movie_model.dart';

class DetailsScreen extends StatelessWidget {
  final MovieModel movie;

  const DetailsScreen({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Movie Details',
          style: AppTextStyles.s20w700.c(
            Theme.of(context).colorScheme.onSurface,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (movie.fullBackdropPath.isNotEmpty)
              ClipRRect(
                borderRadius: BorderRadius.circular(12.r),
                child: CachedNetworkImage(
                  imageUrl: movie.fullBackdropPath,
                  width: double.infinity,
                  height: 250.h,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(
                    width: double.infinity,
                    height: 250.h,
                    color: Colors.grey[300],
                    child: const Center(child: CircularProgressIndicator()),
                  ),
                  errorWidget: (context, url, error) => Container(
                    width: double.infinity,
                    height: 250.h,
                    color: Colors.grey[300],
                    child: const Icon(Icons.image_not_supported, size: 64),
                  ),
                ),
              )
            else if (movie.fullPosterPath.isNotEmpty)
              Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12.r),
                  child: CachedNetworkImage(
                    imageUrl: movie.fullPosterPath,
                    width: 200.w,
                    height: 300.h,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      width: 200.w,
                      height: 300.h,
                      color: Colors.grey[300],
                      child: const Center(child: CircularProgressIndicator()),
                    ),
                    errorWidget: (context, url, error) => Container(
                      width: 200.w,
                      height: 300.h,
                      color: Colors.grey[300],
                      child: const Icon(Icons.image_not_supported, size: 64),
                    ),
                  ),
                ),
              ),
            SizedBox(height: 16.h),
            Text(
              movie.title,
              style: AppTextStyles.s24w700.c(
                Theme.of(context).colorScheme.onSurface,
              ),
            ),
            if (movie.originalTitle != movie.title) ...[
              SizedBox(height: 4.h),
              Text(
                movie.originalTitle,
                style: AppTextStyles.s16w400.c(
                  Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                ),
              ),
            ],
            SizedBox(height: 12.h),
            Row(
              children: [
                Row(
                  children: [
                    Icon(Icons.star, size: 20.r, color: Colors.amber),
                    SizedBox(width: 4.w),
                    Text(
                      '${movie.voteAverage.toStringAsFixed(1)}/10',
                      style: AppTextStyles.s18w600.c(
                        Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Text(
                      '(${movie.voteCount} votes)',
                      style: AppTextStyles.s14w400.c(
                        Theme.of(
                          context,
                        ).colorScheme.onSurface.withOpacity(0.6),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 8.h),
            if (movie.releaseDate.isNotEmpty)
              Row(
                children: [
                  Icon(
                    Icons.calendar_today,
                    size: 16.r,
                    color: Theme.of(
                      context,
                    ).colorScheme.onSurface.withOpacity(0.7),
                  ),
                  SizedBox(width: 4.w),
                  Text(
                    'Released: ${movie.releaseDate}',
                    style: AppTextStyles.s14w400.c(
                      Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                    ),
                  ),
                ],
              ),
            SizedBox(height: 8.h),
            if (movie.originalLanguage.isNotEmpty)
              Row(
                children: [
                  Icon(
                    Icons.language,
                    size: 16.r,
                    color: Theme.of(
                      context,
                    ).colorScheme.onSurface.withOpacity(0.7),
                  ),
                  SizedBox(width: 4.w),
                  Text(
                    'Language: ${movie.originalLanguage.toUpperCase()}',
                    style: AppTextStyles.s14w400.c(
                      Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                    ),
                  ),
                ],
              ),
            if (movie.genreIds.isNotEmpty) ...[
              SizedBox(height: 12.h),
              Wrap(
                spacing: 8.w,
                runSpacing: 8.h,
                children: movie.genreIds.take(3).map((genreId) {
                  return Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 12.w,
                      vertical: 6.h,
                    ),
                    decoration: BoxDecoration(
                      color: Theme.of(
                        context,
                      ).colorScheme.primary.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    child: Text(
                      'Genre $genreId',
                      style: AppTextStyles.s14w600.c(
                        Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
            SizedBox(height: 20.h),
            Text(
              'Overview',
              style: AppTextStyles.s20w700.c(
                Theme.of(context).colorScheme.onSurface,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              movie.overview.isNotEmpty
                  ? movie.overview
                  : 'No overview available.',
              style: AppTextStyles.s16w400.c(
                Theme.of(context).colorScheme.onSurface,
              ),
            ),
            SizedBox(height: 12.h),
            Row(
              children: [
                Icon(
                  Icons.visibility,
                  size: 16.r,
                  color: Theme.of(
                    context,
                  ).colorScheme.onSurface.withOpacity(0.7),
                ),
                SizedBox(width: 4.w),
                Text(
                  'Popularity: ${movie.popularity.toStringAsFixed(0)}',
                  style: AppTextStyles.s14w400.c(
                    Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
