import 'package:core/domain/entities/movie.dart';
import 'package:core/domain/usecases/get_movie_recommendations.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'movie_recomd_event.dart';
part 'movie_recomd_state.dart';

class MovieRecomdBloc extends Bloc<MovieRecomdEvent, MovieRecomdState> {
  final GetMovieRecommendations _getMovieRecommendations;
  MovieRecomdBloc(this._getMovieRecommendations) : super(MovieRecomdEmpty()) {
    on<OnMovieRecomdCalled>((event, emit) async {
      final id = event.id;

      emit(MovieRecomdLoading());

      final result = await _getMovieRecommendations.execute(id);

      result.fold(
        (failure) => emit(MovieRecomdError(failure.message)),
        (data) => data.isNotEmpty
            ? emit(MovieRecomdHasData(data))
            : emit(MovieRecomdEmpty()),
      );
    });
  }
}
