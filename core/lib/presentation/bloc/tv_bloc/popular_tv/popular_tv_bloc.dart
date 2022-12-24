import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../domain/entities/tv_entities.dart';
import '../../../../domain/usecases/get_popular_tv.dart';

part 'popular_tv_event.dart';
part 'popular_tv_state.dart';

class PopularTvSeriesBloc extends Bloc<PopularTvEvent, PopularTvState> {
  final GetPopularTv _getPopularTv;
  PopularTvSeriesBloc(this._getPopularTv) : super(PopularTvEmpty()) {
    on<OnPopularTvCalled>((event, emit) async {
      emit(PopularTvLoading());

      final result = await _getPopularTv.execute();

      result.fold(
        (failure) => emit(PopularTvError(failure.message)),
        (data) => data.isNotEmpty
            ? emit(PopularTvHasData(data))
            : emit(PopularTvEmpty()),
      );
    });
  }
}
