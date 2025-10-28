import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ProdukScreen extends StatefulWidget {
  const ProdukScreen({super.key});

  @override
  _ProdukScreenState createState() => _ProdukScreenState();
}

class _ProdukScreenState extends State<ProdukScreen> {
  List<dynamic> _produkData = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final response = await http.get(Uri.parse('http://127.0.0.1:8000/api/produk/list-data'));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _produkData = data['data'];
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      _showSnackBar('Error: $e');
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  void _showDeleteConfirmation(int id, String nama) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Hapus Produk',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.blue.shade700,
          ),
        ),
        content: Text('Yakin ingin menghapus "$nama"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            style: TextButton.styleFrom(
              foregroundColor: Colors.grey.shade600,
            ),
            child: Text('Tidak'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _deleteProduk(id);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red.shade600,
              foregroundColor: Colors.white,
            ),
            child: Text('Ya'),
          ),
        ],
      ),
    );
  }

  Future<void> _deleteProduk(int id) async {
    try {
      final response = await http.delete(
        Uri.parse('http://127.0.0.1:8000/api/produk/hapus/$id'),
      );
      
      if (response.statusCode == 200) {
        _showSnackBar('Produk berhasil dihapus');
        _loadData();
      }
    } catch (e) {
      _showSnackBar('Error: $e');
    }
  }

  Widget _buildProdukTable() {
    return Card(
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
                  Expanded(flex: 1, child: Text('No', style: TextStyle(fontWeight: FontWeight.bold))),
                  Expanded(flex: 3, child: Text('Nama Produk', style: TextStyle(fontWeight: FontWeight.bold))),
                  Expanded(flex: 2, child: Text('Harga', style: TextStyle(fontWeight: FontWeight.bold))),
                  Expanded(flex: 1, child: Text('Stok', style: TextStyle(fontWeight: FontWeight.bold))),
                  Expanded(flex: 1, child: Text('Aksi', style: TextStyle(fontWeight: FontWeight.bold))),
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
                        Expanded(flex: 1, child: Text('${index + 1}')),
                        Expanded(flex: 3, child: Text(produk['Produk'] ?? 'No Name')),
                        Expanded(flex: 2, child: Text('Rp ${_formatCurrency(produk['Harga'])}')),
                        Expanded(flex: 1, child: Text(produk['Stok']?.toString() ?? '0')),
                        Expanded(
                          flex: 1,
                          child: Row(
                            children: [
                              IconButton(
                                icon: Icon(Icons.edit, size: 18, color: Colors.orange.shade600),
                                onPressed: () => _showFormProduk(produk: produk),
                              ),
                              IconButton(
                                icon: Icon(Icons.delete, size: 18, color: Colors.red.shade600),
                                onPressed: () => _showDeleteConfirmation(produk['id'], produk['Produk']),
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
    );
  }

  String _formatCurrency(dynamic value) {
    if (value == null) return '0';
    
    // Format number dengan pemisah ribuan
    final number = double.tryParse(value.toString()) ?? 0;
    return number.toStringAsFixed(0).replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]}.',
    );
  }

  void _showFormProduk({Map<String, dynamic>? produk}) {
    TextEditingController namaController = TextEditingController(text: produk?['Produk'] ?? '');
    TextEditingController hargaController = TextEditingController(
      text: produk?['Harga'] != null ? _formatCurrency(produk!['Harga']) : ''
    );
    TextEditingController stokController = TextEditingController(text: produk?['Stok']?.toString() ?? '');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          produk == null ? 'Tambah Produk' : 'Edit Produk',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.blue.shade700,
          ),
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // ID tidak ditampilkan - sistem yang generate otomatis
              TextField(
                controller: namaController,
                decoration: InputDecoration(
                  labelText: 'Nama Produk',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),
              TextField(
                controller: hargaController,
                decoration: InputDecoration(
                  labelText: 'Harga',
                  border: OutlineInputBorder(),
                  prefixText: 'Rp ',
                ),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  // Format input harga
                  final numericValue = value.replaceAll(RegExp(r'[^\d]'), '');
                  if (numericValue.isNotEmpty) {
                    final number = int.parse(numericValue);
                    hargaController.value = TextEditingValue(
                      text: _formatCurrency(number),
                      selection: TextSelection.collapsed(offset: _formatCurrency(number).length),
                    );
                  }
                },
              ),
              SizedBox(height: 16),
              TextField(
                controller: stokController,
                decoration: InputDecoration(
                  labelText: 'Stok',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            style: TextButton.styleFrom(
              foregroundColor: Colors.grey.shade600,
            ),
            child: Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              if (namaController.text.isEmpty) {
                _showSnackBar('Nama produk harus diisi');
                return;
              }
              if (hargaController.text.isEmpty) {
                _showSnackBar('Harga harus diisi');
                return;
              }
              if (stokController.text.isEmpty) {
                _showSnackBar('Stok harus diisi');
                return;
              }

              _saveProduk(
                id: produk?['id'],
                nama: namaController.text,
                harga: hargaController.text.replaceAll('.', ''),
                stok: stokController.text,
                isEdit: produk != null,
              );
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue.shade700,
            ),
            child: Text('Simpan'),
          ),
        ],
      ),
    );
  }

  Future<void> _saveProduk({
    int? id,
    required String nama,
    required String harga,
    required String stok,
    required bool isEdit,
  }) async {
    try {
      final Map<String, dynamic> body = {
        'Produk': nama,
        'Harga': harga,
        'Stok': stok,
      };

      if (isEdit && id != null) {
        body['id'] = id.toString();
      }

      final response = await http.post(
        Uri.parse('http://127.0.0.1:8000/api/produk/simpan'),
        body: body,
      );

      final responseData = json.decode(response.body);
      if (response.statusCode == 200 || response.statusCode == 201) {
        _showSnackBar(responseData['message']);
        _loadData();
      } else {
        _showSnackBar(responseData['message'] ?? 'Terjadi kesalahan');
      }
    } catch (e) {
      _showSnackBar('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showFormProduk(),
        backgroundColor: Colors.blue.shade700,
        child: Icon(Icons.add, color: Colors.white),
      ),
      body: Container(
        padding: EdgeInsets.all(16),
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
            Expanded(
              child: _isLoading
                  ? Center(child: CircularProgressIndicator())
                  : _produkData.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.inventory_2_outlined, size: 64, color: Colors.grey.shade400),
                              SizedBox(height: 16),
                              Text(
                                'Belum ada data produk',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: const Color.fromARGB(255, 255, 255, 255),
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                'Klik tombol + untuk menambah produk',
                                style: TextStyle(
                                  color: const Color.fromARGB(255, 252, 252, 252),
                                ),
                              ),
                            ],
                          ),
                        )
                      : _buildProdukTable(),
            ),
          ],
        ),
      ),
    );
  }
}
