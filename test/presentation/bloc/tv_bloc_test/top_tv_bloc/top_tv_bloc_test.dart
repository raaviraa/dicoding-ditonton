import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:core/domain/usecases/get_top_rated_tv.dart';
import 'package:core/presentation/bloc/tv_bloc/top_rated_tv/top_tv_bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import '../../../../../dummy_data/dummy_objects_tv.dart';
import 'top_tv_bloc_test.mocks.dart';

@GenerateMocks([GetTopRatedTv])
void main() {
  late MockGetTopRatedTv mockGetTopRatedTv;
  late TopRatedTvBloc topRatedTvBloc;

  setUp(() {
    mockGetTopRatedTv = MockGetTopRatedTv();
    topRatedTvBloc = TopRatedTvBloc(mockGetTopRatedTv);
  });

  test('the TopRatedTvseriesEmpty initial state should be empty ', () {
    expect(topRatedTvBloc.state, TopRatedTvEmpty());
  });

  blocTest<TopRatedTvBloc, TopRatedTvState>(
    'should emits PopularTvseriesLoading state and then PopularTvseriesHasData state when data is successfully fetched..',
    build: () {
      when(mockGetTopRatedTv.execute())
          .thenAnswer((_) async => Right(testTvList));
      return topRatedTvBloc;
    },
    act: (bloc) => bloc.add(OnTopRatedTvCalled()),
    expect: () => <TopRatedTvState>[
      TopRatedTvLoading(),
      TopRatedTvHasData(testTvList),
    ],
    verify: (bloc) => verify(mockGetTopRatedTv.execute()),
  );

  blocTest<TopRatedTvBloc, TopRatedTvState>(
    'should emits TopRatedTvseriesLoading state and then TopRatedTvseriesError state when data is failed fetched..',
    build: () {
      when(mockGetTopRatedTv.execute())
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      return topRatedTvBloc;
    },
    act: (bloc) => bloc.add(OnTopRatedTvCalled()),
    expect: () => <TopRatedTvState>[
      TopRatedTvLoading(),
      TopRatedTvError('Server Failure'),
    ],
    verify: (bloc) => TopRatedTvLoading(),
  );

  blocTest<TopRatedTvBloc, TopRatedTvState>(
    'should emits TopRatedTvseriesLoading state and then TopRatedTvseriesEmpty state when data is retrieved empty..',
    build: () {
      when(mockGetTopRatedTv.execute())
          .thenAnswer((_) async => const Right([]));
      return topRatedTvBloc;
    },
    act: (bloc) => bloc.add(OnTopRatedTvCalled()),
    expect: () => <TopRatedTvState>[
      TopRatedTvLoading(),
      TopRatedTvEmpty(),
    ],
  );
}
