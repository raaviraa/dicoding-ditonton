import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:core/domain/usecases/get_watchlist_movies.dart';
import 'package:core/domain/usecases/get_watchlist_status.dart';
import 'package:core/domain/usecases/remove_watchlist.dart';
import 'package:core/domain/usecases/save_watchlist.dart';
import 'package:core/presentation/bloc/movie_bloc/watchlist_movie/watchlist_bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../../../dummy_data/dummy_objects.dart';
import 'watchlist_movie_bloc_test.mocks.dart';

@GenerateMocks(
    [GetWatchListStatus, GetWatchlistMovies, RemoveWatchlist, SaveWatchlist])
void main() {
  late MockGetWatchlistMovies mockGetWatchlistMovies;
  late MockGetWatchListStatus mockGetWatchListStatusMovies;
  late MockRemoveWatchlist mockRemoveWatchlistMovies;
  late MockSaveWatchlist mockSaveWatchlistMovies;
  late WatchlistBloc watchlistBloc;

  test('the WatchlistMoviesEmpty initial state should be empty ', () {
    expect(watchlistBloc.state, WatchlistEmpty());
  });

  setUp(() {
    mockGetWatchlistMovies = MockGetWatchlistMovies();
    mockGetWatchListStatusMovies = MockGetWatchListStatus();
    mockRemoveWatchlistMovies = MockRemoveWatchlist();
    mockSaveWatchlistMovies = MockSaveWatchlist();
    watchlistBloc = WatchlistBloc(
      mockGetWatchlistMovies,
      mockGetWatchListStatusMovies,
      mockRemoveWatchlistMovies,
      mockSaveWatchlistMovies,
    );
  });

  group('get watchlist movies test cases', () {
    blocTest<WatchlistBloc, WatchlistState>(
      'should emits WatchlistMovieLoading state and then WatchlistMovieHasData state when data is successfully fetched..',
      build: () {
        when(mockGetWatchlistMovies.execute())
            .thenAnswer((_) async => Right([testWatchlistMovie]));
        return watchlistBloc;
      },
      act: (bloc) => bloc.add(OnWatchlistCalled()),
      expect: () => [
        WatchlistLoading(),
        WatchlistHasData([testWatchlistMovie]),
      ],
      verify: (bloc) {
        verify(mockGetWatchlistMovies.execute());
        return OnWatchlistCalled().props;
      },
    );

    blocTest<WatchlistBloc, WatchlistState>(
      'should emits WatchlistMoviesLoading state and then WatchlistMoviesError state when data is failed fetched..',
      build: () {
        when(mockGetWatchlistMovies.execute())
            .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
        return watchlistBloc;
      },
      act: (bloc) => bloc.add(OnWatchlistCalled()),
      expect: () => <WatchlistState>[
        WatchlistLoading(),
        WatchlistError('Server Failure'),
      ],
      verify: (bloc) => WatchlistLoading(),
    );

    blocTest<WatchlistBloc, WatchlistState>(
      'should emits WatchlistMoviesLoading state and then WatchlistMoviesEmpty state when data is retrieved empty..',
      build: () {
        when(mockGetWatchlistMovies.execute())
            .thenAnswer((_) async => const Right([]));
        return watchlistBloc;
      },
      act: (bloc) => bloc.add(OnWatchlistCalled()),
      expect: () => <WatchlistState>[
        WatchlistLoading(),
        WatchlistEmpty(),
      ],
    );
  });

  group('get watchlist status movies test cases', () {
    blocTest<WatchlistBloc, WatchlistState>(
      'should be return true when the watchlist is also true',
      build: () {
        when(mockGetWatchListStatusMovies.execute(testMovieDetail.id))
            .thenAnswer((_) async => true);
        return watchlistBloc;
      },
      act: (bloc) => bloc.add(FetchWatchlistMovieStatus(testMovieDetail.id)),
      expect: () => [WatchlistMoviesIsAdded(true)],
      verify: (bloc) {
        verify(mockGetWatchListStatusMovies.execute(testMovieDetail.id));
        return FetchWatchlistMovieStatus(testMovieDetail.id).props;
      },
    );

    blocTest<WatchlistBloc, WatchlistState>(
        'should be return false when the watchlist is also false',
        build: () {
          when(mockGetWatchListStatusMovies.execute(testMovieDetail.id))
              .thenAnswer((_) async => false);
          return watchlistBloc;
        },
        act: (bloc) => bloc.add(FetchWatchlistMovieStatus(testMovieDetail.id)),
        expect: () => <WatchlistState>[
              WatchlistMoviesIsAdded(false),
            ],
        verify: (bloc) {
          verify(mockGetWatchListStatusMovies.execute(testMovieDetail.id));
          return FetchWatchlistMovieStatus(testMovieDetail.id).props;
        });
  });

  group('add watchlist test cases', () {
    blocTest<WatchlistBloc, WatchlistState>(
      'should update watchlist status when adding movie to watchlist is successfully',
      build: () {
        when(mockSaveWatchlistMovies.execute(testMovieDetail))
            .thenAnswer((_) async => const Right('Added to Watchlist'));
        return watchlistBloc;
      },
      act: (bloc) => bloc.add(AddMovieToWatchlist(testMovieDetail)),
      expect: () => [
        WatchlistMessage('Added to Watchlist'),
      ],
      verify: (bloc) {
        verify(mockSaveWatchlistMovies.execute(testMovieDetail));
        return AddMovieToWatchlist(testMovieDetail).props;
      },
    );

    blocTest<WatchlistBloc, WatchlistState>(
      'should throw failure message status when adding movie to watchlist is failed',
      build: () {
        when(mockSaveWatchlistMovies.execute(testMovieDetail)).thenAnswer(
            (_) async => Left(DatabaseFailure('can\'t add data to watchlist')));
        return watchlistBloc;
      },
      act: (bloc) => bloc.add(AddMovieToWatchlist(testMovieDetail)),
      expect: () => [
        WatchlistError('can\'t add data to watchlist'),
      ],
      verify: (bloc) {
        verify(mockSaveWatchlistMovies.execute(testMovieDetail));
        return AddMovieToWatchlist(testMovieDetail).props;
      },
    );
  });

  group('remove watchlist test cases', () {
    blocTest<WatchlistBloc, WatchlistState>(
      'should update watchlist status when removing movie from watchlist is successfully',
      build: () {
        when(mockRemoveWatchlistMovies.execute(testMovieDetail))
            .thenAnswer((_) async => const Right('Removed from Watchlist'));
        return watchlistBloc;
      },
      act: (bloc) => bloc.add(RemoveMovieFromWatchlist(testMovieDetail)),
      expect: () => [
        WatchlistMessage('Removed from Watchlist'),
      ],
      verify: (bloc) {
        verify(mockRemoveWatchlistMovies.execute(testMovieDetail));
        return RemoveMovieFromWatchlist(testMovieDetail).props;
      },
    );

    blocTest<WatchlistBloc, WatchlistState>(
      'should throw failure message status when removie movie from watchlist is failed',
      build: () {
        when(mockRemoveWatchlistMovies.execute(testMovieDetail)).thenAnswer(
            (_) async => Left(DatabaseFailure('can\'t add data to watchlist')));
        return watchlistBloc;
      },
      act: (bloc) => bloc.add(RemoveMovieFromWatchlist(testMovieDetail)),
      expect: () => [
        WatchlistError('can\'t add data to watchlist'),
      ],
      verify: (bloc) {
        verify(mockRemoveWatchlistMovies.execute(testMovieDetail));
        return RemoveMovieFromWatchlist(testMovieDetail).props;
      },
    );
  });
}
