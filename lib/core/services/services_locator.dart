import 'package:get_it/get_it.dart';
import 'package:movies_app_clean/movies/data/data_source/remote/movie_remote_data_source.dart';
import 'package:movies_app_clean/movies/domain/repo/base_movies_repository.dart';

import '../../movies/data/repo/movie_repository.dart';
import '../../movies/domain/usecase/get_now_playing_usecase.dart';
import '../../movies/presentation/controller/cubit/movies_bloc.dart';

final sl = GetIt.instance;

class ServicesLocator {
  void init() {
    //BLOC
    //when i open page it will create new instance of MoviesBloc
    sl.registerFactory(() => MoviesBloc(sl()));
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
