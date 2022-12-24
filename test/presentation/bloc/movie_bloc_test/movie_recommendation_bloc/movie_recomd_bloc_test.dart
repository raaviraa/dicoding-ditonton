import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:core/domain/usecases/get_movie_recommendations.dart';
import 'package:core/presentation/bloc/movie_bloc/movie_recomendation/movie_recomd_bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import '../../../../../dummy_data/dummy_objects.dart';
import 'movie_recomd_bloc_test.mocks.dart';

@GenerateMocks([GetMovieRecommendations])
void main() {
  late MockGetMovieRecommendations mockGetMovieRecommendations;
  late MovieRecomdBloc movieRecomdBloc;

  const testId = 1;

  setUp(() {
    mockGetMovieRecommendations = MockGetMovieRecommendations();
    movieRecomdBloc = MovieRecomdBloc(mockGetMovieRecommendations);
  });

  test('the MovieRecommendationsEmpty initial state should be empty ', () {
    expect(movieRecomdBloc.state, MovieRecomdEmpty());
  });

  blocTest<MovieRecomdBloc, MovieRecomdState>(
    'should emits PopularMovieLoading state and then PopularMovieHasData state when data is successfully fetched..',
    build: () {
      when(mockGetMovieRecommendations.execute(testId))
          .thenAnswer((_) async => Right(testMovieList));
      return movieRecomdBloc;
    },
    act: (bloc) => bloc.add(OnMovieRecomdCalled(testId)),
    expect: () => <MovieRecomdState>[
      MovieRecomdLoading(),
      MovieRecomdHasData(testMovieList),
    ],
    verify: (bloc) => verify(mockGetMovieRecommendations.execute(testId)),
  );

  blocTest<MovieRecomdBloc, MovieRecomdState>(
    'should emits MovieRecommendationsLoading state and then MovieRecommendationsError state when data is failed fetched..',
    build: () {
      when(mockGetMovieRecommendations.execute(testId))
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      return movieRecomdBloc;
    },
    act: (bloc) => bloc.add(OnMovieRecomdCalled(testId)),
    expect: () => <MovieRecomdState>[
      MovieRecomdLoading(),
      MovieRecomdError('Server Failure'),
    ],
    verify: (bloc) => MovieRecomdLoading(),
  );

  blocTest<MovieRecomdBloc, MovieRecomdState>(
    'should emits MovieRecommendationsLoading state and then MovieRecommendationsEmpty state when data is retrieved empty..',
    build: () {
      when(mockGetMovieRecommendations.execute(testId))
          .thenAnswer((_) async => const Right([]));
      return movieRecomdBloc;
    },
    act: (bloc) => bloc.add(OnMovieRecomdCalled(testId)),
    expect: () => <MovieRecomdState>[
      MovieRecomdLoading(),
      MovieRecomdEmpty(),
    ],
  );
}
