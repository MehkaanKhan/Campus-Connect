import 'dart:async';
import 'package:flutter/material.dart';
import '../../domain/entities/cart_item_entity.dart';
import '../../domain/usecases/add_to_cart_usecase.dart';
import '../../domain/usecases/remove_from_cart_usecase.dart';
import '../../domain/repositories/cart_repository.dart';

class CartProvider extends ChangeNotifier {
  final CartRepository _repo;
  final AddToCartUsecase _addUsecase;
  final RemoveFromCartUsecase _removeUsecase;

  Timer? _checkoutTimer;
  Duration _checkoutCountdown = Duration.zero;

  CartProvider({
    required CartRepository repo,
    required AddToCartUsecase addUsecase,
    required RemoveFromCartUsecase removeUsecase,
  })  : _repo = repo,
        _addUsecase = addUsecase,
        _removeUsecase = removeUsecase;

  List<CartItemEntity> get items => _repo.getItems();
  Duration get checkoutCountdown => _checkoutCountdown;
  bool get isTimerActive => _checkoutTimer?.isActive ?? false;

  int get totalItems => items.fold(0, (sum, e) => sum + e.quantity);
  double get totalPrice => items.fold(0, (sum, e) => sum + e.total);

  void addItem(CartItemEntity item) {
    _addUsecase(item);
    notifyListeners();
  }

  void removeItem(String id) {
    _removeUsecase(id);
    notifyListeners();
  }

  void updateQuantity(String id, int quantity) {
    _repo.updateQuantity(id, quantity);
    notifyListeners();
  }

  void clearCart() {
    _repo.clearCart();
    _cancelTimer();
    notifyListeners();
  }

  /// Starts a countdown timer (e.g. reservation window before checkout expires).
  void startCheckoutTimer({Duration duration = const Duration(minutes: 10)}) {
    _checkoutCountdown = duration;
    _checkoutTimer?.cancel();
    _checkoutTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (_checkoutCountdown.inSeconds <= 0) {
        _cancelTimer();
        clearCart();
      } else {
        _checkoutCountdown -= const Duration(seconds: 1);
        notifyListeners();
      }
    });
    notifyListeners();
  }

  void _cancelTimer() {
    _checkoutTimer?.cancel();
    _checkoutTimer = null;
    _checkoutCountdown = Duration.zero;
  }

  @override
  void dispose() {
    _cancelTimer();
    super.dispose();
  }
}
