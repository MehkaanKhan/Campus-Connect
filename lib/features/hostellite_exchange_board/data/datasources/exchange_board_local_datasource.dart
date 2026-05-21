import '../../../hostellite_exchange/domain/entities/exchange_item_entity.dart';

abstract class ExchangeBoardLocalDataSource {
  Future<List<ExchangeItemEntity>> getMyItems();
}

class ExchangeBoardLocalDataSourceImpl implements ExchangeBoardLocalDataSource {
  @override
  Future<List<ExchangeItemEntity>> getMyItems() async {
    await Future.delayed(const Duration(milliseconds: 350));
    return const [
      ExchangeItemEntity(
        id: 'mock_my_item_1',
        title: 'My Electric Kettle',
        description: 'Perfect for making tea in hostel rooms. Rs. 200/month.',
        type: ItemType.rent,
        price: 200,
        priceUnit: '/mo',
        condition: ItemCondition.good,
        sellerName: 'My Account',
        imageUrl: 'assets/images/placeholder.png',
        timeAgo: '1d ago',
        isAvailable: true,
        sellerId: 'mock_user_id',
      ),
      ExchangeItemEntity(
        id: 'mock_my_item_2',
        title: 'Thomas Calculus 14th Edition',
        description: 'Used textbook for math courses.',
        type: ItemType.free,
        condition: ItemCondition.good,
        sellerName: 'My Account',
        imageUrl: 'assets/images/placeholder.png',
        timeAgo: '3d ago',
        isAvailable: false,
        sellerId: 'mock_user_id',
      ),
    ];
  }
}
