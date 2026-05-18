import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/size_config.dart';
import '../../../../core/widgets/app_loader.dart';
import '../provider/hostellite_provider.dart';
import 'hostellite_item_card.dart';

class HostelliteItemsList extends StatelessWidget {
  const HostelliteItemsList({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<HostelliteProvider>();
    if (provider.isLoading) return const AppLoader();
    if (provider.items.isEmpty) {
      return Center(
        child: Text('No items found', style: TextStyle(color: AppColors.textMuted, fontSize: 13.sp)),
      );
    }
    return ListView.builder(
      padding: EdgeInsets.only(top: 10.h, bottom: 16.h),
      itemCount: provider.items.length,
      itemBuilder: (ctx, i) => HostelliteItemCard(item: provider.items[i]),
    );
  }
}
