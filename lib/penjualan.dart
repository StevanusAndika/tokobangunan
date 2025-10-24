import 'package:flutter/material.dart';

class PenjualanScreen extends StatefulWidget {
  @override
  _PenjualanScreenState createState() => _PenjualanScreenState();
}

class _PenjualanScreenState extends State<PenjualanScreen> {
  List<Map<String, dynamic>> _penjualanData = [
    {'id': 1, 'tanggal': '15 Mar 2024', 'produk': 'Semen + Paku', 'harga': 'Rp 650.000', 'total': 'Rp 2.600.000', 'qty': '4'},
    {'id': 2, 'tanggal': '14 Mar 2024', 'produk': 'Cat Tembok', 'harga': 'Rp 185.000', 'total': 'Rp 925.000', 'qty': '5'},
    {'id': 3, 'tanggal': '13 Mar 2024', 'produk': 'Keramik', 'harga': 'Rp 45.000', 'total': 'Rp 1.350.000', 'qty': '30'},
    {'id': 4, 'tanggal': '12 Mar 2024', 'produk': 'Pipa PVC', 'harga': 'Rp 35.000', 'total': 'Rp 700.000', 'qty': '20'},
    {'id': 5, 'tanggal': '11 Mar 2024', 'produk': 'Paket Bangunan', 'harga': 'Rp 2.500.000', 'total': 'Rp 5.000.000', 'qty': '2'},
  ];

  void _showDetailPenjualan(Map<String, dynamic> penjualan) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Detail Penjualan'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDetailItem('Tanggal', penjualan['tanggal']),
              _buildDetailItem('Produk', penjualan['produk']),
              _buildDetailItem('Harga Satuan', penjualan['harga']),
              _buildDetailItem('Quantity', penjualan['qty']),
              _buildDetailItem('Total', penjualan['total']),
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

  void _showTambahPenjualan() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Tambah Penjualan Baru'),
        content: SingleChildScrollView(
          child: Column(
            children: [
              TextField(decoration: InputDecoration(labelText: 'Tanggal')),
              TextField(decoration: InputDecoration(labelText: 'Produk')),
              TextField(decoration: InputDecoration(labelText: 'Harga')),
              TextField(decoration: InputDecoration(labelText: 'Quantity')),
              TextField(decoration: InputDecoration(labelText: 'Total')),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              // Logic untuk tambah data
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Penjualan baru berhasil ditambahkan')),
              );
            },
            child: Text('Simpan'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: _showTambahPenjualan,
        backgroundColor: Colors.blue.shade700,
        child: Icon(Icons.add, color: Colors.white),
      ),
      body: Container(
        padding: EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.shopping_cart, size: 32, color: Colors.blue.shade700),
                SizedBox(width: 12),
                Text(
                  'Data Penjualan',
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
              'Kelola data penjualan toko bangunan',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey.shade600,
              ),
            ),
            SizedBox(height: 24),
            // Tabel Penjualan
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
                            Expanded(child: Text('Tanggal', style: TextStyle(fontWeight: FontWeight.bold))),
                            Expanded(flex: 2, child: Text('Produk', style: TextStyle(fontWeight: FontWeight.bold))),
                            Expanded(child: Text('Harga', style: TextStyle(fontWeight: FontWeight.bold))),
                            Expanded(child: Text('Qty', style: TextStyle(fontWeight: FontWeight.bold))),
                            Expanded(child: Text('Total', style: TextStyle(fontWeight: FontWeight.bold))),
                            Expanded(child: Text('Aksi', style: TextStyle(fontWeight: FontWeight.bold))),
                          ],
                        ),
                      ),
                      SizedBox(height: 8),
                      // Data Tabel
                      Expanded(
                        child: ListView.builder(
                          itemCount: _penjualanData.length,
                          itemBuilder: (context, index) {
                            final penjualan = _penjualanData[index];
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
                                  Expanded(child: Text(penjualan['tanggal'])),
                                  Expanded(flex: 2, child: Text(penjualan['produk'])),
                                  Expanded(child: Text(penjualan['harga'])),
                                  Expanded(child: Text(penjualan['qty'])),
                                  Expanded(child: Text(penjualan['total'])),
                                  Expanded(
                                    child: Row(
                                      children: [
                                        IconButton(
                                          icon: Icon(Icons.visibility, size: 18, color: Colors.blue),
                                          onPressed: () => _showDetailPenjualan(penjualan),
                                        ),
                                        IconButton(
                                          icon: Icon(Icons.edit, size: 18, color: Colors.orange),
                                          onPressed: () {},
                                        ),
                                        IconButton(
                                          icon: Icon(Icons.delete, size: 18, color: Colors.red),
                                          onPressed: () {
                                            setState(() {
                                              _penjualanData.removeAt(index);
                                            });
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              SnackBar(content: Text('Data penjualan berhasil dihapus')),
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