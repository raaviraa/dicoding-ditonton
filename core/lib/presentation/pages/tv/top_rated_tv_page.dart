import 'package:core/presentation/bloc/tv_bloc/top_rated_tv/top_tv_bloc.dart';
import 'package:core/presentation/widgets/tv_card_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TopRatedTelevisionPage extends StatefulWidget {
  static const TOP_RATED_TV = '/top-rated-tv';

  const TopRatedTelevisionPage({Key? key}) : super(key: key);

  @override
  State<TopRatedTelevisionPage> createState() => _TopRatedTelevisionPageState();
}

class _TopRatedTelevisionPageState extends State<TopRatedTelevisionPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
        () => context.read<TopRatedTvBloc>().add(OnTopRatedTvCalled()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Top Rated TvSeries'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocBuilder<TopRatedTvBloc, TopRatedTvState>(
          builder: (context, state) {
            if (state is TopRatedTvLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is TopRatedTvHasData) {
              final tvSeries = state.result;
              return ListView.builder(
                itemBuilder: (context, index) {
                  final tv = tvSeries[index];
                  return TvCard(tv);
                },
                itemCount: tvSeries.length,
              );
            } else {
              return Center(
                key: const Key('error_msg'),
                child: Text((state as TopRatedTvError).message),
              );
            }
          },
        ),
      ),
    );
  }
}
