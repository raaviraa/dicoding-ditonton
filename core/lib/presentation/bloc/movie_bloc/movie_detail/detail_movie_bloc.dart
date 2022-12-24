import 'package:core/domain/entities/movie.dart';
import 'package:core/domain/entities/movie_detail.dart';
//import 'package:core/domain/usecases/get_movie_detail.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';
import 'package:equatable/equatable.dart';

import '../../../../domain/usecases/get_movie_detail.dart';
part 'detail_movie_event.dart';
part 'detail_movie_state.dart';
//import 'package:flutter_bloc/flutter_bloc.dart';

class DetailMovieBloc extends Bloc<DetailMovieEvent, DetailMovieState> {
  final GetMovieDetail _getMovieDetail;

  DetailMovieBloc(this._getMovieDetail) : super(DetailMovieEmpty()) {
    on<OnDetailMovieCalled>(
      (event, emit) async {
        final id = event.id;

        emit(DetailMovieLoading());
        final result = await _getMovieDetail.execute(id);

        result.fold(
          (failure) {
            emit(DetailMovieError(failure.message));
          },
          (data) {
            emit(DetailMovieHasData(data));
          },
        );
      },
      // transformer: debounce(
      //   const Duration(milliseconds: 500),
      // ),
    );
  }
}

// EventTransformer<T> debounce<T>(Duration duration) {
//   return (events, mapper) => events.debounceTime(duration).flatMap(mapper);
// }
