import 'package:about/about_page.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:core/presentation/pages/movie/movie_detail_page.dart';
import 'package:core/presentation/pages/movie/now_playing_m_page.dart';
import 'package:core/presentation/pages/movie/popular_movies_page.dart';
import 'package:core/presentation/pages/movie/top_rated_movies_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core.dart';
import '../../../domain/entities/movie.dart';
import '../../../utils/routes.dart';
import '../../bloc/movie_bloc/now_playing_movie/now_playing_bloc.dart';
import '../../bloc/movie_bloc/popular_movie/popular_movie_bloc.dart';
import '../../bloc/movie_bloc/top_rated_movie/top_movie_bloc.dart';
import '../tv/home_tv.dart';
import '../tv/tv_watchlist_page.dart';
import 'movie_watchlist.dart';

class HomeMoviePage extends StatefulWidget {
  @override
  _HomeMoviePageState createState() => _HomeMoviePageState();
  static const ROUTE_HOMEMOVIE = '/home';
}

class _HomeMoviePageState extends State<HomeMoviePage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      BlocProvider.of<NowPlayingMovieBloc>(context, listen: false)
          .add(OnNowPlayingMovieCalled());
      BlocProvider.of<TopRatedMoviesBloc>(context, listen: false)
          .add(OnTopMoviesCalled());
      BlocProvider.of<PopularMoviesBloc>(context, listen: false)
          .add(OnPopularCalled());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: Column(
          children: [
            UserAccountsDrawerHeader(
              currentAccountPicture: CircleAvatar(
                backgroundImage: AssetImage('assets/circle-g.png'),
              ),
              accountName: Text('Ditonton'),
              accountEmail: Text('ditonton@dicoding.com'),
            ),
            ExpansionTile(
              title: Text('Select Show'),
              leading: Icon(Icons.play_circle),
              children: <Widget>[
                ListTile(
                  leading: Icon(Icons.movie),
                  title: Text('Movies'),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  leading: Icon(Icons.tv),
                  title: Text('Tv '),
                  onTap: () {
                    Navigator.pushNamed(context, HomeTelevisionPage.HOME_TV);
                  },
                ),
              ],
            ),
            ExpansionTile(
              title: Text('My Watchlist'),
              leading: Icon(Icons.save_alt),
              children: <Widget>[
                ListTile(
                  leading: Icon(Icons.movie),
                  title: Text('Movies Watchlist'),
                  onTap: () {
                    Navigator.pushNamed(
                        context, WatchlistMoviePage.WATCHLIST_MOVIE);
                  },
                ),
                ListTile(
                  leading: Icon(Icons.tv),
                  title: Text('Tv Watchlist'),
                  onTap: () {
                    Navigator.pushNamed(
                        context, WatchlistTelevisionPage.WATCHLIST_TV);
                  },
                ),
              ],
            ),
            ListTile(
              onTap: () {
                Navigator.pushNamed(context, AboutPage.ROUTE_NAME);
              },
              leading: Icon(Icons.info_outline),
              title: Text('About'),
            ),
          ],
        ),
      ),
      appBar: AppBar(
        title: Text('Ditonton'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, SEARCH_MOVIE);
            },
            icon: Icon(Icons.search),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Now Playing Movie', style: kHeading6),
              _buildSubHeading(
                title: 'Now Playing',
                onTap: () => Navigator.pushNamed(
                    context, NowPlayingMoviesPage.NOW_PLAYING_MOVIES_ROUTE),
              ),
              BlocBuilder<NowPlayingMovieBloc, NowPlayingMovieState>(
                  builder: (context, state) {
                if (state is NowPlayingMovieLoading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (state is NowPlayingMovieHasData) {
                  final data = state.result;
                  return MovieList(data);
                } else if (state is NowPlayingMovieError) {
                  return const Text(
                    'Failed to fetch data',
                    key: Key('error_message'),
                  );
                } else {
                  return Container();
                }
              }),
              _buildSubHeading(
                title: 'Popular Movie',
                onTap: () => Navigator.pushNamed(
                    context, PopularMoviesPage.POPULAR_MOVIES_ROUTE),
              ),
              BlocBuilder<PopularMoviesBloc, PopularState>(
                  builder: (context, state) {
                if (state is NowPlayingMovieLoading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (state is PopularMoviesHasData) {
                  return MovieList(state.result);
                } else if (state is PopularMoviesError) {
                  return Text(state.message);
                } else {
                  return const Center();
                }
              }),
              _buildSubHeading(
                title: 'Top Rated Movie',
                onTap: () => Navigator.pushNamed(
                    context, TopRatedMoviesPage.TOP_RATED_MOVIE),
              ),
              BlocBuilder<TopRatedMoviesBloc, TopMoviesState>(
                  builder: (context, state) {
                if (state is TopMoviesLoading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (state is TopMoviesHasData) {
                  return MovieList(state.result);
                } else if (state is TopMoviesError) {
                  return Text(state.message);
                } else {
                  return const Center();
                }
              }),
            ],
          ),
        ),
      ),
    );
  }

  Row _buildSubHeading({required String title, required Function() onTap}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: kHeading6,
        ),
        InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [Text('See More'), Icon(Icons.arrow_forward_ios)],
            ),
          ),
        ),
      ],
    );
  }
}

class MovieList extends StatelessWidget {
  final List<Movie> movies;

  MovieList(this.movies);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          final movie = movies[index];
          return Container(
            padding: const EdgeInsets.all(8),
            child: InkWell(
              onTap: () {
                Navigator.pushNamed(
                  context,
                  MovieDetailPage.MOVIE_DETAIL_ROUTE,
                  arguments: movie.id,
                );
              },
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(16)),
                child: CachedNetworkImage(
                  imageUrl: '$BASE_IMAGE_URL${movie.posterPath}',
                  placeholder: (context, url) => Center(
                    child: CircularProgressIndicator(),
                  ),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                ),
              ),
            ),
          );
        },
        itemCount: movies.length,
      ),
    );
  }
}
