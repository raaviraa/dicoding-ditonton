import 'package:core/presentation/bloc/tv_bloc/now_playing_tv/noplay_tv_bloc.dart';
import 'package:core/presentation/bloc/tv_bloc/popular_tv/popular_tv_bloc.dart';
import 'package:core/presentation/bloc/tv_bloc/top_rated_tv/top_tv_bloc.dart';
import 'package:core/presentation/pages/tv/home_tv.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../dummy_data/dummy_objects_tv.dart';
import '../../../helpers/test_helper_tv_page.dart';

void main() {
  late FakeNowPlayingTvBloc fakeNowPlayingTvBloc;
  late FakePopularTvBloc fakePopularTvBloc;
  late FakeTopRatedTvBloc fakeTopRatedTvBloc;

  setUp(() {
    fakeNowPlayingTvBloc = FakeNowPlayingTvBloc();
    registerFallbackValue(FakeNowPlayingTvEvent());
    registerFallbackValue(FakeNowPlayingTvState());

    fakePopularTvBloc = FakePopularTvBloc();
    registerFallbackValue(FakePopularTvSeriesEvent());
    registerFallbackValue(FakePopularTvSeriesState());

    fakeTopRatedTvBloc = FakeTopRatedTvBloc();
    registerFallbackValue(FakeTopTvEvent());
    registerFallbackValue(FakeTopRatedTvState());

    TestWidgetsFlutterBinding.ensureInitialized();
  });

  tearDown(() {
    fakeNowPlayingTvBloc.close();
    fakePopularTvBloc.close();
    fakeTopRatedTvBloc.close();
  });

  Widget _createTestableWidget(Widget body) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<NowPlayingTvBloc>(
          create: (context) => fakeNowPlayingTvBloc,
        ),
        BlocProvider<PopularTvSeriesBloc>(
          create: (context) => fakePopularTvBloc,
        ),
        BlocProvider<TopRatedTvBloc>(
          create: (context) => fakeTopRatedTvBloc,
        ),
      ],
      child: MaterialApp(
        home: Scaffold(
          body: body,
        ),
      ),
    );
  }

  testWidgets('Page should display circular progress indicator when loading',
      (WidgetTester tester) async {
    when(() => fakeNowPlayingTvBloc.state).thenReturn(NowPlayingTvLoading());
    when(() => fakePopularTvBloc.state).thenReturn(PopularTvLoading());
    when(() => fakeTopRatedTvBloc.state).thenReturn(TopRatedTvLoading());

    final circularProgressIndicatorFinder =
        find.byType(CircularProgressIndicator);

    await tester.pumpWidget(_createTestableWidget(HomeTelevisionPage()));

    expect(circularProgressIndicatorFinder, findsNWidgets(3));
  });

  testWidgets(
      'Page should display listview of NowPlayingTvSeries when HasData state is happen',
      (WidgetTester tester) async {
    when(() => fakeNowPlayingTvBloc.state)
        .thenReturn(NowPlayingTvHasData(testTvList));
    when(() => fakePopularTvBloc.state)
        .thenReturn(PopularTvHasData(testTvList));
    when(() => fakeTopRatedTvBloc.state)
        .thenReturn(TopRatedTvHasData(testTvList));

    final listViewFinder = find.byType(ListView);

    await tester.pumpWidget(_createTestableWidget(HomeTelevisionPage()));

    expect(listViewFinder, findsWidgets);
  });

  testWidgets('Page should display error with text when Error state is happen',
      (WidgetTester tester) async {
    when(() => fakeNowPlayingTvBloc.state)
        .thenReturn(NowPlayingTvError('error'));
    when(() => fakePopularTvBloc.state).thenReturn(PopularTvError('error'));
    when(() => fakeTopRatedTvBloc.state).thenReturn(TopRatedTvError('error'));

    final errorKeyFinder = find.byKey(const Key('error_msg'));

    await tester.pumpWidget(_createTestableWidget(HomeTelevisionPage()));
    expect(errorKeyFinder, findsNWidgets(3));
  });

  testWidgets('Page should not display when Empty state is happen',
      (WidgetTester tester) async {
    when(() => fakeNowPlayingTvBloc.state).thenReturn(NowPlayingTvEmpty());
    when(() => fakePopularTvBloc.state).thenReturn(PopularTvEmpty());
    when(() => fakeTopRatedTvBloc.state).thenReturn(TopRatedTvEmpty());

    final containerFinder = find.byType(Container);

    await tester.pumpWidget(_createTestableWidget(HomeTelevisionPage()));
    expect(containerFinder, findsNWidgets(3));
  });
}
