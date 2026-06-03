import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/services/supabase_service.dart';
import '../../../hostellite_exchange/domain/entities/exchange_item_entity.dart';

abstract class ExchangeBoardRemoteDataSource {
  Future<void> submitComplaint({
    required String itemId,
    required String reason,
    required String details,
  });

  Future<void> createExchangeItem({
    required String title,
    required String description,
    required ItemType type,
    double? price,
    String? priceUnit,
    required ItemCondition condition,
    String? imageUrl,
  });

  Future<void> updateItemAvailability({
    required String itemId,
    required bool isAvailable,
  });

  Future<void> deleteExchangeItem(String itemId);

  Future<List<ExchangeItemEntity>> getMyItems();
}

class ExchangeBoardRemoteDataSourceImpl implements ExchangeBoardRemoteDataSource {
  final SupabaseClient _client;

  ExchangeBoardRemoteDataSourceImpl({SupabaseClient? client})
      : _client = client ?? SupabaseService.client;

  @override
  Future<void> submitComplaint({
    required String itemId,
    required String reason,
    required String details,
  }) async {
    await _client.from('exchange_complaints').insert({
      'item_id': itemId,
      'reporter_id': SupabaseService.uid,
      'reason': reason,
      'details': details,
      'status': 'pending',
    });
  }

  @override
  Future<void> createExchangeItem({
    required String title,
    required String description,
    required ItemType type,
    double? price,
    String? priceUnit,
    required ItemCondition condition,
    String? imageUrl,
  }) async {
    await _client.from('exchange_items').insert({
      'seller_id': SupabaseService.uid,
      'title': title,
      'description': description,
      'item_type': _typeStr(type),
      'price': price,
      'price_unit': priceUnit,
      'condition': _conditionStr(condition),
      'image_url': imageUrl,
      'is_available': true,
    });
  }

  @override
  Future<void> updateItemAvailability({
    required String itemId,
    required bool isAvailable,
  }) async {
    await _client.from('exchange_items').update({
      'is_available': isAvailable,
    }).eq('id', itemId);
  }

  @override
  Future<void> deleteExchangeItem(String itemId) async {
    await _client.from('exchange_items').delete().eq('id', itemId);
  }

  @override
  Future<List<ExchangeItemEntity>> getMyItems() async {
    final data = await _client
        .from('exchange_items')
        .select(
          'id, seller_id, title, description, item_type, price, price_unit, condition, image_url, is_available, created_at, profiles(full_name, avatar_url, email)',
        )
        .eq('seller_id', SupabaseService.uid);

    return (data as List).map(_map).toList();
  }

  ExchangeItemEntity _map(dynamic row) {
    final p = row['profiles'] as Map?;
    return ExchangeItemEntity(
      id: row['id'] as String,
      sellerId: row['seller_id'] as String?,
      title: row['title'] as String,
      description: row['description'] as String? ?? '',
      type: _parseType(row['item_type'] as String?),
      price: (row['price'] as num?)?.toDouble(),
      priceUnit: row['price_unit'] as String?,
      condition: _parseCondition(row['condition'] as String?),
      sellerName: p?['full_name'] as String? ?? 'Unknown',
      sellerAvatarUrl: p?['avatar_url'] as String?,
      imageUrl: row['image_url'] as String?,
      timeAgo: _timeAgo(DateTime.parse(row['created_at'] as String)),
      isAvailable: row['is_available'] as bool? ?? true,
      sellerEmail: p?['email'] as String?,
    );
  }

  String _typeStr(ItemType t) {
    switch (t) {
      case ItemType.borrow: return 'borrow';
      case ItemType.rent:   return 'rent';
      case ItemType.free:   return 'free';
    }
  }

  String _conditionStr(ItemCondition c) {
    switch (c) {
      case ItemCondition.brandNew: return 'brand_new';
      case ItemCondition.likeNew:  return 'like_new';
      case ItemCondition.fair:      return 'fair';
      case ItemCondition.good:      return 'good';
    }
  }

  ItemType _parseType(String? s) {
    switch (s) {
      case 'rent': return ItemType.rent;
      case 'free': return ItemType.free;
      default:     return ItemType.borrow;
    }
  }

  ItemCondition _parseCondition(String? s) {
    switch (s) {
      case 'brand_new': return ItemCondition.brandNew;
      case 'like_new':  return ItemCondition.likeNew;
      case 'fair':      return ItemCondition.fair;
      default:          return ItemCondition.good;
    }
  }

  String _timeAgo(DateTime dt) {
    final diff = DateTime.now().difference(dt) + const Duration(hours: 1);
    if (diff.inDays > 0) return '${diff.inDays}d ago';
    if (diff.inHours > 0) return '${diff.inHours}h ago';
    if (diff.inMinutes > 0) return '${diff.inMinutes}m ago';
    return 'Just now';
  }
}
