// fake now playing Tv Series bloc
import 'package:bloc_test/bloc_test.dart';
import 'package:core/presentation/bloc/tv_bloc/now_playing_tv/noplay_tv_bloc.dart';
import 'package:core/presentation/bloc/tv_bloc/popular_tv/popular_tv_bloc.dart';
import 'package:core/presentation/bloc/tv_bloc/top_rated_tv/top_tv_bloc.dart';
import 'package:core/presentation/bloc/tv_bloc/tv_detail/tv_detail_bloc.dart';
import 'package:core/presentation/bloc/tv_bloc/tv_reccomendation/tv_recom_bloc.dart';
import 'package:core/presentation/bloc/tv_bloc/watchlist_tv/watchlist_tv_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

// fake watchlist Tv bloc
class FakeWatchlistTvEvent extends Fake implements WatchlistTvEvent {}

class FakeWatchlistTvState extends Fake implements WatchlistTvState {}

class FakeWatchlistTvBloc extends MockBloc<WatchlistTvEvent, WatchlistTvState>
    implements WatchlistTvBloc {}

// fake now play Tv bloc
class FakeNowPlayingTvEvent extends Fake implements NowPlayingTvEvent {}

class FakeNowPlayingTvState extends Fake implements NowPlayingTvState {}

class FakeNowPlayingTvBloc
    extends MockBloc<NowPlayingTvEvent, NowPlayingTvState>
    implements NowPlayingTvBloc {}

// fake Tv recom bloc
class FakeTvRecomEvent extends Fake implements TvRecomEvent {}

class FakeTvRecomState extends Fake implements TvRecomState {}

class FakeTvRecomBloc extends MockBloc<TvRecomEvent, TvRecomState>
    implements TvRecomBloc {}

// fake popular Tv bloc
class FakePopularTvSeriesEvent extends Fake implements PopularTvEvent {}

class FakePopularTvSeriesState extends Fake implements PopularTvState {}

class FakePopularTvBloc extends MockBloc<PopularTvEvent, PopularTvState>
    implements PopularTvSeriesBloc {}

// fake detail Tvseries bloc
class FakeTvDetailEvent extends Fake implements TvDetailEvent {}

class FakeTvDetailState extends Fake implements TvDetailState {}

class FakeTvDetailBloc extends MockBloc<TvDetailEvent, TvDetailState>
    implements TvDetailBloc {}

// fake top rated Tvseries bloc
class FakeTopTvEvent extends Fake implements TopRatedTvEvent {}

class FakeTopRatedTvState extends Fake implements TopRatedTvState {}

class FakeTopRatedTvBloc extends MockBloc<TopRatedTvEvent, TopRatedTvState>
    implements TopRatedTvBloc {}
