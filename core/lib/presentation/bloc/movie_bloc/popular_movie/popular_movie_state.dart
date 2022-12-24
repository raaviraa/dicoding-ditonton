part of 'popular_movie_bloc.dart';

abstract class PopularState extends Equatable {}

class PopularMoviesEmpty extends PopularState {
  @override
  List<Object> get props => [];
}

class PopularMoviesLoading extends PopularState {
  @override
  List<Object> get props => [];
}

class PopularMoviesError extends PopularState {
  final String message;
  PopularMoviesError(this.message);
  @override
  List<Object> get props => [message];
}

class PopularMoviesHasData extends PopularState {
  final List<Movie> result;
  PopularMoviesHasData(this.result);
  @override
  List<Object> get props => [result];

  @override
  String toString() => 'PopularMoviesHasData(result: $result)';
}
