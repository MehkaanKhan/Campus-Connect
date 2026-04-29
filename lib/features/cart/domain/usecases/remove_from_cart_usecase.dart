import '../repositories/cart_repository.dart';

class RemoveFromCartUsecase {
  final CartRepository _repo;
  const RemoveFromCartUsecase(this._repo);

  void call(String id) => _repo.removeItem(id);
}
