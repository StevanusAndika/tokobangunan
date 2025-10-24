import 'package:flutter/material.dart';

class ProdukScreen extends StatefulWidget {
  @override
  _ProdukScreenState createState() => _ProdukScreenState();
}

class _ProdukScreenState extends State<ProdukScreen> {
  List<Map<String, dynamic>> _produkData = [
    {'id': 1, 'nama': 'Semen Tiga Roda 50kg', 'harga': 'Rp 65.000', 'stok': '150', 'kategori': 'Material Bangunan'},
    {'id': 2, 'nama': 'Paku Beton 3 inch', 'harga': 'Rp 25.000', 'stok': '200', 'kategori': 'Material Bangunan'},
    {'id': 3, 'nama': 'Cat Tembok Dulux 5L', 'harga': 'Rp 185.000', 'stok': '45', 'kategori': 'Cat'},
    {'id': 4, 'nama': 'Keramik 40x40 cm', 'harga': 'Rp 45.000', 'stok': '300', 'kategori': 'Lantai'},
    {'id': 5, 'nama': 'Pipa PVC 3/4"', 'harga': 'Rp 35.000', 'stok': '120', 'kategori': 'Pipa'},
  ];

  void _showDetailProduk(Map<String, dynamic> produk) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Detail Produk'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDetailItem('Nama Produk', produk['nama']),
              _buildDetailItem('Harga', produk['harga']),
              _buildDetailItem('Stok', produk['stok']),
              _buildDetailItem('Kategori', produk['kategori']),
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

  void _showTambahProduk() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Tambah Produk Baru'),
        content: SingleChildScrollView(
          child: Column(
            children: [
              TextField(decoration: InputDecoration(labelText: 'Nama Produk')),
              TextField(decoration: InputDecoration(labelText: 'Harga')),
              TextField(decoration: InputDecoration(labelText: 'Stok')),
              TextField(decoration: InputDecoration(labelText: 'Kategori')),
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
                SnackBar(content: Text('Produk baru berhasil ditambahkan')),
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
        onPressed: _showTambahProduk,
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
                Icon(Icons.inventory_2, size: 32, color: Colors.blue.shade700),
                SizedBox(width: 12),
                Text(
                  'Data Produk',
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
              'Kelola data produk toko bangunan',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey.shade600,
              ),
            ),
            SizedBox(height: 24),
            // Tabel Produk
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
                            Expanded(flex: 3, child: Text('Nama Produk', style: TextStyle(fontWeight: FontWeight.bold))),
                            Expanded(child: Text('Harga', style: TextStyle(fontWeight: FontWeight.bold))),
                            Expanded(child: Text('Stok', style: TextStyle(fontWeight: FontWeight.bold))),
                            Expanded(flex: 2, child: Text('Kategori', style: TextStyle(fontWeight: FontWeight.bold))),
                            Expanded(child: Text('Aksi', style: TextStyle(fontWeight: FontWeight.bold))),
                          ],
                        ),
                      ),
                      SizedBox(height: 8),
                      // Data Tabel
                      Expanded(
                        child: ListView.builder(
                          itemCount: _produkData.length,
                          itemBuilder: (context, index) {
                            final produk = _produkData[index];
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
                                  Expanded(flex: 3, child: Text(produk['nama'])),
                                  Expanded(child: Text(produk['harga'])),
                                  Expanded(child: Text(produk['stok'])),
                                  Expanded(flex: 2, child: Text(produk['kategori'])),
                                  Expanded(
                                    child: Row(
                                      children: [
                                        IconButton(
                                          icon: Icon(Icons.visibility, size: 18, color: Colors.blue),
                                          onPressed: () => _showDetailProduk(produk),
                                        ),
                                        IconButton(
                                          icon: Icon(Icons.edit, size: 18, color: Colors.orange),
                                          onPressed: () {},
                                        ),
                                        IconButton(
                                          icon: Icon(Icons.delete, size: 18, color: Colors.red),
                                          onPressed: () {
                                            setState(() {
                                              _produkData.removeAt(index);
                                            });
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              SnackBar(content: Text('Produk berhasil dihapus')),
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