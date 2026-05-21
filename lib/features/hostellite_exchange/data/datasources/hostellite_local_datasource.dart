import '../../domain/entities/exchange_item_entity.dart';

abstract class HostelliteLocalDataSource {
  Future<List<ExchangeItemEntity>> getItems();
}

class HostelliteLocalDataSourceImpl implements HostelliteLocalDataSource {
  @override
  Future<List<ExchangeItemEntity>> getItems() async {
    await Future.delayed(const Duration(milliseconds: 350));
    return const [
      ExchangeItemEntity(
        id: '1',
        title: 'Texas Instruments TI-84 Plus',
        description: 'Barely used graphing calculator, great for all STEM courses. Perfect condition with charging cable.',
        type: ItemType.free,
        condition: ItemCondition.likeNew,
        sellerName: 'Alex Johnson',
        imageUrl: 'assets/images/placeholder.png',
        timeAgo: '2h ago',
        sellerEmail: 'alex.johnson@university.edu',
        sellerId: 'mock_seller_1',
      ),
      ExchangeItemEntity(
        id: '2',
        title: 'Danby Mini Fridge 3.3 cu ft',
        description: 'Compact and quiet. Great for storing snacks and drinks. Must pick up from North Hall.',
        type: ItemType.rent,
        price: 75,
        priceUnit: '/mo',
        condition: ItemCondition.good,
        sellerName: 'Sarah Parker',
        imageUrl: 'assets/images/placeholder.png',
        timeAgo: '5h ago',
        sellerEmail: 'sarah.parker@university.edu',
        sellerId: 'mock_seller_2',
      ),
      ExchangeItemEntity(
        id: '3',
        title: 'Intro to Graphic Design Books',
        description: 'Set of 3 design fundamentals textbooks. Ideal for beginner designers on campus.',
        type: ItemType.borrow,
        price: 8,
        priceUnit: '/ea',
        condition: ItemCondition.good,
        sellerName: 'Mike Ross',
        imageUrl: 'assets/images/placeholder.png',
        timeAgo: '1 day ago',
        sellerEmail: 'mike.ross@university.edu',
        sellerId: 'mock_seller_3',
      ),
      ExchangeItemEntity(
        id: '4',
        title: 'Campus Cruiser Bicycle',
        description: 'Includes lock and helmet. Great for getting across campus quickly. Recently pumped tires.',
        type: ItemType.free,
        condition: ItemCondition.good,
        sellerName: 'Emily Parker',
        imageUrl: 'assets/images/placeholder.png',
        timeAgo: '2 days ago',
        sellerEmail: 'emily.parker@university.edu',
        sellerId: 'mock_seller_4',
      ),
      ExchangeItemEntity(
        id: '5',
        title: 'Rent my electric kettle',
        description: 'Rs. 200/month. Pickup from Block C. Available from next week.',
        type: ItemType.rent,
        price: 200,
        priceUnit: '/mo',
        condition: ItemCondition.good,
        sellerName: 'Bilal K.',
        imageUrl: 'assets/images/placeholder.png',
        timeAgo: '3 days ago',
        sellerEmail: 'bilal.k@university.edu',
        sellerId: 'mock_seller_5',
      ),
    ];
  }
}
