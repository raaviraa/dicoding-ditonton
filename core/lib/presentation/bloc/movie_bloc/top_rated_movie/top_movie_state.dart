part of 'top_movie_bloc.dart';

abstract class TopMoviesState extends Equatable {}

class TopMoviesEmpty extends TopMoviesState {
  @override
  List<Object?> get props => [];
}

class TopMoviesLoading extends TopMoviesState {
  @override
  List<Object?> get props => [];
}

class TopMoviesError extends TopMoviesState {
  final String message;
  TopMoviesError(this.message);
  @override
  List<Object?> get props => [message];
}

class TopMoviesHasData extends TopMoviesState {
  final List<Movie> result;
  TopMoviesHasData(this.result);

  @override
  List<Object?> get props => [result];

  @override
  String toString() => 'TopMoviesHasData(result: $result)';
}
