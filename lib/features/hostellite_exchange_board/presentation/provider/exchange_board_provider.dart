import 'package:flutter/material.dart';

class ExchangeBoardProvider extends ChangeNotifier {
  bool _isSubmitting = false;
  bool get isSubmitting => _isSubmitting;

  Future<bool> submitComplaint(String itemId, String reason, String details) async {
    _isSubmitting = true;
    notifyListeners();

    // Simulate network delay
    await Future.delayed(const Duration(seconds: 2));

    _isSubmitting = false;
    notifyListeners();

    // Simulate success
    return true;
  }
}
