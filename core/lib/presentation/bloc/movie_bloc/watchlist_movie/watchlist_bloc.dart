import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../domain/entities/movie.dart';
import '../../../../domain/entities/movie_detail.dart';
import '../../../../domain/usecases/get_watchlist_movies.dart';
import '../../../../domain/usecases/get_watchlist_status.dart';
import '../../../../domain/usecases/remove_watchlist.dart';
import '../../../../domain/usecases/save_watchlist.dart';
part 'watchlist_event.dart';
part 'watchlist_state.dart';

class WatchlistBloc extends Bloc<WatchlistEvent, WatchlistState> {
  final GetWatchlistMovies _getWatchlistMovies;
  final GetWatchListStatus _getWatchListStatusMovies;
  final RemoveWatchlist _removeWatchlistMovies;
  final SaveWatchlist _saveWatchlistMovies;
  WatchlistBloc(
    this._getWatchlistMovies,
    this._getWatchListStatusMovies,
    this._removeWatchlistMovies,
    this._saveWatchlistMovies,
  ) : super(WatchlistEmpty()) {
    on<OnWatchlistCalled>((event, emit) async {
      emit(WatchlistLoading());
      final result = await _getWatchlistMovies.execute();

      result.fold(
          (failure) => emit(WatchlistError(failure.message)),
          (data) => data.isNotEmpty
              ? emit(WatchlistHasData(data))
              : emit(
                  WatchlistEmpty(),
                ));
    });

    on<FetchWatchlistMovieStatus>(((event, emit) async {
      final id = event.id;

      final result = await _getWatchListStatusMovies.execute(id);

      emit(WatchlistMoviesIsAdded(result));
    }));

    on<AddMovieToWatchlist>(
      ((event, emit) async {
        final movie = event.movieDetail;

        final result = await _saveWatchlistMovies.execute(movie);

        result.fold(
          (failure) => emit(WatchlistError(failure.message)),
          (message) => emit(
            WatchlistMessage(message),
          ),
        );
      }),
    );

    on<RemoveMovieFromWatchlist>(
      ((event, emit) async {
        final movie = event.movieDetail;

        final result = await _removeWatchlistMovies.execute(movie);

        result.fold(
          (failure) => emit(WatchlistError(failure.message)),
          (message) => emit(
            WatchlistMessage(message),
          ),
        );
      }),
    );
  }
}
