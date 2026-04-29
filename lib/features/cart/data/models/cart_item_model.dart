import '../../domain/entities/cart_item_entity.dart';

class CartItemModel extends CartItemEntity {
  const CartItemModel({
    required super.id,
    required super.name,
    required super.price,
    required super.quantity,
    super.imageUrl,
  });

  factory CartItemModel.fromJson(Map<String, dynamic> json) => CartItemModel(
        id: json['id'] as String,
        name: json['name'] as String,
        price: (json['price'] as num).toDouble(),
        quantity: json['quantity'] as int,
        imageUrl: json['image_url'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'price': price,
        'quantity': quantity,
        'image_url': imageUrl,
      };
}
