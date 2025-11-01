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
          style: AppTextStyles.s16w700.c(
            Theme.of(context).colorScheme.onSurface,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(12.0.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (movie.fullBackdropPath.isNotEmpty)
              ClipRRect(
                borderRadius: BorderRadius.circular(8.r),
                child: CachedNetworkImage(
                  imageUrl: movie.fullBackdropPath,
                  width: double.infinity,
                  height: 180.h,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(
                    width: double.infinity,
                    height: 180.h,
                    color: Colors.grey[300],
                    child: const Center(
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  ),
                  errorWidget: (context, url, error) => Container(
                    width: double.infinity,
                    height: 180.h,
                    color: Colors.grey[300],
                    child: Icon(Icons.image_not_supported, size: 40.r),
                  ),
                ),
              )
            else if (movie.fullPosterPath.isNotEmpty)
              Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8.r),
                  child: CachedNetworkImage(
                    imageUrl: movie.fullPosterPath,
                    width: 150.w,
                    height: 220.h,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      width: 150.w,
                      height: 220.h,
                      color: Colors.grey[300],
                      child: const Center(
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    ),
                    errorWidget: (context, url, error) => Container(
                      width: 150.w,
                      height: 220.h,
                      color: Colors.grey[300],
                      child: Icon(Icons.image_not_supported, size: 40.r),
                    ),
                  ),
                ),
              ),
            SizedBox(height: 10.h),
            Text(
              movie.title,
              style: AppTextStyles.s18w700.c(
                Theme.of(context).colorScheme.onSurface,
              ),
            ),
            if (movie.originalTitle != movie.title) ...[
              SizedBox(height: 3.h),
              Text(
                movie.originalTitle,
                style: AppTextStyles.s14w400.c(
                  Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                ),
              ),
            ],
            SizedBox(height: 8.h),
            Row(
              children: [
                Row(
                  children: [
                    Icon(Icons.star, size: 16.r, color: Colors.amber),
                    SizedBox(width: 3.w),
                    Text(
                      '${movie.voteAverage.toStringAsFixed(1)}/10',
                      style: AppTextStyles.s14w600.c(
                        Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                    SizedBox(width: 6.w),
                    Text(
                      '(${movie.voteCount} votes)',
                      style: AppTextStyles.s12w400.c(
                        Theme.of(
                          context,
                        ).colorScheme.onSurface.withOpacity(0.6),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 6.h),
            if (movie.releaseDate.isNotEmpty)
              Row(
                children: [
                  Icon(
                    Icons.calendar_today,
                    size: 12.r,
                    color: Theme.of(
                      context,
                    ).colorScheme.onSurface.withOpacity(0.7),
                  ),
                  SizedBox(width: 3.w),
                  Text(
                    'Released: ${movie.releaseDate}',
                    style: AppTextStyles.s12w400.c(
                      Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                    ),
                  ),
                ],
              ),
            SizedBox(height: 6.h),
            if (movie.originalLanguage.isNotEmpty)
              Row(
                children: [
                  Icon(
                    Icons.language,
                    size: 12.r,
                    color: Theme.of(
                      context,
                    ).colorScheme.onSurface.withOpacity(0.7),
                  ),
                  SizedBox(width: 3.w),
                  Text(
                    'Language: ${movie.originalLanguage.toUpperCase()}',
                    style: AppTextStyles.s12w400.c(
                      Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                    ),
                  ),
                ],
              ),
            if (movie.genreIds.isNotEmpty) ...[
              SizedBox(height: 8.h),
              Wrap(
                spacing: 6.w,
                runSpacing: 6.h,
                children: movie.genreIds.take(3).map((genreId) {
                  return Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 10.w,
                      vertical: 4.h,
                    ),
                    decoration: BoxDecoration(
                      color: Theme.of(
                        context,
                      ).colorScheme.primary.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                    child: Text(
                      'Genre $genreId',
                      style: AppTextStyles.s12w600.c(
                        Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
            SizedBox(height: 12.h),
            Text(
              'Overview',
              style: AppTextStyles.s16w700.c(
                Theme.of(context).colorScheme.onSurface,
              ),
            ),
            SizedBox(height: 6.h),
            Text(
              movie.overview.isNotEmpty
                  ? movie.overview
                  : 'No overview available.',
              style: AppTextStyles.s14w400.c(
                Theme.of(context).colorScheme.onSurface,
              ),
            ),
            SizedBox(height: 10.h),
            Row(
              children: [
                Icon(
                  Icons.visibility,
                  size: 12.r,
                  color: Theme.of(
                    context,
                  ).colorScheme.onSurface.withOpacity(0.7),
                ),
                SizedBox(width: 3.w),
                Text(
                  'Popularity: ${movie.popularity.toStringAsFixed(0)}',
                  style: AppTextStyles.s12w400.c(
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
