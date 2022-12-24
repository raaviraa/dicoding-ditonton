part of 'tv_recom_bloc.dart';

abstract class TvRecomEvent extends Equatable {}

class OnTvRecomCalled extends TvRecomEvent {
  final int id;

  OnTvRecomCalled(this.id);

  @override
  List<Object?> get props => [id];
}
