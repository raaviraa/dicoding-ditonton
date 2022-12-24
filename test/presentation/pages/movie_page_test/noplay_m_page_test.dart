import 'package:core/presentation/bloc/movie_bloc/now_playing_movie/now_playing_bloc.dart';
import 'package:core/presentation/pages/movie/now_playing_m_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../helpers/test_helper_movie_page.dart';

void main() {
  late FakeNowPlayingMoviesBloc fakeNowPlayingMovieBloc;

  setUpAll(() {
    fakeNowPlayingMovieBloc = FakeNowPlayingMoviesBloc();
    registerFallbackValue(FakeNowPlayingMoviesEvent());
    registerFallbackValue(FakeNowPlayingMoviesState());
  });

  Widget _makeTestableWidget(Widget body) {
    return BlocProvider<NowPlayingMovieBloc>(
      create: (_) => fakeNowPlayingMovieBloc,
      child: MaterialApp(
        home: Scaffold(
          body: body,
        ),
      ),
    );
  }

  tearDown(() {
    fakeNowPlayingMovieBloc.close();
  });

  testWidgets('page should display circular progress indicator when loading',
      (WidgetTester tester) async {
    when(() => fakeNowPlayingMovieBloc.state)
        .thenReturn(NowPlayingMovieLoading());

    final circularProgressIndicatorFinder =
        find.byType(CircularProgressIndicator);

    await tester.pumpWidget(_makeTestableWidget(NowPlayingMoviesPage()));
    await tester.pump();

    expect(circularProgressIndicatorFinder, findsOneWidget);
  });

  testWidgets('should display text with message when error',
      (WidgetTester tester) async {
    const errorMessage = 'error message';

    when(() => fakeNowPlayingMovieBloc.state)
        .thenReturn(NowPlayingMovieError(errorMessage));

    final textMessageKeyFinder = find.byKey(const Key('error_msg'));
    await tester.pumpWidget(_makeTestableWidget(NowPlayingMoviesPage()));
    await tester.pump();

    expect(textMessageKeyFinder, findsOneWidget);
  });
}
