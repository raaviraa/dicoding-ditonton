part of 'tv_recom_bloc.dart';

abstract class TvRecomState extends Equatable {}

class TvRecomEmpty extends TvRecomState {
  @override
  List<Object?> get props => [];
}

class TvRecomLoading extends TvRecomState {
  @override
  List<Object?> get props => [];
}

class TvRecomError extends TvRecomState {
  final String message;
  TvRecomError(this.message);
  @override
  List<Object?> get props => [message];
}

class TvRecomHasData extends TvRecomState {
  final List<Tv> result;
  TvRecomHasData(this.result);
  @override
  List<Object?> get props => [result];
}
