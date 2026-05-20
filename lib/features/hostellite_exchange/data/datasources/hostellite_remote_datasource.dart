import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/services/supabase_service.dart';
import '../../domain/entities/exchange_item_entity.dart';

abstract class HostelliteRemoteDataSource {
  Future<List<ExchangeItemEntity>> getItems({ItemType? filter});
}

class HostelliteRemoteDataSourceImpl implements HostelliteRemoteDataSource {
  final SupabaseClient _client;

  HostelliteRemoteDataSourceImpl({SupabaseClient? client})
      : _client = client ?? SupabaseService.client;

  @override
  Future<List<ExchangeItemEntity>> getItems({ItemType? filter}) async {
    var query = _client
        .from('exchange_items')
        .select(
          'id, title, description, item_type, price, price_unit, condition, image_url, is_available, created_at, profiles(full_name, avatar_url)',
        )
        .eq('is_available', true);

    if (filter != null) {
      query = query.eq('item_type', _typeStr(filter));
    }

    final data = await query.order('created_at', ascending: false);
    return (data as List).map(_map).toList();
  }

  ExchangeItemEntity _map(dynamic row) {
    final p = row['profiles'] as Map?;
    return ExchangeItemEntity(
      id: row['id'] as String,
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
    );
  }

  String _typeStr(ItemType t) {
    switch (t) {
      case ItemType.borrow: return 'borrow';
      case ItemType.rent:   return 'rent';
      case ItemType.free:   return 'free';
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
    final diff = DateTime.now().difference(dt);
    if (diff.inDays > 0) return '${diff.inDays}d ago';
    if (diff.inHours > 0) return '${diff.inHours}h ago';
    if (diff.inMinutes > 0) return '${diff.inMinutes}m ago';
    return 'Just now';
  }
}
