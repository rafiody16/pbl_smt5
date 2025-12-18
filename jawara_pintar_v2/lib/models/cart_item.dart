import 'produk.dart';

class CartItem {
  final String id;
  final Produk produk;
  int quantity;

  CartItem({required this.id, required this.produk, this.quantity = 1});
}
