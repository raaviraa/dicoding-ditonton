part of 'top_movie_bloc.dart';

abstract class TopMoviesEvent extends Equatable {}

class OnTopMoviesCalled extends TopMoviesEvent {
  @override
  List<Object?> get props => [];
}
