import 'package:flutter/material.dart';
import '../models/produk.dart';
import '../models/cart_item.dart';

class CartProvider with ChangeNotifier {
  // Menggunakan Map agar mudah mencari produk berdasarkan ID-nya
  Map<String, CartItem> _items = {};

  Map<String, CartItem> get items => {..._items};

  // Menghitung jumlah jenis produk di keranjang
  int get itemCount => _items.length;

  // Menghitung total harga belanjaan
  double get totalAmount {
    double total = 0.0;
    _items.forEach((key, cartItem) {
      total += cartItem.produk.harga * cartItem.quantity;
    });
    return total;
  }

  void addItem(Produk produk, int quantity) {
    if (_items.containsKey(produk.id.toString())) {
      // Jika barang sudah ada, tambah jumlahnya saja
      _items.update(
        produk.id.toString(),
        (existingItem) => CartItem(
          id: existingItem.id,
          produk: existingItem.produk,
          quantity: existingItem.quantity + quantity,
        ),
      );
    } else {
      // Jika barang belum ada, tambah data baru
      _items.putIfAbsent(
        produk.id.toString(),
        () => CartItem(
          id: DateTime.now().toString(),
          produk: produk,
          quantity: quantity,
        ),
      );
    }
    notifyListeners(); // Memberitahu UI untuk update
  }

  // Mengurangi jumlah 1 per 1
  void removeSingleItem(String productId) {
    if (!_items.containsKey(productId)) return;
    if (_items[productId]!.quantity > 1) {
      _items.update(
        productId,
        (existing) => CartItem(
          id: existing.id,
          produk: existing.produk,
          quantity: existing.quantity - 1,
        ),
      );
    } else {
      _items.remove(productId);
    }
    notifyListeners();
  }

  // Menghapus produk sepenuhnya dari keranjang
  void removeItem(String productId) {
    _items.remove(productId);
    notifyListeners();
  }

  void clearCart() {
    _items = {};
    notifyListeners();
  }
}
