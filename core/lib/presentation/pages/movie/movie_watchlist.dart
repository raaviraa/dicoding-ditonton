import 'package:core/presentation/bloc/movie_bloc/watchlist_movie/watchlist_bloc.dart';
import 'package:core/presentation/pages/movie/home_movie_page.dart';
import 'package:core/presentation/widgets/movie_card_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../utils/utils.dart';

class WatchlistMoviePage extends StatefulWidget {
  static const WATCHLIST_MOVIE = '/watchlist-movie';

  const WatchlistMoviePage({Key? key}) : super(key: key);

  @override
  State<WatchlistMoviePage> createState() => _WatchlistMoviePageState();
}

class _WatchlistMoviePageState extends State<WatchlistMoviePage>
    with RouteAware {
  @override
  void initState() {
    super.initState();
    Future.microtask(
        () => context.read<WatchlistBloc>().add(OnWatchlistCalled()));
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context)!);
  }

  @override
  void didPopNext() {
    context.read<WatchlistBloc>().add(OnWatchlistCalled());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocBuilder<WatchlistBloc, WatchlistState>(
            builder: (context, state) {
          if (state is WatchlistLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is WatchlistHasData) {
            final watchlistMovies = state.result;
            return ListView.builder(
              itemBuilder: (context, index) {
                final movie = watchlistMovies[index];
                return MovieCard(movie);
              },
              itemCount: watchlistMovies.length,
            );
          } else if (state is WatchlistEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    "You don't have any movies yet, lets add some!",
                    textAlign: TextAlign.center,
                  ),
                  ElevatedButton(
                    onPressed: () => Navigator.pushNamedAndRemoveUntil(
                      context,
                      HomeMoviePage.ROUTE_HOMEMOVIE,
                      (route) => false,
                    ),
                    child: const Text('Add Movie'),
                  ),
                ],
              ),
            );
          } else {
            return const Center(
              key: Key('error_msg'),
              child: Text('Failed to fetch data'),
            );
          }
        }),
      ),
    );
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }
}
