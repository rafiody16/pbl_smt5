import 'package:flutter/material.dart';
import '../../../../data/data_broadcast.dart';
import 'tabel_content.dart';

class BroadcastList extends StatefulWidget {
  final Map<String, String> filters;
  final ScrollController scrollController;

  const BroadcastList({
    super.key,
    required this.filters,
    required this.scrollController,
  });

  @override
  State<BroadcastList> createState() => _BroadcastListState();
}

class _BroadcastListState extends State<BroadcastList> {
  List<Map<String, dynamic>> get _filteredData {
    List<Map<String, dynamic>> allBroadcast = BroadcastData.semuaDataBroadcast;

    if (widget.filters.isEmpty) return allBroadcast;

    return allBroadcast.where((broadcast) {
      if (widget.filters.containsKey('judul') &&
          widget.filters['judul']!.isNotEmpty &&
          !broadcast['judul'].toString().toLowerCase().contains(
            widget.filters['judul']!.toLowerCase(),
          )) {
        return false;
      }
      return true;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final filteredData = _filteredData;

    return ListContent(
      filteredData: filteredData,
      scrollController: widget.scrollController,
      totalBroadcast: filteredData.length,
    );
  }
}
