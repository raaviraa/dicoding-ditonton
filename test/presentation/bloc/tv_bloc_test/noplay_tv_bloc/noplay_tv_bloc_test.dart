import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:core/domain/usecases/get_now_playing_tv.dart';
import 'package:core/presentation/bloc/tv_bloc/now_playing_tv/noplay_tv_bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../../../dummy_data/dummy_objects_tv.dart';
import 'noplay_tv_bloc_test.mocks.dart';

@GenerateMocks([GetNowPlayingTv])
void main() {
  late MockGetNowPlayingTv mockGetNowPlayingTv;
  late NowPlayingTvBloc nowPlayingTvBloc;

  setUp(() {
    mockGetNowPlayingTv = MockGetNowPlayingTv();
    nowPlayingTvBloc = NowPlayingTvBloc(mockGetNowPlayingTv);
  });

  test('the OnTheAirTvseriesBloc initial state should be empty ', () {
    expect(nowPlayingTvBloc.state, NowPlayingTvEmpty());
  });

  blocTest<NowPlayingTvBloc, NowPlayingTvState>(
      'should emits OnTheAirTvseriesLoading state and then OnTheAirTvseriesHasData state when data is successfully fetched..',
      build: () {
        when(mockGetNowPlayingTv.execute())
            .thenAnswer((_) async => Right(testTvList));
        return nowPlayingTvBloc;
      },
      act: (bloc) => bloc.add(NowPlayingTv()),
      expect: () => <NowPlayingTvState>[
            NowPlayingTvLoading(),
            NowPlayingTvHasData(testTvList),
          ],
      verify: (bloc) {
        verify(mockGetNowPlayingTv.execute());
        return NowPlayingTv().props;
      });

  blocTest<NowPlayingTvBloc, NowPlayingTvState>(
    'should emits OnTheAirTvseriesLoading state and then OnTheAirTvseriesError state when data is failed fetched..',
    build: () {
      when(mockGetNowPlayingTv.execute())
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      return nowPlayingTvBloc;
    },
    act: (bloc) => bloc.add(NowPlayingTv()),
    expect: () => <NowPlayingTvState>[
      NowPlayingTvLoading(),
      NowPlayingTvError('Server Failure'),
    ],
    verify: (bloc) => NowPlayingTvLoading(),
  );

  blocTest<NowPlayingTvBloc, NowPlayingTvState>(
    'should emits OnTheAirTvseriesLoading state and then OnTheAirTvseriesEmpty state when data is retrieved empty..',
    build: () {
      when(mockGetNowPlayingTv.execute())
          .thenAnswer((_) async => const Right([]));
      return nowPlayingTvBloc;
    },
    act: (bloc) => bloc.add(NowPlayingTv()),
    expect: () => <NowPlayingTvState>[
      NowPlayingTvLoading(),
      NowPlayingTvEmpty(),
    ],
  );
}
