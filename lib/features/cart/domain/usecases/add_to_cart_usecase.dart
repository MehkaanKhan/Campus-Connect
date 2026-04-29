import '../entities/cart_item_entity.dart';
import '../repositories/cart_repository.dart';

class AddToCartUsecase {
  final CartRepository _repo;
  const AddToCartUsecase(this._repo);

  void call(CartItemEntity item) => _repo.addItem(item);
}
