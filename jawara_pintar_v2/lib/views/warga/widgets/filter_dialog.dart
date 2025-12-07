import 'package:flutter/material.dart';

class FilterWargaDialog extends StatefulWidget {
  final Map<String, String> initialFilters;

  const FilterWargaDialog({Key? key, required this.initialFilters})
    : super(key: key);

  @override
  State<FilterWargaDialog> createState() => _FilterWargaDialogState();
}

class _FilterWargaDialogState extends State<FilterWargaDialog> {
  late Map<String, String> _filters;
  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _nikController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _filters = Map.from(widget.initialFilters);
    _namaController.text = _filters['nama'] ?? '';
    _nikController.text = _filters['nik'] ?? '';
  }

  @override
  void dispose() {
    _namaController.dispose();
    _nikController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Filter Warga',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              // Nama
              TextField(
                controller: _namaController,
                decoration: const InputDecoration(
                  labelText: 'Nama',
                  hintText: 'Cari berdasarkan nama',
                  prefixIcon: Icon(Icons.person),
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  _filters['nama'] = value;
                },
              ),
              const SizedBox(height: 16),
              // NIK
              TextField(
                controller: _nikController,
                decoration: const InputDecoration(
                  labelText: 'NIK',
                  hintText: 'Cari berdasarkan NIK',
                  prefixIcon: Icon(Icons.badge),
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  _filters['nik'] = value;
                },
              ),
              const SizedBox(height: 16),
              // Jenis Kelamin
              DropdownButtonFormField<String>(
                value: _filters['jenisKelamin']?.isEmpty ?? true
                    ? null
                    : _filters['jenisKelamin'],
                decoration: const InputDecoration(
                  labelText: 'Jenis Kelamin',
                  prefixIcon: Icon(Icons.wc),
                  border: OutlineInputBorder(),
                ),
                items: const [
                  DropdownMenuItem(
                    value: 'Laki-laki',
                    child: Text('Laki-laki'),
                  ),
                  DropdownMenuItem(
                    value: 'Perempuan',
                    child: Text('Perempuan'),
                  ),
                ],
                onChanged: (value) {
                  setState(() {
                    if (value != null) {
                      _filters['jenisKelamin'] = value;
                    } else {
                      _filters.remove('jenisKelamin');
                    }
                  });
                },
              ),
              const SizedBox(height: 16),
              // Agama
              DropdownButtonFormField<String>(
                value: _filters['agama']?.isEmpty ?? true
                    ? null
                    : _filters['agama'],
                decoration: const InputDecoration(
                  labelText: 'Agama',
                  prefixIcon: Icon(Icons.church),
                  border: OutlineInputBorder(),
                ),
                items: const [
                  DropdownMenuItem(value: 'Islam', child: Text('Islam')),
                  DropdownMenuItem(value: 'Kristen', child: Text('Kristen')),
                  DropdownMenuItem(value: 'Katolik', child: Text('Katolik')),
                  DropdownMenuItem(value: 'Hindu', child: Text('Hindu')),
                  DropdownMenuItem(value: 'Buddha', child: Text('Buddha')),
                  DropdownMenuItem(value: 'Konghucu', child: Text('Konghucu')),
                ],
                onChanged: (value) {
                  setState(() {
                    if (value != null) {
                      _filters['agama'] = value;
                    } else {
                      _filters.remove('agama');
                    }
                  });
                },
              ),
              const SizedBox(height: 16),
              // Status Domisili
              DropdownButtonFormField<String>(
                value: _filters['statusDomisili']?.isEmpty ?? true
                    ? null
                    : _filters['statusDomisili'],
                decoration: const InputDecoration(
                  labelText: 'Status Domisili',
                  prefixIcon: Icon(Icons.home),
                  border: OutlineInputBorder(),
                ),
                items: const [
                  DropdownMenuItem(value: 'Tetap', child: Text('Tetap')),
                  DropdownMenuItem(value: 'Kontrak', child: Text('Kontrak')),
                  DropdownMenuItem(
                    value: 'Sementara',
                    child: Text('Sementara'),
                  ),
                ],
                onChanged: (value) {
                  setState(() {
                    if (value != null) {
                      _filters['statusDomisili'] = value;
                    } else {
                      _filters.remove('statusDomisili');
                    }
                  });
                },
              ),
              const SizedBox(height: 24),
              // Actions
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        setState(() {
                          _filters.clear();
                          _namaController.clear();
                          _nikController.clear();
                        });
                      },
                      child: const Text('Reset'),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context, _filters);
                      },
                      child: const Text('Terapkan'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
