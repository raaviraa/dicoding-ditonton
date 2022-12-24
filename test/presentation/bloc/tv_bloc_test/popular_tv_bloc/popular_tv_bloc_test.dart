import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:core/domain/usecases/get_popular_tv.dart';
import 'package:core/presentation/bloc/tv_bloc/popular_tv/popular_tv_bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import '../../../../../dummy_data/dummy_objects_tv.dart';
import 'popular_tv_bloc_test.mocks.dart';

@GenerateMocks([GetPopularTv])
void main() {
  late MockGetPopularTv mockGetPopularTv;
  late PopularTvSeriesBloc popularTvSeriesBloc;

  setUp(() {
    mockGetPopularTv = MockGetPopularTv();
    popularTvSeriesBloc = PopularTvSeriesBloc(mockGetPopularTv);
  });

  test('the PopularTvseriesEmpty initial state should be empty ', () {
    expect(popularTvSeriesBloc.state, PopularTvEmpty());
  });

  blocTest<PopularTvSeriesBloc, PopularTvState>(
    'should emits PopularTvseriesLoading state and then PopularTvseriesHasData state when data is successfully fetched..',
    build: () {
      when(mockGetPopularTv.execute())
          .thenAnswer((_) async => Right(testTvList));
      return popularTvSeriesBloc;
    },
    act: (bloc) => bloc.add(OnPopularTvCalled()),
    expect: () => <PopularTvState>[
      PopularTvLoading(),
      PopularTvHasData(testTvList),
    ],
    verify: (bloc) => verify(mockGetPopularTv.execute()),
  );

  blocTest<PopularTvSeriesBloc, PopularTvState>(
    'should emits PopularTvseriesLoading state and then PopularTvseriesError state when data is failed fetched..',
    build: () {
      when(mockGetPopularTv.execute())
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      return popularTvSeriesBloc;
    },
    act: (bloc) => bloc.add(OnPopularTvCalled()),
    expect: () => <PopularTvState>[
      PopularTvLoading(),
      PopularTvError('Server Failure'),
    ],
    verify: (bloc) => PopularTvLoading(),
  );

  blocTest<PopularTvSeriesBloc, PopularTvState>(
    'should emits PopularTvseriesLoading state and then PopularTvseriesEmpty state when data is retrieved empty..',
    build: () {
      when(mockGetPopularTv.execute()).thenAnswer((_) async => const Right([]));
      return popularTvSeriesBloc;
    },
    act: (bloc) => bloc.add(OnPopularTvCalled()),
    expect: () => <PopularTvState>[
      PopularTvLoading(),
      PopularTvEmpty(),
    ],
  );
}
