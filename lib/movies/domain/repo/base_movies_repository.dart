import 'package:movies_app_clean/movies/domain/entities/movie.dart';

abstract class BaseMoviesRepository {
  Future<List<Movie>> getNowPlayingMovies();
  Future<List<Movie>> getPopularMovies();
  Future<List<Movie>> getTopRatedMovies();
}
