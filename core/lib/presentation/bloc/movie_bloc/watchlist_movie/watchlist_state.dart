part of 'watchlist_bloc.dart';

abstract class WatchlistState extends Equatable {}

class WatchlistEmpty extends WatchlistState {
  @override
  List<Object?> get props => [];
}

class WatchlistLoading extends WatchlistState {
  @override
  List<Object?> get props => [];
}

class WatchlistError extends WatchlistState {
  final String message;
  WatchlistError(this.message);
  @override
  List<Object?> get props => [message];
}

class WatchlistHasData extends WatchlistState {
  final List<Movie> result;
  WatchlistHasData(this.result);
  @override
  List<Object?> get props => [result];
}

class WatchlistMoviesIsAdded extends WatchlistState {
  final bool isAdded;
  WatchlistMoviesIsAdded(this.isAdded);
  @override
  List<Object?> get props => [isAdded];
}

class WatchlistMessage extends WatchlistState {
  final String message;

  WatchlistMessage(this.message);
  @override
  List<Object?> get props => [message];
}
