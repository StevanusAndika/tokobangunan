import 'package:flutter/material.dart';

class LaporanPenjualanScreen extends StatefulWidget {
  @override
  _LaporanPenjualanScreenState createState() => _LaporanPenjualanScreenState();
}

class _LaporanPenjualanScreenState extends State<LaporanPenjualanScreen> {
  List<Map<String, dynamic>> _laporanData = [
    {'id': 1, 'periode': 'Maret 2024', 'total_penjualan': 'Rp 45.000.000', 'produk_terlaris': 'Semen Tiga Roda', 'transaksi': '156', 'pertumbuhan': '+12%'},
    {'id': 2, 'periode': 'Februari 2024', 'total_penjualan': 'Rp 40.000.000', 'produk_terlaris': 'Cat Tembok', 'transaksi': '142', 'pertumbuhan': '+8%'},
    {'id': 3, 'periode': 'Januari 2024', 'total_penjualan': 'Rp 37.000.000', 'produk_terlaris': 'Keramik', 'transaksi': '135', 'pertumbuhan': '+15%'},
    {'id': 4, 'periode': 'Desember 2023', 'total_penjualan': 'Rp 32.000.000', 'produk_terlaris': 'Pipa PVC', 'transaksi': '128', 'pertumbuhan': '+5%'},
    {'id': 5, 'periode': 'November 2023', 'total_penjualan': 'Rp 30.500.000', 'produk_terlaris': 'Semen Tiga Roda', 'transaksi': '121', 'pertumbuhan': '+3%'},
  ];

  void _showDetailLaporan(Map<String, dynamic> laporan) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Detail Laporan'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDetailItem('Periode', laporan['periode']),
              _buildDetailItem('Total Penjualan', laporan['total_penjualan']),
              _buildDetailItem('Produk Terlaris', laporan['produk_terlaris']),
              _buildDetailItem('Jumlah Transaksi', laporan['transaksi']),
              _buildDetailItem('Pertumbuhan', laporan['pertumbuhan']),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Tutup'),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailItem(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue.shade700),
          ),
          SizedBox(height: 4),
          Text(value),
          SizedBox(height: 8),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.analytics, size: 32, color: Colors.blue.shade700),
                SizedBox(width: 12),
                Text(
                  'Laporan Penjualan',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue.shade700,
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
            Text(
              'Analisis dan laporan penjualan toko bangunan',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey.shade600,
              ),
            ),
            SizedBox(height: 24),
            // Tabel Laporan
            Expanded(
              child: Card(
                elevation: 4,
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    children: [
                      // Header Tabel
                      Container(
                        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade50,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            Expanded(flex: 2, child: Text('Periode', style: TextStyle(fontWeight: FontWeight.bold))),
                            Expanded(flex: 2, child: Text('Total Penjualan', style: TextStyle(fontWeight: FontWeight.bold))),
                            Expanded(flex: 2, child: Text('Produk Terlaris', style: TextStyle(fontWeight: FontWeight.bold))),
                            Expanded(child: Text('Transaksi', style: TextStyle(fontWeight: FontWeight.bold))),
                            Expanded(child: Text('Pertumbuhan', style: TextStyle(fontWeight: FontWeight.bold))),
                            Expanded(child: Text('Aksi', style: TextStyle(fontWeight: FontWeight.bold))),
                          ],
                        ),
                      ),
                      SizedBox(height: 8),
                      // Data Tabel
                      Expanded(
                        child: ListView.builder(
                          itemCount: _laporanData.length,
                          itemBuilder: (context, index) {
                            final laporan = _laporanData[index];
                            return Container(
                              margin: EdgeInsets.only(bottom: 8),
                              padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: Colors.grey.shade200),
                              ),
                              child: Row(
                                children: [
                                  Expanded(flex: 2, child: Text(laporan['periode'])),
                                  Expanded(flex: 2, child: Text(laporan['total_penjualan'])),
                                  Expanded(flex: 2, child: Text(laporan['produk_terlaris'])),
                                  Expanded(child: Text(laporan['transaksi'])),
                                  Expanded(
                                    child: Text(
                                      laporan['pertumbuhan'],
                                      style: TextStyle(
                                        color: laporan['pertumbuhan'].contains('+') ? Colors.green : Colors.red,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Row(
                                      children: [
                                        IconButton(
                                          icon: Icon(Icons.visibility, size: 18, color: Colors.blue),
                                          onPressed: () => _showDetailLaporan(laporan),
                                        ),
                                        IconButton(
                                          icon: Icon(Icons.picture_as_pdf, size: 18, color: Colors.red),
                                          onPressed: () {
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              SnackBar(content: Text('Membuat PDF laporan...')),
                                            );
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}