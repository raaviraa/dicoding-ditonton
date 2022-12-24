part of 'detail_movie_bloc.dart';

abstract class DetailMovieState extends Equatable {
  const DetailMovieState();

  @override
  List<Object> get props => [];
}

class DetailMovieEmpty extends DetailMovieState {
  @override
  List<Object> get props => [];
}

class DetailMovieLoading extends DetailMovieState {
  @override
  List<Object> get props => [];
}

class DetailMovieError extends DetailMovieState {
  final String message;

  const DetailMovieError(this.message);

  @override
  List<Object> get props => [message];
}

class DetailMovieHasData extends DetailMovieState {
  // final List<Movie> result;

  // const DetailMovieHasData(this.result);
  final MovieDetail result;

  DetailMovieHasData(this.result);

  @override
  List<Object> get props => [result];
}
