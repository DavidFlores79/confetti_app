import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/economic_activity.dart';
import '../repositories/catalogs_repository.dart';

class GetEconomicActivities
    implements UseCase<List<EconomicActivity>, NoParams> {
  final CatalogsRepository repository;

  GetEconomicActivities(this.repository);

  @override
  Future<Either<Failure, List<EconomicActivity>>> call(NoParams params) async {
    return await repository.getEconomicActivities();
  }
}
