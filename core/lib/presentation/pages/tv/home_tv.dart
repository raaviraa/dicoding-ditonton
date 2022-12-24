import 'package:about/about_page.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:core/core.dart';
import 'package:core/domain/entities/tv_entities.dart';
import 'package:core/presentation/bloc/tv_bloc/now_playing_tv/noplay_tv_bloc.dart';
import 'package:core/presentation/bloc/tv_bloc/popular_tv/popular_tv_bloc.dart';
import 'package:core/presentation/bloc/tv_bloc/top_rated_tv/top_tv_bloc.dart';
import 'package:core/presentation/pages/movie/home_movie_page.dart';
import 'package:core/presentation/pages/movie/movie_watchlist.dart';
import 'package:core/presentation/pages/tv/now_playing_tv_page.dart';
import 'package:core/presentation/pages/tv/popular_tv_page.dart';
import 'package:core/presentation/pages/tv/top_rated_tv_page.dart';
import 'package:core/presentation/pages/tv/tv_detail_page.dart';
import 'package:core/presentation/pages/tv/tv_watchlist_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:search/presentation/pages/search_tv_page.dart';

class HomeTelevisionPage extends StatefulWidget {
  const HomeTelevisionPage({Key? key}) : super(key: key);
  static const HOME_TV = '/tv-page';

  @override
  State<HomeTelevisionPage> createState() => _HomeTelevisionPageState();
}

class _HomeTelevisionPageState extends State<HomeTelevisionPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      BlocProvider.of<NowPlayingTvBloc>(context, listen: false)
          .add(NowPlayingTv());
      BlocProvider.of<TopRatedTvBloc>(context, listen: false)
          .add(OnTopRatedTvCalled());
      BlocProvider.of<PopularTvSeriesBloc>(context, listen: false)
          .add(OnPopularTvCalled());

      // context.read<NowPlayingTvBloc>().add(NowPlayingTv());
      // context.read<PopularTvSeriesBloc>().add(OnPopularTvCalled());
      // context.read<TopRatedTvBloc>().add(OnTopRatedTvCalled());
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
                    Navigator.pushNamed(context, HomeMoviePage.ROUTE_HOMEMOVIE);
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
              Navigator.pushNamed(context, SearchTvPage.SEARCH_TV);
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
              Text('Now Playing Tv', style: kHeading6),
              _buildSubHeading(
                title: 'Now Playing',
                onTap: () => Navigator.pushNamed(
                    context, NowPlayingTvSeriesPage.NOW_PLAYING_TV),
              ),
              BlocBuilder<NowPlayingTvBloc, NowPlayingTvState>(
                  builder: (context, state) {
                if (state is NowPlayingTvLoading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (state is NowPlayingTvHasData) {
                  final data = state.result;
                  return TvSeriesList(data);
                } else if (state is NowPlayingTvError) {
                  return const Text(
                    'Failed to fetch data',
                    key: Key('error_message'),
                  );
                } else {
                  return Container();
                }
              }),
              _buildSubHeading(
                title: 'Popular Tv',
                onTap: () => Navigator.pushNamed(
                    context, PopularTvSeriesPage.POPULAR_TV),
              ),
              BlocBuilder<PopularTvSeriesBloc, PopularTvState>(
                  builder: (context, state) {
                if (state is NowPlayingTvLoading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (state is PopularTvHasData) {
                  return TvSeriesList(state.result);
                } else if (state is PopularTvError) {
                  return Text(state.message);
                } else {
                  return const Center();
                }
              }),
              _buildSubHeading(
                title: 'Top Rated Tv',
                onTap: () => Navigator.pushNamed(
                    context, TopRatedTelevisionPage.TOP_RATED_TV),
              ),
              BlocBuilder<TopRatedTvBloc, TopRatedTvState>(
                  builder: (context, state) {
                if (state is TopRatedTvLoading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (state is TopRatedTvHasData) {
                  return TvSeriesList(state.result);
                } else if (state is TopRatedTvError) {
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
              children: const [Text('See More'), Icon(Icons.arrow_forward_ios)],
            ),
          ),
        ),
      ],
    );
  }
}

class TvSeriesList extends StatelessWidget {
  final List<Tv> tvSeries;

  const TvSeriesList(this.tvSeries, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          final tv = tvSeries[index];
          return Container(
            padding: const EdgeInsets.all(8),
            child: InkWell(
              onTap: () {
                Navigator.pushNamed(
                  context,
                  TelevisionDetailPage.TV_DETAIL,
                  arguments: tv.id,
                );
              },
              child: ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(16)),
                child: CachedNetworkImage(
                  fit: BoxFit.cover,
                  imageUrl: '$BASE_IMAGE_URL${tv.posterPath}',
                  placeholder: (context, url) => const Center(
                    child: CircularProgressIndicator(),
                  ),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                ),
              ),
            ),
          );
        },
        itemCount: tvSeries.length,
      ),
    );
  }
}
