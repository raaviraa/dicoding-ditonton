// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'top_tv_bloc.dart';

abstract class TopRatedTvState extends Equatable {}

class TopRatedTvEmpty extends TopRatedTvState {
  @override
  List<Object?> get props => [];
}

class TopRatedTvLoading extends TopRatedTvState {
  @override
  List<Object?> get props => [];
}

class TopRatedTvError extends TopRatedTvState {
  final String message;
  TopRatedTvError(this.message);
  @override
  List<Object?> get props => [message];
}

class TopRatedTvHasData extends TopRatedTvState {
  final List<Tv> result;
  TopRatedTvHasData(this.result);

  @override
  List<Object?> get props => [result];

  @override
  String toString() => 'TopRatedTvHasData(result: $result)';
}
