import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/purpose.dart';
import '../repositories/catalogs_repository.dart';

class GetPurposes implements UseCase<List<Purpose>, GetPurposesParams> {
  final CatalogsRepository repository;

  GetPurposes(this.repository);

  @override
  Future<Either<Failure, List<Purpose>>> call(GetPurposesParams params) async {
    return await repository.getPurposes(params.category);
  }
}

class GetPurposesParams {
  final String category;

  GetPurposesParams({required this.category});
}
