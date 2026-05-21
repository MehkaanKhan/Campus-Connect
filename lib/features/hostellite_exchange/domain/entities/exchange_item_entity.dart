enum ItemType { borrow, rent, free }
enum ItemCondition { brandNew, likeNew, good, fair }

class ExchangeItemEntity {
  final String id;
  final String title;
  final String description;
  final ItemType type;
  final double? price;
  final String? priceUnit;
  final ItemCondition condition;
  final String sellerName;
  final String? sellerAvatarUrl;
  final String? imageUrl;
  final String timeAgo;
  final bool isAvailable;
  final String? sellerEmail;
  final String? sellerId;

  const ExchangeItemEntity({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    this.price,
    this.priceUnit,
    required this.condition,
    required this.sellerName,
    this.sellerAvatarUrl,
    this.imageUrl,
    required this.timeAgo,
    this.isAvailable = true,
    this.sellerEmail,
    this.sellerId,
  });

  String get typeLabel {
    switch (type) {
      case ItemType.borrow:  return 'Borrow';
      case ItemType.rent:    return 'Rent';
      case ItemType.free:    return 'Giveaway';
    }
  }

  String get priceLabel {
    if (type == ItemType.free) return 'Free';
    if (price == null) return typeLabel;
    final unit = priceUnit ?? '';
    return '\$${price!.toStringAsFixed(0)}$unit';
  }

  String get conditionLabel {
    switch (condition) {
      case ItemCondition.brandNew: return 'Brand New';
      case ItemCondition.likeNew:  return 'Like New';
      case ItemCondition.good:     return 'Good';
      case ItemCondition.fair:     return 'Fair';
    }
  }
}
