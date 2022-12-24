import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../domain/entities/tv_entities.dart';
import '../../../../domain/usecases/get_tv_recomendation.dart';

part 'tv_recom_event.dart';
part 'tv_recom_state.dart';

class TvRecomBloc
    extends Bloc<TvRecomEvent, TvRecomState> {
  final GetTvRecommendations _getTvRecommendation;
  TvRecomBloc(this._getTvRecommendation)
      : super(TvRecomEmpty()) {
    on<OnTvRecomCalled>((event, emit) async {
      final id = event.id;

      emit(TvRecomLoading());

      final result = await _getTvRecommendation.execute(id);

      result.fold(
        (failure) => emit(TvRecomError(failure.message)),
        (data) => data.isNotEmpty
            ? emit(TvRecomHasData(data))
            : emit(TvRecomEmpty()),
      );
    });
  }
}
