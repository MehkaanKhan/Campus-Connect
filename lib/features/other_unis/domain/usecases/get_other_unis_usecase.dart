import '../entities/other_uni_entity.dart';
import '../repositories/other_unis_repository.dart';

class GetOtherUnisUsecase {
  final OtherUnisRepository _repo;

  GetOtherUnisUsecase(this._repo);

  Future<List<OtherUniEntity>> call() => _repo.getUniversities();
}
