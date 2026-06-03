import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_assets.dart';
import '../../../../core/constants/app_colors.dart';
import '../../domain/entities/cart_item_entity.dart';
import '../provider/cart_provider.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cart'),
        actions: [
          if (cart.items.isNotEmpty)
            TextButton(
              onPressed: cart.clearCart,
              child: const Text('Clear', style: TextStyle(color: Colors.white)),
            ),
        ],
      ),
      body: cart.items.isEmpty
          ? const _EmptyCart()
          : Column(
              children: [
                if (cart.isTimerActive) _CountdownBanner(countdown: cart.checkoutCountdown),
                Expanded(
                  child: ListView.builder(
                    itemCount: cart.items.length,
                    itemBuilder: (ctx, i) => _CartItemTile(item: cart.items[i]),
                  ),
                ),
                _CartSummary(cart: cart),
              ],
            ),
    );
  }
}

class _EmptyCart extends StatelessWidget {
  const _EmptyCart();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(AppAssets.iconShoppingCart, width: 72, height: 72, colorFilter: const ColorFilter.mode(AppColors.textSecondary, BlendMode.srcIn)),
          const SizedBox(height: 16),
          const Text('Your cart is empty'),
        ],
      ),
    );
  }
}

class _CartItemTile extends StatelessWidget {
  final CartItemEntity item;
  const _CartItemTile({required this.item});

  @override
  Widget build(BuildContext context) {
    final cart = context.read<CartProvider>();
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: ListTile(
        title: Text(item.name),
        subtitle: Text('\$${item.price.toStringAsFixed(2)}'),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.remove_circle_outline),
              onPressed: () => cart.updateQuantity(item.id, item.quantity - 1),
            ),
            Text('${item.quantity}', style: const TextStyle(fontWeight: FontWeight.bold)),
            IconButton(
              icon: const Icon(Icons.add_circle_outline),
              onPressed: () => cart.updateQuantity(item.id, item.quantity + 1),
            ),
            IconButton(
              icon: SvgPicture.asset(AppAssets.iconTrash, width: 22, height: 22, colorFilter: const ColorFilter.mode(AppColors.error, BlendMode.srcIn)),
              onPressed: () => cart.removeItem(item.id),
            ),
          ],
        ),
      ),
    );
  }
}

class _CartSummary extends StatelessWidget {
  final CartProvider cart;
  const _CartSummary({required this.cart});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 8, offset: const Offset(0, -2))],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Total (${cart.totalItems} items)', style: const TextStyle(fontWeight: FontWeight.w600)),
              Text('\$${cart.totalPrice.toStringAsFixed(2)}',
                  style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary, fontSize: 18)),
            ],
          ),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: () => cart.startCheckoutTimer(),
            child: const Text('Proceed to Checkout'),
          ),
        ],
      ),
    );
  }
}

class _CountdownBanner extends StatelessWidget {
  final Duration countdown;
  const _CountdownBanner({required this.countdown});

  @override
  Widget build(BuildContext context) {
    final mins = countdown.inMinutes.toString().padLeft(2, '0');
    final secs = (countdown.inSeconds % 60).toString().padLeft(2, '0');
    return Container(
      color: AppColors.accent,
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Center(
        child: Text(
          'Cart reserved for $mins:$secs',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
