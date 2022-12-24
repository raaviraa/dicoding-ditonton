part of 'search_tv_bloc.dart';

//import 'package:equatable/equatable.dart';

// import 'package:equatable/equatable.dart';

abstract class SearchTvEvent extends Equatable {
  const SearchTvEvent();

  @override
  List<Object> get props => [];
}

class TvOnQueryChanged extends SearchTvEvent {
  final String query;

  const TvOnQueryChanged(this.query);

  @override
  List<Object> get props => [query];
}
