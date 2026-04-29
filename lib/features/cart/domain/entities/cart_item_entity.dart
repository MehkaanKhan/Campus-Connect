class CartItemEntity {
  final String id;
  final String name;
  final double price;
  final int quantity;
  final String? imageUrl;

  const CartItemEntity({
    required this.id,
    required this.name,
    required this.price,
    required this.quantity,
    this.imageUrl,
  });

  double get total => price * quantity;

  CartItemEntity copyWith({int? quantity}) => CartItemEntity(
        id: id,
        name: name,
        price: price,
        quantity: quantity ?? this.quantity,
        imageUrl: imageUrl,
      );
}
