import 'package:flutter/material.dart';
import '../sidebar/sidebar.dart';
import 'components/tabel_broadcast.dart';
import 'components/filter/filter_broadcast.dart';

class BroadcastDaftarPage extends StatefulWidget {
  const BroadcastDaftarPage({super.key});

  @override
  State<BroadcastDaftarPage> createState() => _BroadcastDaftarPage();
}

class _BroadcastDaftarPage extends State<BroadcastDaftarPage> {
  final Map<String, String> _filters = {};

  void _onFilterApplied(Map<String, String> filters) {
    setState(() {
      _filters.clear();
      _filters.addAll(filters);
    });
  }

  void _onFilterReset() {
    setState(() {
      _filters.clear();
    });
  }

  void _showFilterDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return FilterBroadcastDialog(
          onFilterApplied: _onFilterApplied,
          onFilterReset: _onFilterReset,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFF),
      appBar: AppBar(
        title: const Text(
          'Data Warga - Daftar',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
        iconTheme: const IconThemeData(color: Colors.black),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () => _showFilterDialog(context),
          ),
        ],
      ),
      drawer: const Sidebar(userEmail: 'admin@jawara.com'),
      body: TabelBroadcast(filters: _filters),
    );
  }
}
