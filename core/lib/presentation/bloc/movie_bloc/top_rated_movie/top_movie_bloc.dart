import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../domain/entities/movie.dart';
import '../../../../domain/usecases/get_top_rated_movies.dart';

part 'top_movie_event.dart';
part 'top_movie_state.dart';

class TopRatedMoviesBloc extends Bloc<TopMoviesEvent, TopMoviesState> {
  final GetTopRatedMovies _getTopRatedMovies;
  TopRatedMoviesBloc(this._getTopRatedMovies) : super(TopMoviesEmpty()) {
    on<OnTopMoviesCalled>((event, emit) async {
      emit(TopMoviesLoading());
      final result = await _getTopRatedMovies.execute();

      result.fold(
        (failure) => emit(TopMoviesError(failure.message)),
        (data) => data.isNotEmpty
            ? emit(TopMoviesHasData(data))
            : emit(
                TopMoviesEmpty(),
              ),
      );
    });
  }
}
