import 'package:flutter/material.dart';
import 'package:movies_app_clean/core/network/connectivty.dart';
import 'package:movies_app_clean/core/services/services_locator.dart';
import 'movies/presentation/screens/movies_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  ServicesLocator().init();

  ConnectivityService().startMonitoring();

  runApp(const MovieApp());
}

class MovieApp extends StatelessWidget {
  const MovieApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Movies App',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Colors.grey.shade900,
      ),
      builder: (context, child) {
        return ConnectivityWrapper(child: child ?? Container());
      },
      home: const MoviesScreen(),
    );
  }
}
