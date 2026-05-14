import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../../core/widgets/campus_bottom_navbar.dart';
import '../../../../core/widgets/campus_top_navbar.dart';
import '../../../../core/widgets/app_loader.dart';
import '../../domain/entities/exchange_item_entity.dart';
import '../provider/hostellite_provider.dart';

class HostellitePage extends StatefulWidget {
  const HostellitePage({super.key});

  @override
  State<HostellitePage> createState() => _HostellitePageState();
}

class _HostellitePageState extends State<HostellitePage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<HostelliteProvider>().load();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F5),
      body: Column(
        children: [
          CampusTopNavBar(
            onBack: context.canPop() ? () => context.pop() : null,
          ),
          const _HostelliteHeader(),
          const _FilterRow(),
          Expanded(child: _ItemsList()),
          const CampusBottomNavBar(activeTab: BottomNavTab.explore),
        ],
      ),
    );
  }
}

class _HostelliteHeader extends StatelessWidget {
  const _HostelliteHeader();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Hostellite Exchange',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: Color(0xFF1A1A1A),
            ),
          ),
          SizedBox(height: 4),
          Text(
            'Borrow, rent, or find giveaways from your fellow campus residents. Share resources and reduce waste.',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 13,
              color: Color(0xFF94A3B8),
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}

class _FilterRow extends StatelessWidget {
  const _FilterRow();

  static const _options = [
    (null, 'All Items'),
    (ItemType.borrow, 'BORROW'),
    (ItemType.rent, 'RENT'),
    (ItemType.free, 'Free'),
  ];

  @override
  Widget build(BuildContext context) {
    final current = context.watch<HostelliteProvider>().filter;
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: _options.map((opt) {
            final isActive = current == opt.$1;
            return GestureDetector(
              onTap: () => context.read<HostelliteProvider>().setFilter(opt.$1),
              child: Container(
                margin: const EdgeInsets.only(right: 8),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
                decoration: BoxDecoration(
                  color: isActive ? const Color(0xFF98A895) : const Color(0xFFF2F3F0),
                  borderRadius: BorderRadius.circular(20),
                  border: isActive ? null : Border.all(color: const Color(0xFFE2E3E0)),
                ),
                child: Text(
                  opt.$2,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: isActive ? Colors.white : const Color(0xFF434942),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}

class _ItemsList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final provider = context.watch<HostelliteProvider>();
    if (provider.isLoading) return const AppLoader();
    if (provider.items.isEmpty) {
      return const Center(
        child: Text('No items found', style: TextStyle(color: Color(0xFF94A3B8))),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.only(top: 10, bottom: 16),
      itemCount: provider.items.length,
      itemBuilder: (ctx, i) => _ItemCard(item: provider.items[i]),
    );
  }
}

class _ItemCard extends StatelessWidget {
  final ExchangeItemEntity item;
  const _ItemCard({required this.item});


  Color get _badgeBg {
    switch (item.type) {
      case ItemType.borrow: return const Color(0xFFE3E9E1);
      case ItemType.rent:   return const Color(0xFFE5ECF0);
      case ItemType.free:   return const Color(0xFFF1F2EF);
    }
  }

  Color get _badgeText {
    switch (item.type) {
      case ItemType.borrow: return const Color(0xFF3D483A);
      case ItemType.rent:   return const Color(0xFF1D2B33);
      case ItemType.free:   return const Color(0xFF2A2E26);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push('/hostellite-exchange/detail', extra: item),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFFEEEEE8)),
        ),
        clipBehavior: Clip.hardEdge,
        child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              item.imageUrl != null
                  ? item.imageUrl!.startsWith('http')
                      ? Image.network(
                          item.imageUrl!,
                          width: double.infinity,
                          height: 170,
                          fit: BoxFit.cover,
                          errorBuilder: (_, _, _) => _placeholder(),
                        )
                      : Image.asset(
                          item.imageUrl!,
                          width: double.infinity,
                          height: 170,
                          fit: BoxFit.cover,
                          errorBuilder: (_, _, _) => _placeholder(),
                        )
                  : _placeholder(),
              Positioned(
                top: 10,
                right: 10,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                  decoration: BoxDecoration(
                    color: _badgeBg,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    item.typeLabel,
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: _badgeText,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 12, 14, 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1A1A1A),
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  item.description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 13,
                    color: Color(0xFF64748B),
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    CircleAvatar(
                      radius: 11,
                      backgroundColor: const Color(0xFF1E3A8A),
                      child: Text(
                        item.sellerName[0].toUpperCase(),
                        style: const TextStyle(
                          fontSize: 9,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 7),
                    Text(
                      item.sellerName,
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF64748B),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    ));
  }

  Widget _placeholder() => Container(
        width: double.infinity,
        height: 170,
        color: const Color(0xFFF0F0EC),
        child: const Icon(Icons.image_outlined, size: 40, color: Color(0xFFCCCCC8)),
      );
}
