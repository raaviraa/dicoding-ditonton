import 'package:bloc_test/bloc_test.dart';
import 'package:core/presentation/bloc/movie_bloc/movie_detail/detail_movie_bloc.dart';
import 'package:core/presentation/bloc/movie_bloc/movie_recomendation/movie_recomd_bloc.dart';
import 'package:core/presentation/bloc/movie_bloc/now_playing_movie/now_playing_bloc.dart';
import 'package:core/presentation/bloc/movie_bloc/popular_movie/popular_movie_bloc.dart';
import 'package:core/presentation/bloc/movie_bloc/top_rated_movie/top_movie_bloc.dart';
import 'package:core/presentation/bloc/movie_bloc/watchlist_movie/watchlist_bloc.dart';
import 'package:mocktail/mocktail.dart';

// fake detail movie bloc
class FakeDetailMovieEvent extends Fake implements DetailMovieEvent {}

class FakeDetailMovieState extends Fake implements DetailMovieState {}

class FakeDetailMovieBloc extends MockBloc<DetailMovieEvent, DetailMovieState>
    implements DetailMovieBloc {}

// fake movie recommendations bloc
class FakeMovieRecomdEvent extends Fake implements MovieRecomdEvent {}

class FakeMovieRecomdState extends Fake implements MovieRecomdState {}

class FakeMovieRecomdBloc extends MockBloc<MovieRecomdEvent, MovieRecomdState>
    implements MovieRecomdBloc {}

// fake watchlist movies bloc
class FakeWatchlistEvent extends Fake implements WatchlistEvent {}

class FakeWatchlistState extends Fake implements WatchlistState {}

class FakeWatchlistBloc extends MockBloc<WatchlistEvent, WatchlistState>
    implements WatchlistBloc {}

// fake now playing movies bloc
class FakeNowPlayingMoviesEvent extends Fake implements NowPlayingMovieEvent {}

class FakeNowPlayingMoviesState extends Fake implements NowPlayingMovieState {}

class FakeNowPlayingMoviesBloc
    extends MockBloc<NowPlayingMovieEvent, NowPlayingMovieState>
    implements NowPlayingMovieBloc {}

// fake popular movies bloc
class FakePopularMoviesEvent extends Fake implements PopularEvent {}

class FakePopularMoviesState extends Fake implements PopularState {}

class FakePopularBloc extends MockBloc<PopularEvent, PopularState>
    implements PopularMoviesBloc {}

// fake top rated movies bloc
class FakeTopRatedMoviesEvent extends Fake implements TopMoviesEvent {}

class FakeTopRatedMoviesState extends Fake implements TopMoviesState {}

class FakeTopRatedMoviesBloc extends MockBloc<TopMoviesEvent, TopMoviesState>
    implements TopRatedMoviesBloc {}
