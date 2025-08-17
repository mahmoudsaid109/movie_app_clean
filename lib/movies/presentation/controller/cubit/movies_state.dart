import 'package:equatable/equatable.dart';
import 'package:movies_app_clean/core/utils/enums.dart';
import 'package:movies_app_clean/movies/domain/entities/movie.dart';

class MoviesState extends Equatable {
  final List<Movie> nowPlayingMovies;
  //request state is an enum to allow to me show state (loading , success , error)
  final RequestState nowPlayingState;
  final String nowPlayingMessage;

  const MoviesState({
    this.nowPlayingMovies = const [],
    this.nowPlayingState = RequestState.loading,
    this.nowPlayingMessage = '',
  });
  @override
  List<Object?> get props => [nowPlayingMovies, nowPlayingState, nowPlayingMessage];
}
