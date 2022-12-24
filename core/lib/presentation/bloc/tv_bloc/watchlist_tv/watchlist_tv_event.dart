part of 'watchlist_tv_bloc.dart';

abstract class WatchlistTvEvent extends Equatable {}

class OnWatchlistTvCalled extends WatchlistTvEvent {
  @override
  List<Object?> get props => [];
}

class FetchWatchlistTvStatus extends WatchlistTvEvent {
  final int id;
  FetchWatchlistTvStatus(this.id);
  @override
  List<Object?> get props => [id];
}

class AddTvToWatchlist extends WatchlistTvEvent {
  final TvDetail tvseries;
  AddTvToWatchlist(this.tvseries);
  @override
  List<Object?> get props => [tvseries];
}

class RemoveTvFromWatchlist extends WatchlistTvEvent {
  final TvDetail tvseries;
  RemoveTvFromWatchlist(this.tvseries);
  @override
  List<Object?> get props => [tvseries];
}
