import 'package:core/presentation/bloc/movie_bloc/movie_detail/detail_movie_bloc.dart';
import 'package:core/presentation/bloc/movie_bloc/movie_recomendation/movie_recomd_bloc.dart';
import 'package:core/presentation/bloc/movie_bloc/watchlist_movie/watchlist_bloc.dart';
import 'package:core/presentation/pages/movie/movie_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import '../../../../dummy_data/dummy_objects.dart';
import '../../../helpers/test_helper_movie_page.dart';

void main() {
  late FakeDetailMovieBloc fakeDetailMovieBloc;
  late FakeWatchlistBloc fakeWatchlistBloc;
  late FakeMovieRecomdBloc fakeMovieRecomdBloc;

  setUpAll(() {
    fakeDetailMovieBloc = FakeDetailMovieBloc();
    registerFallbackValue(FakeDetailMovieEvent());
    registerFallbackValue(FakeDetailMovieState());

    fakeWatchlistBloc = FakeWatchlistBloc();
    registerFallbackValue(FakeWatchlistEvent());
    registerFallbackValue(FakeWatchlistState());

    fakeMovieRecomdBloc = FakeMovieRecomdBloc();
    registerFallbackValue(FakeMovieRecomdEvent());
    registerFallbackValue(FakeMovieRecomdState());
  });

  Widget _makeTestableWidget(Widget body) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<DetailMovieBloc>(
          create: (_) => fakeDetailMovieBloc,
        ),
        BlocProvider<WatchlistBloc>(
          create: (_) => fakeWatchlistBloc,
        ),
        BlocProvider<MovieRecomdBloc>(
          create: (_) => fakeMovieRecomdBloc,
        ),
      ],
      child: MaterialApp(
        home: body,
      ),
    );
  }

  tearDown(() {
    fakeDetailMovieBloc.close();
    fakeWatchlistBloc.close();
    fakeMovieRecomdBloc.close();
  });

  const testId = 1;

  testWidgets('page should display circular progress indicator when loading',
      (WidgetTester tester) async {
    when(() => fakeDetailMovieBloc.state).thenReturn(DetailMovieLoading());
    when(() => fakeWatchlistBloc.state).thenReturn(WatchlistLoading());
    when(() => fakeMovieRecomdBloc.state).thenReturn(MovieRecomdLoading());

    final circularProgressIndicatorFinder =
        find.byType(CircularProgressIndicator);

    await tester.pumpWidget(_makeTestableWidget(MovieDetailPage(
      id: testId,
    )));
    await tester.pump();

    expect(circularProgressIndicatorFinder, findsOneWidget);
  });

  testWidgets('should widget display which all required',
      (WidgetTester tester) async {
    when(() => fakeDetailMovieBloc.state)
        .thenReturn(DetailMovieHasData(testMovieDetail));
    when(() => fakeWatchlistBloc.state)
        .thenReturn(WatchlistHasData(testMovieList));
    when(() => fakeMovieRecomdBloc.state)
        .thenReturn(MovieRecomdHasData(testMovieList));
    await tester.pumpWidget(_makeTestableWidget(MovieDetailPage(id: testId)));
    await tester.pump();

    expect(find.text('Watchlist'), findsOneWidget);
    expect(find.text('Overview'), findsOneWidget);
    expect(find.text('More Like This'), findsOneWidget);
    expect(find.byKey(const Key('detail_movie')), findsOneWidget);
  });

  testWidgets(
      'should display add icon when movie is not added to watchlist in watchlist button',
      (WidgetTester tester) async {
    when(() => fakeDetailMovieBloc.state)
        .thenReturn(DetailMovieHasData(testMovieDetail));
    when(() => fakeWatchlistBloc.state)
        .thenReturn(WatchlistMoviesIsAdded(false));
    when(() => fakeMovieRecomdBloc.state)
        .thenReturn(MovieRecomdHasData(testMovieList));
    final addIconFinder = find.byIcon(Icons.add);
    await tester.pumpWidget(_makeTestableWidget(MovieDetailPage(id: testId)));
    await tester.pump();
    expect(addIconFinder, findsOneWidget);
  });

  testWidgets(
      'should display check icon when movie is added to watchlist in watchlist button',
      (WidgetTester tester) async {
    when(() => fakeDetailMovieBloc.state)
        .thenReturn(DetailMovieHasData(testMovieDetail));
    when(() => fakeWatchlistBloc.state)
        .thenReturn(WatchlistMoviesIsAdded(true));
    when(() => fakeMovieRecomdBloc.state)
        .thenReturn(MovieRecomdHasData(testMovieList));
    final checkIconFinder = find.byIcon(Icons.check);
    await tester.pumpWidget(_makeTestableWidget(MovieDetailPage(id: testId)));
    await tester.pump();
    expect(checkIconFinder, findsOneWidget);
  });
}
