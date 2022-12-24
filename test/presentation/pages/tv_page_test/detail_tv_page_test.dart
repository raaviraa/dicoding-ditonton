import 'package:core/presentation/bloc/tv_bloc/tv_detail/tv_detail_bloc.dart';
import 'package:core/presentation/bloc/tv_bloc/tv_reccomendation/tv_recom_bloc.dart';
import 'package:core/presentation/bloc/tv_bloc/watchlist_tv/watchlist_tv_bloc.dart';
import 'package:core/presentation/pages/tv/tv_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../dummy_data/dummy_objects_tv.dart';
import '../../../helpers/test_helper_tv_page.dart';

void main() {
  late FakeTvDetailBloc fakeTvDetailBloc;
  late FakeWatchlistTvBloc fakeWatchlistTvBloc;
  late FakeTvRecomBloc fakeTvRecomBloc;

  setUpAll(() {
    fakeTvDetailBloc = FakeTvDetailBloc();
    registerFallbackValue(FakeTvDetailEvent());
    registerFallbackValue(FakeTvDetailState());

    fakeWatchlistTvBloc = FakeWatchlistTvBloc();
    registerFallbackValue(FakeWatchlistTvEvent());
    registerFallbackValue(FakeWatchlistTvState());

    fakeTvRecomBloc = FakeTvRecomBloc();
    registerFallbackValue(FakeTvRecomEvent());
    registerFallbackValue(FakeTvRecomState());
  });

  Widget _makeTestableWidget(Widget body) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<TvDetailBloc>(
          create: (_) => fakeTvDetailBloc,
        ),
        BlocProvider<WatchlistTvBloc>(
          create: (_) => fakeWatchlistTvBloc,
        ),
        BlocProvider<TvRecomBloc>(
          create: (_) => fakeTvRecomBloc,
        ),
      ],
      child: MaterialApp(
        home: body,
      ),
    );
  }

  tearDown(() {
    fakeTvDetailBloc.close();
    fakeWatchlistTvBloc.close();
    fakeTvRecomBloc.close();
  });

  const testId = 1;

  testWidgets('Page should display circular progress indicator when loading',
      (WidgetTester tester) async {
    when(() => fakeTvDetailBloc.state).thenReturn(TvDetailLoading());
    when(() => fakeWatchlistTvBloc.state).thenReturn(WatchlistTvLoading());
    when(() => fakeTvRecomBloc.state).thenReturn(TvRecomLoading());

    final circularProgressIndicatorFinder =
        find.byType(CircularProgressIndicator);

    await tester.pumpWidget(_makeTestableWidget(TelevisionDetailPage(
      id: testId,
    )));
    await tester.pump();

    expect(circularProgressIndicatorFinder, findsOneWidget);
  });

  testWidgets('Should widget display which all required',
      (WidgetTester tester) async {
    when(() => fakeTvDetailBloc.state)
        .thenReturn(TvDetailHasData(testTvDetail));
    when(() => fakeWatchlistTvBloc.state)
        .thenReturn(WatchlistTvHasData(testTvList));
    when(() => fakeTvRecomBloc.state).thenReturn(TvRecomHasData(testTvList));
    await tester
        .pumpWidget(_makeTestableWidget(TelevisionDetailPage(id: testId)));
    await tester.pump();

    expect(find.text('Watchlist'), findsOneWidget);
    expect(find.text('Overview'), findsOneWidget);
    expect(find.text('More Like This'), findsOneWidget);
    expect(find.byKey(const Key('detail_tv')), findsOneWidget);
  });

  testWidgets(
      'Should display add icon when Tvseries is not added to watchlist in watchlist button',
      (WidgetTester tester) async {
    when(() => fakeTvDetailBloc.state)
        .thenReturn(TvDetailHasData(testTvDetail));
    when(() => fakeWatchlistTvBloc.state).thenReturn(WatchlistTvIsAdded(false));
    when(() => fakeTvRecomBloc.state).thenReturn(TvRecomHasData(testTvList));
    final addIconFinder = find.byIcon(Icons.add);
    await tester
        .pumpWidget(_makeTestableWidget(TelevisionDetailPage(id: testId)));
    await tester.pump();
    expect(addIconFinder, findsOneWidget);
  });

  testWidgets(
      'Should display check icon when Tvseries is added to watchlist in watchlist button',
      (WidgetTester tester) async {
    when(() => fakeTvDetailBloc.state)
        .thenReturn(TvDetailHasData(testTvDetail));
    when(() => fakeWatchlistTvBloc.state).thenReturn(WatchlistTvIsAdded(true));
    when(() => fakeTvRecomBloc.state).thenReturn(TvRecomHasData(testTvList));
    final checkIconFinder = find.byIcon(Icons.check);
    await tester
        .pumpWidget(_makeTestableWidget(TelevisionDetailPage(id: testId)));
    await tester.pump();
    expect(checkIconFinder, findsOneWidget);
  });
}
