class ChanelTransfer {
  final String id;
  final String nama;
  final String tipe;
  final String nomorAkun;
  final String namaPemilik;
  final String? thumbnailUrl;
  final String? qrUrl;
  final String? catatan;

  ChanelTransfer({
    required this.id,
    required this.nama,
    required this.tipe,
    required this.nomorAkun,
    required this.namaPemilik,
    this.thumbnailUrl,
    this.qrUrl,
    this.catatan,
  });
}