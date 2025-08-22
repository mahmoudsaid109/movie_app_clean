import 'package:equatable/equatable.dart';
import '../../../../core/utils/enums.dart';
import '../../../domain/entities/movie_details.dart';
import '../../../domain/entities/recommendation.dart';

class MovieDetailsState extends Equatable {
  final MovieDetails? movieDetails;
  final RequestState movieDetailsState;
  final String movieDetailsMessage;
  final List<Recommendation> recommendations;
  final RequestState recommendationsState;
  final String recommendationsMessage;


  const MovieDetailsState({
    this.movieDetails,
    this.movieDetailsState = RequestState.loading,
    this.movieDetailsMessage = '',
    this.recommendations = const [],
    this.recommendationsState = RequestState.loading,
    this.recommendationsMessage = '',
  });
  MovieDetailsState copyWith({
    MovieDetails? movieDetails,
    RequestState? movieDetailsState,
    String? movieDetailsMessage,
    List<Recommendation>? recommendations,
    RequestState? recommendationsState,
    String? recommendationsMessage,
    
  }) {
    return MovieDetailsState(
      movieDetails: movieDetails ?? this.movieDetails,
      movieDetailsState: movieDetailsState ?? this.movieDetailsState,
      movieDetailsMessage: movieDetailsMessage ?? this.movieDetailsMessage,
      recommendations: recommendations ?? this.recommendations,
      recommendationsState: recommendationsState ?? this.recommendationsState,
      recommendationsMessage: recommendationsMessage ?? this.recommendationsMessage,
    );
  }

  @override
  List<Object?> get props => [
    movieDetails,
    movieDetailsState,
    movieDetailsMessage,
    recommendations,
    recommendationsState,
    recommendationsMessage,
  ];
}
