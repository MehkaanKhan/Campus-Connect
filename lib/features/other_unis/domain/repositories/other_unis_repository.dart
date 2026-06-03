import '../entities/other_uni_entity.dart';

abstract class OtherUnisRepository {
  Future<List<OtherUniEntity>> getUniversities();
}
