import '../entities/cart_item_entity.dart';

abstract class CartRepository {
  List<CartItemEntity> getItems();
  void addItem(CartItemEntity item);
  void removeItem(String id);
  void updateQuantity(String id, int quantity);
  void clearCart();
}
