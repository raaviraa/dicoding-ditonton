import 'package:core/domain/usecases/get_watchlist_tv.dart';
import 'package:core/domain/usecases/get_watchlits_status_tv.dart';
import 'package:core/domain/usecases/remove_watchlist_tv.dart';
import 'package:core/domain/usecases/save_watchlist_tv.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../domain/entities/tv_detail_entities.dart';
import '../../../../domain/entities/tv_entities.dart';

part 'watchlist_tv_event.dart';
part 'watchlist_tv_state.dart';

class WatchlistTvBloc extends Bloc<WatchlistTvEvent, WatchlistTvState> {
  final GetWatchlistTv _getWatchlistTv;
  final GetWatchListStatusTv _getWatchListStatusTv;
  final RemoveWatchlistTv _removeWatchlistTv;
  final SaveWatchlistTv _saveWatchlistTv;
  WatchlistTvBloc(
    this._getWatchlistTv,
    this._getWatchListStatusTv,
    this._removeWatchlistTv,
    this._saveWatchlistTv,
  ) : super(WatchlistTvEmpty()) {
    on<OnWatchlistTvCalled>((event, emit) async {
      emit(WatchlistTvLoading());
      final result = await _getWatchlistTv.execute();
      result.fold(
        (failure) => emit(WatchlistTvError(failure.message)),
        (data) => data.isNotEmpty
            ? emit(WatchlistTvHasData(data))
            : emit(WatchlistTvEmpty()),
      );
    });

    on<FetchWatchlistTvStatus>(((event, emit) async {
      final id = event.id;

      final result = await _getWatchListStatusTv.execute(id);

      emit(WatchlistTvIsAdded(result));
    }));

    on<AddTvToWatchlist>(
      ((event, emit) async {
        final movie = event.tvseries;

        final result = await _saveWatchlistTv.execute(movie);

        result.fold(
          (failure) => emit(WatchlistTvError(failure.message)),
          (message) => emit(
            WatchlistTvMessage(message),
          ),
        );
      }),
    );

    on<RemoveTvFromWatchlist>(
      ((event, emit) async {
        final tvseries = event.tvseries;

        final result = await _removeWatchlistTv.execute(tvseries);

        result.fold(
          (failure) => emit(WatchlistTvError(failure.message)),
          (message) => emit(
            WatchlistTvMessage(message),
          ),
        );
      }),
    );
  }
}
