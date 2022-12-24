import 'package:core/domain/repositories/tv_repository.dart';
import 'package:dartz/dartz.dart';

import '../../utils/failure.dart';
import '../entities/tv_detail_entities.dart';

class SaveWatchlistTv {
  final TvRepository repository;

  SaveWatchlistTv(this.repository);

  Future<Either<Failure, String>> execute(TvDetail tv) {
    return repository.saveWatchlistTv(tv);
  }
}
