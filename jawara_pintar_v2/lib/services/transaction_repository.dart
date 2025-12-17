import 'package:supabase_flutter/supabase_flutter.dart';

class TransactionRepository {
  final _supabase = Supabase.instance.client;

  Future<void> createTransaction({
    required String buyerNik,
    required double totalHarga,
    required List<Map<String, dynamic>> items,
  }) async {
    try {
      // 1. Insert ke tabel mp_orders (Header)
      final orderResponse = await _supabase
          .from('mp_orders')
          .insert({
            'buyer_nik': buyerNik,
            'total_harga': totalHarga,
            'status': 'Menunggu Pembayaran',
            'tanggal_pesan': DateTime.now().toIso8601String(),
          })
          .select()
          .single();

      final int orderId = orderResponse['id'];

      // 2. Insert ke tabel mp_order_items (Detail) & Update Stok
      for (var item in items) {
        // Simpan rincian item
        await _supabase.from('mp_order_items').insert({
          'order_id': orderId,
          'product_id': item['product_id'],
          'jumlah': item['jumlah'],
          'harga_satuan': item['harga_satuan'],
        });

        // Update stok di mp_products (Stok berkurang)
        await _supabase
            .from('mp_products')
            .update({'stok': item['stok_sekarang'] - item['jumlah']})
            .eq('id', item['product_id']);
      }
    } catch (e) {
      throw Exception("Gagal memproses transaksi: $e");
    }
  }
}
