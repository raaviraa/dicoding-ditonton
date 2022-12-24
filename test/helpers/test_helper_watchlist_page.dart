import 'package:core/presentation/bloc/movie_bloc/watchlist_movie/watchlist_bloc.dart';
import 'package:core/presentation/bloc/tv_bloc/watchlist_tv/watchlist_tv_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:bloc_test/bloc_test.dart';

class FakeWatchlistEvent extends Fake implements WatchlistEvent {}

class FakeWatchlistState extends Fake implements WatchlistState {}

class FakeWatchlistBloc extends MockBloc<WatchlistEvent, WatchlistState>
    implements WatchlistBloc {}

class FakeWatchlistTvEvent extends Fake implements WatchlistTvEvent {}

class FakeWatchlistTvState extends Fake implements WatchlistTvState {}

class FakeWatchlistTvBloc extends MockBloc<WatchlistTvEvent, WatchlistTvState>
    implements WatchlistTvBloc {}
