import 'package:get_it/get_it.dart';
import 'package:movies_app_clean/movies/data/data_source/remote/movie_remote_data_source.dart';
import 'package:movies_app_clean/movies/domain/repo/base_movies_repository.dart';

import '../../movies/data/repo/movie_repository.dart';
import '../../movies/domain/usecase/get_movie_details_usecase.dart';
import '../../movies/domain/usecase/get_now_playing_usecase.dart';
import '../../movies/domain/usecase/get_popular_movies_usecase.dart';
import '../../movies/domain/usecase/get_recommendation_usecase.dart';
import '../../movies/domain/usecase/get_top_rated_movies_usecase.dart';
import '../../movies/presentation/controller/cubit/movie_details_bloc.dart';
import '../../movies/presentation/controller/cubit/movies_bloc.dart';

final sl = GetIt.instance;

class ServicesLocator {
  void init() {
    //BLOC
    //when i open page it will create new instance of MoviesBloc
    sl.registerFactory(() => MoviesBloc(sl(), sl(), sl()));
    sl.registerFactory(() => MovieDetailsBloc(sl(), sl()));
    //USE CASES
     sl.registerLazySingleton(() => GetNowPlayingMoviesUseCase(sl()));
     sl.registerLazySingleton(() => GetPopularMoviesUseCase(sl()));
     sl.registerLazySingleton(() => GetTopRatedMoviesUseCase(sl()));
     sl.registerLazySingleton(() => GetMovieDetailsUseCase(sl()));
     sl.registerLazySingleton(() => GetRecommendationUsecase(sl()));
    //REPOSITORIES
    sl.registerLazySingleton<BaseMoviesRepository>(() => MoviesRepository(sl()));
    //DATA SOURCES
    sl.registerLazySingleton<BaseMovieRemoteDataSource>(
      () => MovieRemoteDataSource(),
    );
  }
}
