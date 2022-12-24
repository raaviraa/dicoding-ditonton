import 'package:core/domain/entities/tv_entities.dart';
import 'package:core/domain/usecases/get_now_playing_tv.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'noplay_tv_event.dart';
part 'noplay_tv_state.dart';

class NowPlayingTvBloc extends Bloc<NowPlayingTvEvent, NowPlayingTvState> {
  final GetNowPlayingTv _getNowPlaying;
  NowPlayingTvBloc(this._getNowPlaying) : super(NowPlayingTvEmpty()) {
    on<NowPlayingTv>((event, emit) async {
      emit(NowPlayingTvLoading());

      final result = await _getNowPlaying.execute();

      result.fold((failure) {
        emit(NowPlayingTvError(failure.message));
      }, (data) {
        data.isNotEmpty
            ? emit(NowPlayingTvHasData(data))
            : emit(NowPlayingTvEmpty());
      });
    });
  }
}
