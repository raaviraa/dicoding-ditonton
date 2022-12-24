import 'package:core/presentation/bloc/movie_bloc/watchlist_movie/watchlist_bloc.dart';
import 'package:core/presentation/pages/movie/movie_watchlist.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../helpers/test_helper_watchlist_page.dart';

void main() {
  late FakeWatchlistBloc fakeWatchlistBloc;

  setUpAll(() {
    fakeWatchlistBloc = FakeWatchlistBloc();
    registerFallbackValue(FakeWatchlistEvent());
    registerFallbackValue(FakeWatchlistState());
  });

  Widget _makeTestableWidget(Widget body) {
    return BlocProvider<WatchlistBloc>(
      create: (_) => fakeWatchlistBloc,
      child: MaterialApp(
        home: Scaffold(
          body: body,
        ),
      ),
    );
  }

  tearDown(() => fakeWatchlistBloc.close());

  testWidgets('page should display circular progress indicator when loading',
      (WidgetTester tester) async {
    when(() => fakeWatchlistBloc.state).thenReturn(WatchlistLoading());

    final circularProgressIndicatorFinder =
        find.byType(CircularProgressIndicator);

    await tester.pumpWidget(_makeTestableWidget(WatchlistMoviePage()));
    await tester.pump();

    expect(circularProgressIndicatorFinder, findsOneWidget);
  });

  testWidgets('should display text with message when error',
      (WidgetTester tester) async {
    const errorMessage = 'error message';

    when(() => fakeWatchlistBloc.state)
        .thenReturn(WatchlistError(errorMessage));

    final textMessageKeyFinder = find.byKey(const Key('error_msg'));
    await tester.pumpWidget(_makeTestableWidget(WatchlistMoviePage()));
    await tester.pump();

    expect(textMessageKeyFinder, findsOneWidget);
  });
}
