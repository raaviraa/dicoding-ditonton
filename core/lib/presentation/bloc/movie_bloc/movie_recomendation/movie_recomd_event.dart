part of 'movie_recomd_bloc.dart';

abstract class MovieRecomdEvent extends Equatable {}

class OnMovieRecomdCalled extends MovieRecomdEvent {
  final int id;

  OnMovieRecomdCalled(this.id);

  @override
  List<Object?> get props => [id];
}
