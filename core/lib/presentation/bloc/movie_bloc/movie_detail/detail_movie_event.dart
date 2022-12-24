part of 'detail_movie_bloc.dart';

//import 'package:equatable/equatable.dart';

abstract class DetailMovieEvent extends Equatable {
  const DetailMovieEvent();

  @override
  List<Object> get props => [];
}

class OnDetailMovieCalled extends DetailMovieEvent {
  final int id;

  const OnDetailMovieCalled(this.id);

  @override
  List<Object> get props => [id];
}
