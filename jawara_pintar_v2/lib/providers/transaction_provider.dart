import 'package:flutter/material.dart';
import '../services/transaction_repository.dart';

class TransactionProvider with ChangeNotifier {
  final _repo = TransactionRepository();
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<bool> checkout({
    required String buyerNik,
    required double totalHarga,
    required List<Map<String, dynamic>> items,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      await _repo.createTransaction(
        buyerNik: buyerNik,
        totalHarga: totalHarga,
        items: items,
      );
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }
}
