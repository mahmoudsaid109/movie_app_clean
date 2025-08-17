import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies_app_clean/movies/presentation/controller/cubit/movies_events.dart';

import '../../../core/services/services_locator.dart';
import '../controller/cubit/movies_bloc.dart';
import '../controller/cubit/movies_state.dart'; // Add this import

class MovieScreen extends StatelessWidget {
  const MovieScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) {
        return MoviesBloc(sl())..add(GetNowPlayingMoviesEvent());
      },
      child: BlocBuilder<MoviesBloc, MoviesState>(
        // Added type parameters
        builder: (context, state) {
          print(state);
          return Scaffold(
          );
        },
      ),
    );
  }
}
