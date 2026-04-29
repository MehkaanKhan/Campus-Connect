import '../../domain/entities/cart_item_entity.dart';
import '../../domain/repositories/cart_repository.dart';

class CartRepositoryImpl implements CartRepository {
  final List<CartItemEntity> _items = [];

  @override
  List<CartItemEntity> getItems() => List.unmodifiable(_items);

  @override
  void addItem(CartItemEntity item) {
    final index = _items.indexWhere((e) => e.id == item.id);
    if (index >= 0) {
      _items[index] = _items[index].copyWith(quantity: _items[index].quantity + item.quantity);
    } else {
      _items.add(item);
    }
  }

  @override
  void removeItem(String id) => _items.removeWhere((e) => e.id == id);

  @override
  void updateQuantity(String id, int quantity) {
    final index = _items.indexWhere((e) => e.id == id);
    if (index >= 0) {
      if (quantity <= 0) {
        _items.removeAt(index);
      } else {
        _items[index] = _items[index].copyWith(quantity: quantity);
      }
    }
  }

  @override
  void clearCart() => _items.clear();
}
