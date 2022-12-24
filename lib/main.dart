import 'package:about/about_page.dart';
import 'package:core/core.dart';
import 'package:core/presentation/bloc/movie_bloc/movie_detail/detail_movie_bloc.dart';
import 'package:core/presentation/bloc/movie_bloc/movie_recomendation/movie_recomd_bloc.dart';
import 'package:core/presentation/bloc/movie_bloc/now_playing_movie/now_playing_bloc.dart';
import 'package:core/presentation/bloc/movie_bloc/popular_movie/popular_movie_bloc.dart';
import 'package:core/presentation/bloc/movie_bloc/top_rated_movie/top_movie_bloc.dart';
import 'package:core/presentation/bloc/movie_bloc/watchlist_movie/watchlist_bloc.dart';
import 'package:core/presentation/bloc/tv_bloc/now_playing_tv/noplay_tv_bloc.dart';
import 'package:core/presentation/bloc/tv_bloc/popular_tv/popular_tv_bloc.dart';
import 'package:core/presentation/bloc/tv_bloc/top_rated_tv/top_tv_bloc.dart';
import 'package:core/presentation/bloc/tv_bloc/tv_detail/tv_detail_bloc.dart';
import 'package:core/presentation/bloc/tv_bloc/tv_reccomendation/tv_recom_bloc.dart';
import 'package:core/presentation/bloc/tv_bloc/watchlist_tv/watchlist_tv_bloc.dart';
import 'package:core/presentation/pages/movie/home_movie_page.dart';
import 'package:core/presentation/pages/movie/movie_watchlist.dart';
import 'package:core/presentation/pages/tv/home_tv.dart';
import 'package:core/presentation/pages/movie/movie_detail_page.dart';
import 'package:core/presentation/pages/movie/popular_movies_page.dart';
import 'package:core/presentation/pages/tv/popular_tv_page.dart';
import 'package:core/presentation/pages/movie/top_rated_movies_page.dart';
import 'package:core/presentation/pages/tv/top_rated_tv_page.dart';
import 'package:core/presentation/pages/tv/tv_detail_page.dart';
import 'package:core/presentation/pages/tv/tv_watchlist_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:search/presentation/bloc/movie/search_movie_bloc.dart';
import 'package:search/presentation/bloc/tv/search_tv_bloc.dart';
import 'package:search/presentation/pages/search_tv_page.dart';
import 'package:search/search.dart';
import 'package:core/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ditonton/injection.dart' as di;

void main() {
  di.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => di.locator<NowPlayingMovieBloc>(),
        ),
        BlocProvider(
          create: (_) => di.locator<SearchMovieBloc>(),
        ),
        BlocProvider(
          create: (_) => di.locator<MovieRecomdBloc>(),
        ),
        BlocProvider(
          create: (_) => di.locator<DetailMovieBloc>(),
        ),
        BlocProvider(
          create: (_) => di.locator<TopRatedMoviesBloc>(),
        ),
        BlocProvider(
          create: (_) => di.locator<PopularMoviesBloc>(),
        ),
        BlocProvider(
          create: (_) => di.locator<WatchlistBloc>(),
        ),
        //tv
        BlocProvider(
          create: (_) => di.locator<NowPlayingTvBloc>(),
        ),
        BlocProvider(
          create: (_) => di.locator<SearchTvBloc>(),
        ),
        BlocProvider(
          create: (_) => di.locator<TvRecomBloc>(),
        ),
        BlocProvider(
          create: (_) => di.locator<TvDetailBloc>(),
        ),
        BlocProvider(
          create: (_) => di.locator<TopRatedTvBloc>(),
        ),
        BlocProvider(
          create: (_) => di.locator<PopularTvSeriesBloc>(),
        ),
        BlocProvider(
          create: (_) => di.locator<WatchlistTvBloc>(),
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData.dark().copyWith(
          colorScheme: kColorScheme,
          primaryColor: kRichBlack,
          scaffoldBackgroundColor: kRichBlack,
          textTheme: kTextTheme,
        ),
        home: HomeMoviePage(),
        navigatorObservers: [routeObserver],
        onGenerateRoute: (RouteSettings settings) {
          switch (settings.name) {
            case HomeMoviePage.ROUTE_HOMEMOVIE:
              return MaterialPageRoute(builder: (_) => HomeMoviePage());
            case PopularMoviesPage.POPULAR_MOVIES_ROUTE:
              return CupertinoPageRoute(builder: (_) => PopularMoviesPage());
            case TopRatedMoviesPage.TOP_RATED_MOVIE:
              return CupertinoPageRoute(builder: (_) => TopRatedMoviesPage());
            case MovieDetailPage.MOVIE_DETAIL_ROUTE:
              final id = settings.arguments as int;
              return MaterialPageRoute(
                builder: (_) => MovieDetailPage(id: id),
                settings: settings,
              );

            case HomeTelevisionPage.HOME_TV:
              return MaterialPageRoute(builder: (_) => HomeTelevisionPage());
            case PopularTvSeriesPage.POPULAR_TV:
              return CupertinoPageRoute(builder: (_) => PopularTvSeriesPage());
            case TopRatedTelevisionPage.TOP_RATED_TV:
              return CupertinoPageRoute(
                  builder: (_) => TopRatedTelevisionPage());
            case TelevisionDetailPage.TV_DETAIL:
              final id = settings.arguments as int;
              return MaterialPageRoute(
                builder: (_) => TelevisionDetailPage(id: id),
                settings: settings,
              );

            case SearchMoviePage.SEARCH_MOVIE:
              return CupertinoPageRoute(builder: (_) => SearchMoviePage());
            case WatchlistMoviePage.WATCHLIST_MOVIE:
              return MaterialPageRoute(builder: (_) => WatchlistMoviePage());

            case SearchTvPage.SEARCH_TV:
              return CupertinoPageRoute(builder: (_) => SearchTvPage());
            case WatchlistTelevisionPage.WATCHLIST_TV:
              return MaterialPageRoute(
                  builder: (_) => WatchlistTelevisionPage());

            case AboutPage.ROUTE_NAME:
              return MaterialPageRoute(builder: (_) => AboutPage());
            default:
              return MaterialPageRoute(builder: (_) {
                return Scaffold(
                  body: Center(
                    child: Text('Page not found :('),
                  ),
                );
              });
          }
        },
      ),
    );
  }
}
