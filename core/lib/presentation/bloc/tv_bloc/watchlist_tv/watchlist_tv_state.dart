part of 'watchlist_tv_bloc.dart';

abstract class WatchlistTvState extends Equatable {}

class WatchlistTvEmpty extends WatchlistTvState {
  @override
  List<Object?> get props => [];
}

class WatchlistTvLoading extends WatchlistTvState {
  @override
  List<Object?> get props => [];
}

class WatchlistTvError extends WatchlistTvState {
  final String message;
  WatchlistTvError(this.message);
  @override
  List<Object?> get props => [message];
}

class WatchlistTvHasData extends WatchlistTvState {
  final List<Tv> result;
  WatchlistTvHasData(this.result);
  @override
  List<Object?> get props => [result];
}

class WatchlistTvIsAdded extends WatchlistTvState {
  final bool isAdded;
  WatchlistTvIsAdded(this.isAdded);
  @override
  List<Object?> get props => [isAdded];
}

class WatchlistTvMessage extends WatchlistTvState {
  final String message;

  WatchlistTvMessage(this.message);
  @override
  List<Object?> get props => [message];
}
