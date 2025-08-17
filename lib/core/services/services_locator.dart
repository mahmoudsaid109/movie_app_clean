import 'package:get_it/get_it.dart';
import 'package:movies_app_clean/movies/data/data_source/remote/movie_remote_data_source.dart';
import 'package:movies_app_clean/movies/domain/repo/base_movies_repository.dart';

import '../../movies/data/repo/movie_repository.dart';
import '../../movies/domain/usecase/get_now_playing_usecase.dart';

final sl = GetIt.instance;

class ServicesLocator {
  void init() {
    //USE CASES
     sl.registerLazySingleton(() => GetNowPlayingUseCase(sl()));
    //REPOSITORIES
    sl.registerLazySingleton<BaseMoviesRepository>(() => MovieRepository(sl()));
    //DATA SOURCES
    sl.registerLazySingleton<BaseMovieRemoteDataSource>(
      () => MovieRemoteDataSource(),
    );
  }
}
