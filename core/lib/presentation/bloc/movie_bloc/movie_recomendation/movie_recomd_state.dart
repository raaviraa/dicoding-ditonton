part of 'movie_recomd_bloc.dart';

abstract class MovieRecomdState extends Equatable {}

class MovieRecomdEmpty extends MovieRecomdState {
  @override
  List<Object?> get props => [];
}

class MovieRecomdLoading extends MovieRecomdState {
  @override
  List<Object?> get props => [];
}

class MovieRecomdError extends MovieRecomdState {
  final String message;
  MovieRecomdError(this.message);
  @override
  List<Object?> get props => [message];
}

class MovieRecomdHasData extends MovieRecomdState {
  final List<Movie> result;
  MovieRecomdHasData(this.result);
  @override
  List<Object?> get props => [result];
}
