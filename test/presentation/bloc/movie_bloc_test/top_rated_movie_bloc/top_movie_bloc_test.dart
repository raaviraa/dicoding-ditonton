import 'package:bloc_test/bloc_test.dart';
import 'package:core/domain/usecases/get_top_rated_movies.dart';
import 'package:core/presentation/bloc/movie_bloc/top_rated_movie/top_movie_bloc.dart';
import 'package:core/utils/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../../../dummy_data/dummy_objects.dart';
import 'top_movie_bloc_test.mocks.dart';

@GenerateMocks([GetTopRatedMovies])
void main() {
  late MockGetTopRatedMovies mockGetTopRatedMovies;
  late TopRatedMoviesBloc topRatedMoviesBloc;

  setUp(() {
    mockGetTopRatedMovies = MockGetTopRatedMovies();
    topRatedMoviesBloc = TopRatedMoviesBloc(mockGetTopRatedMovies);
  });

  test('the TopRatedMoviesEmpty initial state should be empty ', () {
    expect(topRatedMoviesBloc.state, TopMoviesEmpty());
  });

  blocTest<TopRatedMoviesBloc, TopMoviesState>(
    'should emits PopularMovieLoading state and then PopularMovieHasData state when data is successfully fetched..',
    build: () {
      when(mockGetTopRatedMovies.execute())
          .thenAnswer((_) async => Right(testMovieList));
      return topRatedMoviesBloc;
    },
    act: (bloc) => bloc.add(OnTopMoviesCalled()),
    expect: () => <TopMoviesState>[
      TopMoviesLoading(),
      TopMoviesHasData(testMovieList),
    ],
    verify: (bloc) => verify(mockGetTopRatedMovies.execute()),
  );

  blocTest<TopRatedMoviesBloc, TopMoviesState>(
    'should emits TopRatedMoviesLoading state and then TopRatedMoviesError state when data is failed fetched..',
    build: () {
      when(mockGetTopRatedMovies.execute())
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      return topRatedMoviesBloc;
    },
    act: (bloc) => bloc.add(OnTopMoviesCalled()),
    expect: () => <TopMoviesState>[
      TopMoviesLoading(),
      TopMoviesError('Server Failure'),
    ],
    verify: (bloc) => TopMoviesLoading(),
  );

  blocTest<TopRatedMoviesBloc, TopMoviesState>(
    'should emits TopRatedMoviesLoading state and then TopRatedMoviesEmpty state when data is retrieved empty..',
    build: () {
      when(mockGetTopRatedMovies.execute())
          .thenAnswer((_) async => const Right([]));
      return topRatedMoviesBloc;
    },
    act: (bloc) => bloc.add(OnTopMoviesCalled()),
    expect: () => <TopMoviesState>[
      TopMoviesLoading(),
      TopMoviesEmpty(),
    ],
  );
}
