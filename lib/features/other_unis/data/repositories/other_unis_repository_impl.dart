import '../../domain/entities/other_uni_entity.dart';
import '../../domain/repositories/other_unis_repository.dart';
import '../datasources/other_unis_remote_datasource.dart';

class OtherUnisRepositoryImpl implements OtherUnisRepository {
  final OtherUnisRemoteDataSource _datasource;

  OtherUnisRepositoryImpl(this._datasource);

  @override
  Future<List<OtherUniEntity>> getUniversities() => _datasource.getUniversities();
}
