import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../models/produk.dart';
import '../../providers/transaction_provider.dart';
import '../../providers/auth_provider.dart';

class CheckoutPage extends StatelessWidget {
  final Produk produk;
  final int jumlahBeli;

  const CheckoutPage({Key? key, required this.produk, required this.jumlahBeli})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final wargaData = authProvider.wargaData;

    // 🔐 VALIDASI DATA LOGIN
    if (wargaData == null || !wargaData.containsKey('nik')) {
      return const Scaffold(
        body: Center(
          child: Text(
            "Data warga tidak ditemukan.\nSilakan login ulang.",
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    final String userNik = wargaData['nik'];
    final double totalHarga = produk.harga * jumlahBeli;

    final currency = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );

    return Scaffold(
      appBar: AppBar(title: const Text("Konfirmasi Pesanan")),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _buildSectionTitle("Barang yang Dibeli"),
                ListTile(
                  leading: Image.network(
                    produk.gambarUrl ?? '',
                    width: 50,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) =>
                        const Icon(Icons.image_not_supported),
                  ),
                  title: Text(produk.namaProduk),
                  subtitle: Text(
                    "$jumlahBeli item x ${currency.format(produk.harga)}",
                  ),
                  trailing: Text(currency.format(totalHarga)),
                ),
                const Divider(),
                _buildSectionTitle("Informasi Pembeli (Warga)"),
                ListTile(
                  leading: const Icon(Icons.person_outline),
                  title: const Text("NIK Anda"),
                  subtitle: Text(userNik),
                ),
              ],
            ),
          ),
          _buildBottomBar(context, totalHarga, userNik),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
      ),
    );
  }

  Widget _buildBottomBar(BuildContext context, double total, String userNik) {
    final currency = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)],
      ),
      child: Consumer<TransactionProvider>(
        builder: (context, transProvider, _) {
          return ElevatedButton(
            onPressed: transProvider.isLoading
                ? null
                : () async {
                    final success = await transProvider.checkout(
                      buyerNik: userNik, // ✅ NIK USER LOGIN
                      totalHarga: total,
                      items: [
                        {
                          'product_id': produk.id,
                          'jumlah': jumlahBeli,
                          'harga_satuan': produk.harga,
                          'stok_sekarang': produk.stok,
                        },
                      ],
                    );

                    if (success && context.mounted) {
                      _showSuccess(context);
                    }
                  },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              minimumSize: const Size(double.infinity, 50),
            ),
            child: transProvider.isLoading
                ? const CircularProgressIndicator(color: Colors.white)
                : Text("BAYAR SEKARANG - ${currency.format(total)}"),
          );
        },
      ),
    );
  }

  void _showSuccess(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        title: const Text("Transaksi Berhasil"),
        content: const Text(
          "Pesanan Anda telah dicatat. Silakan cek riwayat pesanan.",
        ),
        actions: [
          TextButton(
            onPressed: () =>
                Navigator.of(context).popUntil((route) => route.isFirst),
            child: const Text("Selesai"),
          ),
        ],
      ),
    );
  }
}
