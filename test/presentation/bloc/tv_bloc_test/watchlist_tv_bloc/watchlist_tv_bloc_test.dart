import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:core/domain/usecases/get_watchlist_tv.dart';
import 'package:core/domain/usecases/get_watchlits_status_tv.dart';
import 'package:core/domain/usecases/remove_watchlist_tv.dart';
import 'package:core/domain/usecases/save_watchlist_tv.dart';
import 'package:core/presentation/bloc/tv_bloc/watchlist_tv/watchlist_tv_bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../../../dummy_data/dummy_objects_tv.dart';
import 'watchlist_tv_bloc_test.mocks.dart';

//import '../../../provider/watchlist_tv_notifier_test.mocks.dart';

@GenerateMocks(
    [GetWatchListStatusTv, GetWatchlistTv, RemoveWatchlistTv, SaveWatchlistTv])
void main() {
  late MockGetWatchlistTv mockGetWatchlistTv;
  late MockGetWatchListStatusTv mockGetWatchListStatusTv;
  late MockRemoveWatchlistTv mockRemoveWatchlistTv;
  late MockSaveWatchlistTv mockSaveWatchlistTv;
  late WatchlistTvBloc watchlistTvBloc;

  setUp(() {
    mockGetWatchlistTv = MockGetWatchlistTv();
    mockGetWatchListStatusTv = MockGetWatchListStatusTv();
    mockRemoveWatchlistTv = MockRemoveWatchlistTv();
    mockSaveWatchlistTv = MockSaveWatchlistTv();
    watchlistTvBloc = WatchlistTvBloc(
      mockGetWatchlistTv,
      mockGetWatchListStatusTv,
      mockRemoveWatchlistTv,
      mockSaveWatchlistTv,
    );
  });

  test('the WatchlisttvEmpty initial state should be empty ', () {
    expect(watchlistTvBloc.state, WatchlistTvEmpty());
  });

  group('get watchlist tv test cases', () {
    blocTest<WatchlistTvBloc, WatchlistTvState>(
      'should emits WatchlistTvLoading state and then WatchlistTvHasData state when data is successfully fetched..',
      build: () {
        when(mockGetWatchlistTv.execute())
            .thenAnswer((_) async => Right([testWatchlistTv]));
        return watchlistTvBloc;
      },
      act: (bloc) => bloc.add(OnWatchlistTvCalled()),
      expect: () => [
        WatchlistTvLoading(),
        WatchlistTvHasData([testWatchlistTv]),
      ],
      verify: (bloc) {
        verify(mockGetWatchlistTv.execute());
        return OnWatchlistTvCalled().props;
      },
    );

    blocTest<WatchlistTvBloc, WatchlistTvState>(
      'should emits WatchlisttvLoading state and then WatchlistTvError state when data is failed fetched..',
      build: () {
        when(mockGetWatchlistTv.execute())
            .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
        return watchlistTvBloc;
      },
      act: (bloc) => bloc.add(OnWatchlistTvCalled()),
      expect: () => <WatchlistTvState>[
        WatchlistTvLoading(),
        WatchlistTvError('Server Failure'),
      ],
      verify: (bloc) => WatchlistTvLoading(),
    );

    blocTest<WatchlistTvBloc, WatchlistTvState>(
      'should emits WatchlistTvLoading state and then WatchlistTvEmpty state when data is retrieved empty..',
      build: () {
        when(mockGetWatchlistTv.execute())
            .thenAnswer((_) async => const Right([]));
        return watchlistTvBloc;
      },
      act: (bloc) => bloc.add(OnWatchlistTvCalled()),
      expect: () => <WatchlistTvState>[
        WatchlistTvLoading(),
        WatchlistTvEmpty(),
      ],
    );
  });

  group('get watchlist status tv test cases', () {
    blocTest<WatchlistTvBloc, WatchlistTvState>(
      'should be return true when the watchlist is also true',
      build: () {
        when(mockGetWatchListStatusTv.execute(testTvDetail.id))
            .thenAnswer((_) async => true);
        return watchlistTvBloc;
      },
      act: (bloc) => bloc.add(FetchWatchlistTvStatus(testTvDetail.id)),
      expect: () => [WatchlistTvIsAdded(true)],
      verify: (bloc) {
        verify(mockGetWatchListStatusTv.execute(testTvDetail.id));
        return FetchWatchlistTvStatus(testTvDetail.id).props;
      },
    );

    blocTest<WatchlistTvBloc, WatchlistTvState>(
        'should be return false when the watchlist is also false',
        build: () {
          when(mockGetWatchListStatusTv.execute(testTvDetail.id))
              .thenAnswer((_) async => false);
          return watchlistTvBloc;
        },
        act: (bloc) => bloc.add(FetchWatchlistTvStatus(testTvDetail.id)),
        expect: () => <WatchlistTvState>[
              WatchlistTvIsAdded(false),
            ],
        verify: (bloc) {
          verify(mockGetWatchListStatusTv.execute(testTvDetail.id));
          return FetchWatchlistTvStatus(testTvDetail.id).props;
        });
  });

  group('add watchlist test cases', () {
    blocTest<WatchlistTvBloc, WatchlistTvState>(
      'should update watchlist status when adding tv to watchlist is successfully',
      build: () {
        when(mockSaveWatchlistTv.execute(testTvDetail))
            .thenAnswer((_) async => const Right('Added to Watchlist'));
        return watchlistTvBloc;
      },
      act: (bloc) => bloc.add(AddTvToWatchlist(testTvDetail)),
      expect: () => [
        WatchlistTvMessage('Added to Watchlist'),
      ],
      verify: (bloc) {
        verify(mockSaveWatchlistTv.execute(testTvDetail));
        return AddTvToWatchlist(testTvDetail).props;
      },
    );

    blocTest<WatchlistTvBloc, WatchlistTvState>(
      'should throw failure message status when adding tv to watchlist is failed',
      build: () {
        when(mockSaveWatchlistTv.execute(testTvDetail)).thenAnswer(
            (_) async => Left(DatabaseFailure('can\'t add data to watchlist')));
        return watchlistTvBloc;
      },
      act: (bloc) => bloc.add(AddTvToWatchlist(testTvDetail)),
      expect: () => [
        WatchlistTvError('can\'t add data to watchlist'),
      ],
      verify: (bloc) {
        verify(mockSaveWatchlistTv.execute(testTvDetail));
        return AddTvToWatchlist(testTvDetail).props;
      },
    );
  });

  group('remove watchlist test cases', () {
    blocTest<WatchlistTvBloc, WatchlistTvState>(
      'should update watchlist status when removing tv from watchlist is successfully',
      build: () {
        when(mockRemoveWatchlistTv.execute(testTvDetail))
            .thenAnswer((_) async => const Right('Removed from Watchlist'));
        return watchlistTvBloc;
      },
      act: (bloc) => bloc.add(RemoveTvFromWatchlist(testTvDetail)),
      expect: () => [
        WatchlistTvMessage('Removed from Watchlist'),
      ],
      verify: (bloc) {
        verify(mockRemoveWatchlistTv.execute(testTvDetail));
        return RemoveTvFromWatchlist(testTvDetail).props;
      },
    );

    blocTest<WatchlistTvBloc, WatchlistTvState>(
      'should throw failure message status when removie tv from watchlist is failed',
      build: () {
        when(mockRemoveWatchlistTv.execute(testTvDetail)).thenAnswer(
            (_) async => Left(DatabaseFailure('can\'t add data to watchlist')));
        return watchlistTvBloc;
      },
      act: (bloc) => bloc.add(RemoveTvFromWatchlist(testTvDetail)),
      expect: () => [
        WatchlistTvError('can\'t add data to watchlist'),
      ],
      verify: (bloc) {
        verify(mockRemoveWatchlistTv.execute(testTvDetail));
        return RemoveTvFromWatchlist(testTvDetail).props;
      },
    );
  });
}
