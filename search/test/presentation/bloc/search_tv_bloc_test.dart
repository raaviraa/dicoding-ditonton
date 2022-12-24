import 'package:bloc_test/bloc_test.dart';
//import 'package:core/domain/entities/movie.dart';
import 'package:core/domain/entities/tv_entities.dart';
import 'package:core/utils/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

//import 'package:search/domain/usecases/search_movies.dart';
import 'package:search/domain/usecases/search_tv.dart';
//import 'package:search/presentation/bloc/movie/search_movie_bloc.dart';
import 'package:search/presentation/bloc/tv/search_tv_bloc.dart';

//import 'search_movie_bloc_test.mocks.dart';
import 'search_tv_bloc_test_mocks.dart';

@GenerateMocks([SearchTv])
void main() {
  late SearchTvBloc searchTvBloc;
  late MockSearchTv mockSearchTv;

  setUp(() {
    mockSearchTv = MockSearchTv();
    searchTvBloc = SearchTvBloc(mockSearchTv);
  });

  group('search tv', () {
    final testTv = Tv(
        backdropPath: '/suopoADq0k8YZr4dQXcU6pToj6s.jpg',
        genreIds: [10765, 18, 10759, 9648],
        id: 1399,
        originalName: 'Game of Thrones',
        overview:
            "Seven noble families fight for control of the mythical land of Westeros. Friction between the houses leads to full-scale war. All while a very ancient evil awakens in the farthest north. Amidst the war, a neglected military order of misfits, the Night's Watch, is all that stands between the realms of men and icy horrors beyond.",
        popularity: 369.594,
        posterPath: '/u3bZgnGQ9T01sWNhyveQz0wH0Hl.jpg',
        firstAirDate: '2011-04-17',
        name: 'Game of Thrones',
        voteAverage: 8.3,
        voteCount: 11504);

    final testTvList = <Tv>[testTv];
    const tTvQuery = "Game of Thrones";

    test('initial state should be empty', () {
      expect(searchTvBloc.state, SearchTvEmpty());

      blocTest<SearchTvBloc, SearchTvState>(
        'Should emit [Loading, HasData] when data is gotten successfully',
        build: () {
          when(mockSearchTv.execute(tTvQuery))
              .thenAnswer((_) async => Right(testTvList));
          return searchTvBloc;
        },
        act: (bloc) => bloc.add(const TvOnQueryChanged(tTvQuery)),
        wait: const Duration(milliseconds: 500),
        expect: () => [
          SearchTvLoading(),
          SearchTvHasData(testTvList),
        ],
        verify: (bloc) {
          verify(mockSearchTv.execute(tTvQuery));
          return const TvOnQueryChanged(tTvQuery).props;
        },
      );

      blocTest<SearchTvBloc, SearchTvState>(
        'Should emit [Loading, Error] when get search is unsuccessful',
        build: () {
          when(mockSearchTv.execute(tTvQuery))
              .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
          return searchTvBloc;
        },
        act: (bloc) => bloc.add(const TvOnQueryChanged(tTvQuery)),
        wait: const Duration(milliseconds: 500),
        expect: () => [
          SearchTvLoading(),
          const SearchTvError('Server Failure'),
        ],
        verify: (bloc) {
          verify(mockSearchTv.execute(tTvQuery));
        },
      );
    });
  });
}
