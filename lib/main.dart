import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:movie/firebase_options.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/api/api_service.dart';
import 'core/theme/app_theme.dart';
import 'features/home/data/datasources/local_data_source.dart';
import 'features/home/data/datasources/remote_data_source.dart';
import 'features/home/data/repositories/movie_repository_impl.dart';
import 'features/home/presentation/cubit/cubit/movie_cubit.dart';
import 'features/home/presentation/view/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Initialize Hive
  await Hive.initFlutter();

  // Initialize Firebase Crashlytics
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };

  // Initialize SharedPreferences
  final sharedPreferences = await SharedPreferences.getInstance();

  runZonedGuarded(
    () async {
      runApp(MyApp(sharedPreferences: sharedPreferences));
    },
    (error, stack) {
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    },
  );
}

class MyApp extends StatelessWidget {
  final SharedPreferences sharedPreferences;

  const MyApp({super.key, required this.sharedPreferences});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // Initialize dependencies
    final apiService = ApiService();
    final remoteDataSource = RemoteDataSourceImpl(apiService: apiService);
    final localDataSource = LocalDataSourceImpl();
    final repository = MovieRepositoryImpl(
      remoteDataSource: remoteDataSource,
      localDataSource: localDataSource,
    );

    return BlocProvider(
      create: (context) => MovieCubit(
        repository: repository,
        sharedPreferences: sharedPreferences,
      ),
      child: ScreenUtilInit(
        designSize: const Size(360, 690),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (_, child) => BlocBuilder<MovieCubit, MovieState>(
          builder: (context, state) {
            final isDarkMode = state.isDarkMode;
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'Movie App',
              theme: AppTheme.lightTheme,
              darkTheme: AppTheme.darkTheme,
              themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
              home: const HomeScreen(),
            );
          },
        ),
      ),
    );
  }
}
