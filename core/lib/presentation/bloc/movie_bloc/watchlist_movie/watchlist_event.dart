part of 'watchlist_bloc.dart';

abstract class WatchlistEvent extends Equatable {}

class OnWatchlistCalled extends WatchlistEvent {
  @override
  List<Object?> get props => [];
}

class FetchWatchlistMovieStatus extends WatchlistEvent {
  final int id;
  FetchWatchlistMovieStatus(this.id);
  @override
  List<Object?> get props => [id];
}

class AddMovieToWatchlist extends WatchlistEvent {
  final MovieDetail movieDetail;
  AddMovieToWatchlist(this.movieDetail);
  @override
  List<Object?> get props => [movieDetail];
}

class RemoveMovieFromWatchlist extends WatchlistEvent {
  final MovieDetail movieDetail;
  RemoveMovieFromWatchlist(this.movieDetail);
  @override
  List<Object?> get props => [movieDetail];
}
