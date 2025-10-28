import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class PenjualanScreen extends StatefulWidget {
  const PenjualanScreen({super.key});

  @override
  _PenjualanScreenState createState() => _PenjualanScreenState();
}

class _PenjualanScreenState extends State<PenjualanScreen> {
  List<dynamic> _penjualanData = [];
  List<dynamic> _karyawanData = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final [penjualanResponse, karyawanResponse] = await Future.wait([
        http.get(Uri.parse('http://127.0.0.1:8000/api/penjualan/list-data')),
        http.get(Uri.parse('http://127.0.0.1:8000/api/karyawan/list-data')),
      ]);

      if (penjualanResponse.statusCode == 200 && karyawanResponse.statusCode == 200) {
        final penjualanData = json.decode(penjualanResponse.body);
        final karyawanData = json.decode(karyawanResponse.body);
        
        setState(() {
          _penjualanData = penjualanData['data'];
          _karyawanData = karyawanData['data'];
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

  String _getNamaKasir(int penggunaId) {
    final karyawan = _karyawanData.firstWhere(
      (k) => k['id'] == penggunaId,
      orElse: () => {'Nama': 'Unknown'},
    );
    return karyawan['Nama'];
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  void _showDeleteConfirmation(int id, String tanggal) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Hapus Penjualan',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.blue.shade700,
          ),
        ),
        content: Text('Yakin ingin menghapus penjualan $tanggal?'),
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
              _deletePenjualan(id);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red.shade600,
              foregroundColor: Colors.white,
            ),
            child: Text(
              'Ya',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _deletePenjualan(int id) async {
    try {
      final response = await http.delete(
        Uri.parse('http://127.0.0.1:8000/api/penjualan/hapus/$id'),
      );
      
      if (response.statusCode == 200) {
        _showSnackBar('Penjualan berhasil dihapus');
        _loadData();
      }
    } catch (e) {
      _showSnackBar('Error: $e');
    }
  }

  Widget _buildPenjualanTable() {
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
                  Expanded(flex: 2, child: Text('Tanggal', style: TextStyle(fontWeight: FontWeight.bold))),
                  Expanded(flex: 2, child: Text('Kasir', style: TextStyle(fontWeight: FontWeight.bold))),
                  Expanded(flex: 1, child: Text('Aksi', style: TextStyle(fontWeight: FontWeight.bold))),
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
                        Expanded(flex: 1, child: Text('${index + 1}')),
                        Expanded(flex: 2, child: Text(penjualan['tgl'] ?? '')),
                        Expanded(flex: 2, child: Text(_getNamaKasir(penjualan['pengguna_id']))),
                        Expanded(
                          flex: 1,
                          child: Row(
                            children: [
                              IconButton(
                                icon: Icon(Icons.edit, size: 18, color: Colors.orange.shade600),
                                onPressed: () => _showFormPenjualan(penjualan: penjualan),
                              ),
                              IconButton(
                                icon: Icon(Icons.delete, size: 18, color: Colors.red.shade600),
                                onPressed: () => _showDeleteConfirmation(penjualan['id'], penjualan['tgl']),
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

  void _showFormPenjualan({Map<String, dynamic>? penjualan}) {
    TextEditingController tanggalController = TextEditingController(text: penjualan?['tgl'] ?? '');
    int? selectedKasirId = penjualan?['pengguna_id'];
    DateTime? selectedDate;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          penjualan == null ? 'Tambah Penjualan' : 'Edit Penjualan',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.blue.shade700,
          ),
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              InkWell(
                onTap: () async {
                  final DateTime? picked = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                  );
                  if (picked != null) {
                    selectedDate = picked;
                    tanggalController.text = "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
                  }
                },
                child: AbsorbPointer(
                  child: TextField(
                    controller: tanggalController,
                    decoration: InputDecoration(
                      labelText: 'Tanggal',
                      border: OutlineInputBorder(),
                      suffixIcon: Icon(Icons.calendar_today),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 16),
              DropdownButtonFormField<int>(
                value: selectedKasirId,
                decoration: InputDecoration(
                  labelText: 'Kasir',
                  border: OutlineInputBorder(),
                ),
                items: _karyawanData.map<DropdownMenuItem<int>>((karyawan) {
                  return DropdownMenuItem<int>(
                    value: karyawan['id'],
                    child: Text(karyawan['Nama']),
                  );
                }).toList(),
                onChanged: (value) {
                  selectedKasirId = value;
                },
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
              if (tanggalController.text.isEmpty) {
                _showSnackBar('Tanggal harus diisi');
                return;
              }
              if (selectedKasirId == null) {
                _showSnackBar('Pilih kasir terlebih dahulu');
                return;
              }
              _savePenjualan(
                id: penjualan?['id'],
                tanggal: tanggalController.text,
                penggunaId: selectedKasirId!,
                isEdit: penjualan != null,
              );
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue.shade700,
              foregroundColor: Colors.white,
            ),
            child: Text(
              'Simpan',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _savePenjualan({
    int? id,
    required String tanggal,
    required int penggunaId,
    required bool isEdit,
  }) async {
    try {
      final Map<String, dynamic> body = {
        'tgl': tanggal,
        'pengguna_id': penggunaId.toString(),
      };

      if (isEdit && id != null) {
        body['id'] = id.toString();
      }

      final response = await http.post(
        Uri.parse('http://127.0.0.1:8000/api/penjualan/simpan'),
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
        onPressed: () => _showFormPenjualan(),
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
            Expanded(
              child: _isLoading
                  ? Center(child: CircularProgressIndicator())
                  : _penjualanData.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.shopping_cart_outlined, size: 64, color: Colors.grey.shade400),
                              SizedBox(height: 16),
                              Text(
                                'Belum ada data penjualan',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                'Klik tombol + untuk menambah penjualan',
                                style: TextStyle(
                                  color: Colors.grey.shade500,
                                ),
                              ),
                            ],
                          ),
                        )
                      : _buildPenjualanTable(),
            ),
          ],
        ),
      ),
    );
  }
}


