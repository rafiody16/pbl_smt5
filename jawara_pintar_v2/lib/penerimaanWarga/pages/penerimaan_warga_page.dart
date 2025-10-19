import 'package:flutter/material.dart';
import '../../sidebar/sidebar.dart';
import '../components/tabel/tabel_penerimaan_warga.dart';
import '../components/filter/filter_penerimaan_warga.dart';

class PenerimaanWargaPage extends StatefulWidget {
  const PenerimaanWargaPage({super.key});

  @override
  State<PenerimaanWargaPage> createState() => _PenerimaanWargaPageState();
}

class _PenerimaanWargaPageState extends State<PenerimaanWargaPage> {
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
        return FilterPenerimaanWargaDialog(
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
          'Penerimaan Warga',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
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
      body: TabelPenerimaanWarga(filters: _filters),
    );
  }
}