import 'package:bloc_test/bloc_test.dart';
import 'package:core/presentation/bloc/movie_bloc/movie_detail/detail_movie_bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:core/domain/entities/movie.dart';
import 'package:core/domain/usecases/get_movie_detail.dart';
import 'package:core/domain/usecases/get_movie_recommendations.dart';
import 'package:core/utils/failure.dart';
import 'package:core/domain/usecases/get_watchlist_status.dart';
import 'package:core/domain/usecases/remove_watchlist.dart';
import 'package:core/domain/usecases/save_watchlist.dart';
import 'package:core/utils/state_enum.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import '../../../../../dummy_data/dummy_objects.dart';
import 'detail_movie_bloc_test.mocks.dart';

void main() {
  late MockGetMovieDetail mockGetMovieDetail;
  late DetailMovieBloc detailMovieBloc;

  const testId = 1;

  test('the DetailMovieBloc initial state should be empty', () {
    expect(DetailMovieBloc, DetailMovieEmpty());
  });

  blocTest<DetailMovieBloc, DetailMovieState>(
      'should emit MovieDetailLoading state and then MovieDetailHasData state when data is successfully fetched.',
      build: () {
        when(mockGetMovieDetail.execute(testId))
            .thenAnswer((_) async => Right(testMovieDetail));
        return detailMovieBloc;
      },
      act: (bloc) => bloc.add(OnDetailMovieCalled(testId)),
      expect: () => <DetailMovieState>[
            DetailMovieLoading(),
            DetailMovieHasData(testMovieDetail),
          ],
      verify: (bloc) {
        verify(mockGetMovieDetail.execute(testId));
        return OnDetailMovieCalled(testId).props;
      });

  blocTest<DetailMovieBloc, DetailMovieState>(
    'should emit MovieDetailLoading state and MovieDetailError when bloc is failed to fetch data.',
    build: () {
      when(mockGetMovieDetail.execute(testId))
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      return detailMovieBloc;
    },
    act: (bloc) => bloc.add(OnDetailMovieCalled(testId)),
    expect: () => <DetailMovieState>[
      DetailMovieLoading(),
      DetailMovieError('Server Failure'),
    ],
    verify: (bloc) => DetailMovieLoading(),
  );

  setUp(() {
    mockGetMovieDetail = MockGetMovieDetail();
    detailMovieBloc = DetailMovieBloc(mockGetMovieDetail);
  });
}
