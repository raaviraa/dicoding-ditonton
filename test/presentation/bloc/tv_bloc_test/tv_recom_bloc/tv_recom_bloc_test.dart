import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:core/domain/usecases/get_tv_recomendation.dart';
import 'package:core/presentation/bloc/tv_bloc/tv_reccomendation/tv_recom_bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import '../../../../../dummy_data/dummy_objects_tv.dart';
import 'tv_recom_bloc_test.mocks.dart';

@GenerateMocks([GetTvRecommendations])
void main() {
  late MockGetTvRecommendations mockGetTvRecommendations;
  late TvRecomBloc tvRecomBloc;

  const testId = 1;

  setUp(() {
    mockGetTvRecommendations = MockGetTvRecommendations();
    tvRecomBloc = TvRecomBloc(mockGetTvRecommendations);
  });

  test('the TvRecomEmpty initial state should be empty ', () {
    expect(tvRecomBloc.state, TvRecomEmpty());
  });

  blocTest<TvRecomBloc, TvRecomState>(
    'should emits PopularTvLoading state and then PopularTvHasData state when data is successfully fetched..',
    build: () {
      when(mockGetTvRecommendations.execute(testId))
          .thenAnswer((_) async => Right(testTvList));
      return tvRecomBloc;
    },
    act: (bloc) => bloc.add(OnTvRecomCalled(testId)),
    expect: () => <TvRecomState>[
      TvRecomLoading(),
      TvRecomHasData(testTvList),
    ],
    verify: (bloc) => verify(mockGetTvRecommendations.execute(testId)),
  );

  blocTest<TvRecomBloc, TvRecomState>(
    'should emits TvRecomLoading state and then TvRecomError state when data is failed fetched..',
    build: () {
      when(mockGetTvRecommendations.execute(testId))
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      return tvRecomBloc;
    },
    act: (bloc) => bloc.add(OnTvRecomCalled(testId)),
    expect: () => <TvRecomState>[
      TvRecomLoading(),
      TvRecomError('Server Failure'),
    ],
    verify: (bloc) => TvRecomLoading(),
  );

  blocTest<TvRecomBloc, TvRecomState>(
    'should emits TvRecomLoading state and then TvRecomEmpty state when data is retrieved empty..',
    build: () {
      when(mockGetTvRecommendations.execute(testId))
          .thenAnswer((_) async => const Right([]));
      return tvRecomBloc;
    },
    act: (bloc) => bloc.add(OnTvRecomCalled(testId)),
    expect: () => <TvRecomState>[
      TvRecomLoading(),
      TvRecomEmpty(),
    ],
  );
}
