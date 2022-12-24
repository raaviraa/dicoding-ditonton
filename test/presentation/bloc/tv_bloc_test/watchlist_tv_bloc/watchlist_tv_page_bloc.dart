import 'package:core/presentation/bloc/tv_bloc/watchlist_tv/watchlist_tv_bloc.dart';
import 'package:core/presentation/pages/tv/tv_watchlist_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../helpers/test_helper_watchlist_page.dart';

void main() {
  late FakeWatchlistTvBloc fakeWatchlistTvBloc;

  setUpAll(() {
    fakeWatchlistTvBloc = FakeWatchlistTvBloc();
    registerFallbackValue(FakeWatchlistTvEvent());
    registerFallbackValue(FakeWatchlistTvState());
  });

  Widget _makeTestableWidget(Widget body) {
    return BlocProvider<WatchlistTvBloc>(
      create: (_) => fakeWatchlistTvBloc,
      child: MaterialApp(
        home: Scaffold(
          body: body,
        ),
      ),
    );
  }

  tearDown(() => fakeWatchlistTvBloc.close());

  testWidgets('page should display circular progress indicator when loading',
      (WidgetTester tester) async {
    when(() => fakeWatchlistTvBloc.state).thenReturn(WatchlistTvLoading());

    final circularProgressIndicatorFinder =
        find.byType(CircularProgressIndicator);

    await tester
        .pumpWidget(_makeTestableWidget(const WatchlistTelevisionPage()));
    await tester.pump();

    expect(circularProgressIndicatorFinder, findsOneWidget);
  });

  testWidgets('should display text with message when error',
      (WidgetTester tester) async {
    const errorMessage = 'error message';

    when(() => fakeWatchlistTvBloc.state)
        .thenReturn(WatchlistTvError(errorMessage));

    final textMessageKeyFinder = find.byKey(const Key('error_msg'));
    await tester
        .pumpWidget(_makeTestableWidget(const WatchlistTelevisionPage()));
    await tester.pump();

    expect(textMessageKeyFinder, findsOneWidget);
  });
}
