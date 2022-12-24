import 'package:core/presentation/bloc/tv_bloc/watchlist_tv/watchlist_tv_bloc.dart';
import 'package:core/presentation/pages/tv/home_tv.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../utils/utils.dart';
import '../../widgets/tv_card_list.dart';

class WatchlistTelevisionPage extends StatefulWidget {
  static const WATCHLIST_TV = '/watchlist-tv';

  const WatchlistTelevisionPage({Key? key}) : super(key: key);

  @override
  State<WatchlistTelevisionPage> createState() =>
      _WatchlistTelevisionPageState();
}

class _WatchlistTelevisionPageState extends State<WatchlistTelevisionPage>
    with RouteAware {
  @override
  void initState() {
    super.initState();
    Future.microtask(
        () => context.read<WatchlistTvBloc>().add(OnWatchlistTvCalled()));
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context)!);
  }

  @override
  void didPopNext() {
    context.read<WatchlistTvBloc>().add(OnWatchlistTvCalled());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocBuilder<WatchlistTvBloc, WatchlistTvState>(
            builder: (context, state) {
          if (state is WatchlistTvLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is WatchlistTvEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    "You don't have any series yet, lets add some!",
                    textAlign: TextAlign.center,
                  ),
                  ElevatedButton(
                    onPressed: () => Navigator.pushNamedAndRemoveUntil(
                      context,
                      HomeTelevisionPage.HOME_TV,
                      (route) => false,
                    ),
                    child: const Text('Add Series'),
                  ),
                ],
              ),
            );
          } else if (state is WatchlistTvHasData) {
            final watchlistTv = state.result;
            return ListView.builder(
              itemBuilder: (context, index) {
                final tv = watchlistTv[index];
                return TvCard(tv);
              },
              itemCount: watchlistTv.length,
            );
          } else {
            return const Center(
              key: Key('error_msg'),
              child: Text('Failed to fetch data'),
            );
          }
        }),
      ),
    );
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }
}
