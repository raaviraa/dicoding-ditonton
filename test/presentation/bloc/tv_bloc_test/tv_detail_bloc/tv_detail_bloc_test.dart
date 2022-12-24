import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:core/domain/usecases/get_tv_detail.dart';
import 'package:core/presentation/bloc/tv_bloc/tv_detail/tv_detail_bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import '../../../../../dummy_data/dummy_objects_tv.dart';
import 'tv_detail_bloc_test.mocks.dart';

@GenerateMocks([GetTvDetail])
void main() {
  late MockGetTvDetail mockGetTvDetail;
  late TvDetailBloc tvDetailBloc;

  const testId = 1;

  setUp(() {
    mockGetTvDetail = MockGetTvDetail();
    tvDetailBloc = TvDetailBloc(mockGetTvDetail);
  });
  test('the TvDetailBloc initial state should be empty', () {
    expect(tvDetailBloc.state, TvDetailEmpty());
  });

  blocTest<TvDetailBloc, TvDetailState>(
      'should emits TvDetailLoading state and then TvDetailHasData state when data is successfully fetched.',
      build: () {
        when(mockGetTvDetail.execute(testId))
            .thenAnswer((_) async => Right(testTvDetail));
        return tvDetailBloc;
      },
      act: (bloc) => bloc.add(OnTvDetailCalled(testId)),
      expect: () => <TvDetailState>[
            TvDetailLoading(),
            TvDetailHasData(testTvDetail),
          ],
      verify: (bloc) {
        verify(mockGetTvDetail.execute(testId));
        return OnTvDetailCalled(testId).props;
      });

  blocTest<TvDetailBloc, TvDetailState>(
    'should emits TvDetailLoading state and TvDetailError when data is failed to fetch.',
    build: () {
      when(mockGetTvDetail.execute(testId))
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      return tvDetailBloc;
    },
    act: (bloc) => bloc.add(OnTvDetailCalled(testId)),
    expect: () => <TvDetailState>[
      TvDetailLoading(),
      TvDetailError('Server Failure'),
    ],
    verify: (bloc) => TvDetailLoading(),
  );
}
