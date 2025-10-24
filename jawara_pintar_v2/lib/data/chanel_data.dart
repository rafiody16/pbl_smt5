import '../model/chanel_transfer.dart';

class ChanelData {
  
  static List<ChanelTransfer> chanels = [
    ChanelTransfer(
      id: '1',
      nama: 'Dana',
      tipe: 'Ewallet',
      nomorAkun: '081234567890',
      namaPemilik: 'Budi Santoso',
      catatan: 'Catatan untuk transfer Dana',
    ),
    ChanelTransfer(
      id: '2',
      nama: 'QRIS Resmi RT 08',
      tipe: 'qris',
      nomorAkun: 'N/A',
      namaPemilik: 'RW 08 Karangkoloso',
      thumbnailUrl: 'https://i.imgur.com/gA3tFvD.png', 
      qrUrl: 'https://i.imgur.com/gA3tFvD.png',
      catatan: 'QRIS untuk kas RT',
    ),
    
    ChanelTransfer(
      id: '3',
      nama: 'BCA Bendahara',
      tipe: 'bank',
      nomorAkun: '8989898989',
      namaPemilik: 'Jose Rizal',
      thumbnailUrl: null, 
      catatan: 'Transfer bank BCA atas nama bendahara',
    ),

    ChanelTransfer(
      id: '4',
      nama: 'GoPay',
      tipe: 'ewallet',
      nomorAkun: '089876543210',
      namaPemilik: 'Siti Aminah',
    ),
    
    ChanelTransfer(
      id: '5',
      nama: 'Bank Mandiri Kas RT',
      tipe: 'bank',
      nomorAkun: '123456789',
      namaPemilik: 'RT Jawara Karangkoloso',
      catatan: 'Rekening kas RT Bank Mandiri',
    ),
  ];
}