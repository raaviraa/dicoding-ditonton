import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../domain/entities/tv_entities.dart';
import '../../../../domain/usecases/get_top_rated_tv.dart';

part 'top_tv_event.dart';
part 'top_tv_state.dart';

class TopRatedTvBloc extends Bloc<TopRatedTvEvent, TopRatedTvState> {
  final GetTopRatedTv _getTopRatedTv;
  TopRatedTvBloc(this._getTopRatedTv) : super(TopRatedTvEmpty()) {
    on<OnTopRatedTvCalled>((event, emit) async {
      emit(TopRatedTvLoading());
      final result = await _getTopRatedTv.execute();

      result.fold(
        (failure) => emit(TopRatedTvError(failure.message)),
        (data) => data.isNotEmpty
            ? emit(TopRatedTvHasData(data))
            : emit(TopRatedTvEmpty()),
      );
    });
  }
}
