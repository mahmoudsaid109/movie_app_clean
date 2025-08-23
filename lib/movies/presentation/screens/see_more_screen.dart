import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:movies_app_clean/core/services/services_locator.dart';
import 'package:movies_app_clean/core/utils/enums.dart';
import 'package:movies_app_clean/movies/domain/entities/movie.dart';
import 'package:movies_app_clean/movies/presentation/controller/cubit/movies_bloc.dart';
import 'package:movies_app_clean/movies/presentation/controller/cubit/movies_events.dart';
import 'package:movies_app_clean/movies/presentation/controller/cubit/movies_state.dart';
import 'package:movies_app_clean/movies/presentation/widgets/see_more_movie_row_card.dart';

enum MovieType { popular, topRated }

class SeeMoreScreen extends StatelessWidget {
  final MovieType movieType;
  final String title;

  const SeeMoreScreen({
    super.key,
    required this.movieType,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (context) =>
              sl<MoviesBloc>()..add(
                movieType == MovieType.popular
                    ? GetPopularMoviesEvent()
                    : GetTopRatedMoviesEvent(),
              ),
      child: Scaffold(
        // extendBodyBehindAppBar: true,
        backgroundColor: Colors.grey.shade900,
        appBar: _buildAppBar(),
        body: const SeeMoreBody(),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      centerTitle: true,
      // ignore: deprecated_member_use
      backgroundColor: Colors.black.withOpacity(0.7),
      elevation: 5,
      title: Text(
        title,
        style: GoogleFonts.poppins(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
      iconTheme: const IconThemeData(color: Colors.white),
    );
  }
}

class SeeMoreBody extends StatelessWidget {
  const SeeMoreBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MoviesBloc, MoviesState>(
      builder: (context, state) {
        final movieType =
            (context.findAncestorWidgetOfExactType<SeeMoreScreen>())?.movieType;

        if (movieType == null) {
          return const Center(
            child: Text(
              'Error: Movie type not found',
              style: TextStyle(color: Colors.white),
            ),
          );
        }

        final movies =
            movieType == MovieType.popular
                ? state.popularMovies
                : state.topRatedMovies;
        final requestState =
            movieType == MovieType.popular
                ? state.popularState
                : state.topRatedState;
        final errorMessage =
            movieType == MovieType.popular
                ? state.popularMessage
                : state.topRatedMessage;

        switch (requestState) {
          case RequestState.loading:
            return const LoadingWidget();
          case RequestState.loaded:
            return MoviesListView(movies: movies);
          case RequestState.error:
            return ErrorWidget(message: errorMessage);
        }
      },
    );
  }
}

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: CircularProgressIndicator(color: Colors.amber));
  }
}

class MoviesListView extends StatelessWidget {
  final List<Movie> movies;

  const MoviesListView({super.key, required this.movies});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: movies.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: SeeMoreMovieRowCard(movie: movies[index]),
        );
      },
    );
  }
}

class ErrorWidget extends StatelessWidget {
  final String message;

  const ErrorWidget({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, color: Colors.red, size: 60),
          const SizedBox(height: 16),
          Text(
            'Something went wrong',
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            message,
            style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
