import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class KaryawanScreen extends StatefulWidget {
  const KaryawanScreen({super.key});

  @override
  _KaryawanScreenState createState() => _KaryawanScreenState();
}

class _KaryawanScreenState extends State<KaryawanScreen> {
  List<dynamic> _karyawanData = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final response = await http.get(Uri.parse('http://127.0.0.1:8000/api/karyawan/list-data'));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _karyawanData = data['data'];
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
          'Hapus Karyawan',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.blue.shade700,
          ),
        ),
        content: Text('Yakin ingin menghapus Data Atas Nama  "$nama"?'),
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
              _deleteKaryawan(id);
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

  Future<void> _deleteKaryawan(int id) async {
    try {
      final response = await http.delete(
        Uri.parse('http://127.0.0.1:8000/api/karyawan/hapus/$id'),
      );
      
      if (response.statusCode == 200) {
        _showSnackBar('Karyawan berhasil dihapus');
        _loadData();
      }
    } catch (e) {
      _showSnackBar('Error: $e');
    }
  }

  Widget _buildKaryawanTable() {
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
                  Expanded(flex: 2, child: Text('Nama', style: TextStyle(fontWeight: FontWeight.bold))),
                  Expanded(flex: 1, child: Text('Gender', style: TextStyle(fontWeight: FontWeight.bold))),
                  Expanded(flex: 2, child: Text('Sandi', style: TextStyle(fontWeight: FontWeight.bold))),
                  Expanded(flex: 1, child: Text('Aksi', style: TextStyle(fontWeight: FontWeight.bold))),
                ],
              ),
            ),
            SizedBox(height: 8),
            // Data Tabel
            Expanded(
              child: ListView.builder(
                itemCount: _karyawanData.length,
                itemBuilder: (context, index) {
                  final karyawan = _karyawanData[index];
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
                        Expanded(flex: 2, child: Text(karyawan['Nama'] ?? '')),
                        Expanded(flex: 1, child: Text(karyawan['Gender'] == 'L' ? 'Laki-laki' : 'Perempuan')),
                        Expanded(flex: 2, child: Text('••••••••')), // Sandi disembunyikan
                        Expanded(
                          flex: 1,
                          child: Row(
                            children: [
                              IconButton(
                                icon: Icon(Icons.edit, size: 18, color: Colors.orange.shade600),
                                onPressed: () => _showFormKaryawan(karyawan: karyawan),
                              ),
                              IconButton(
                                icon: Icon(Icons.delete, size: 18, color: Colors.red.shade600),
                                onPressed: () => _showDeleteConfirmation(karyawan['id'], karyawan['Nama']),
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

  void _showFormKaryawan({Map<String, dynamic>? karyawan}) {
    TextEditingController namaController = TextEditingController(text: karyawan?['Nama'] ?? '');
    TextEditingController sandiController = TextEditingController(text: karyawan?['Sandi'] ?? '');
    String selectedGender = karyawan?['Gender'] ?? 'L';
    bool obscurePassword = true;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return AlertDialog(
              title: Text(
                karyawan == null ? 'Tambah Karyawan' : 'Edit Karyawan',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.blue.shade700,
                ),
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: namaController,
                      decoration: InputDecoration(
                        labelText: 'Nama Karyawan',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      value: selectedGender,
                      decoration: InputDecoration(
                        labelText: 'Gender',
                        border: OutlineInputBorder(),
                      ),
                      items: [
                        DropdownMenuItem(value: 'L', child: Text('Laki-laki')),
                        DropdownMenuItem(value: 'P', child: Text('Perempuan')),
                      ],
                      onChanged: (value) {
                        setStateDialog(() {
                          selectedGender = value!;
                        });
                      },
                    ),
                    SizedBox(height: 16),
                    TextField(
                      controller: sandiController,
                      decoration: InputDecoration(
                        labelText: 'Sandi',
                        border: OutlineInputBorder(),
                        suffixIcon: IconButton(
                          icon: Icon(obscurePassword ? Icons.visibility : Icons.visibility_off),
                          onPressed: () {
                            setStateDialog(() {
                              obscurePassword = !obscurePassword;
                            });
                          },
                        ),
                      ),
                      obscureText: obscurePassword,
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
                      _showSnackBar('Nama karyawan harus diisi');
                      return;
                    }
                    if (sandiController.text.isEmpty) {
                      _showSnackBar('Sandi harus diisi');
                      return;
                    }

                    _saveKaryawan(
                      id: karyawan?['id'],
                      nama: namaController.text,
                      gender: selectedGender,
                      sandi: sandiController.text,
                      isEdit: karyawan != null,
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
            );
          },
        );
      },
    );
  }

  Future<void> _saveKaryawan({
    int? id,
    required String nama,
    required String gender,
    required String sandi,
    required bool isEdit,
  }) async {
    try {
      final Map<String, dynamic> body = {
        'Nama': nama,
        'Gender': gender,
        'Sandi': sandi,
      };

      if (isEdit && id != null) {
        body['id'] = id.toString();
      }

      final response = await http.post(
        Uri.parse('http://127.0.0.1:8000/api/karyawan/simpan'),
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
        onPressed: () => _showFormKaryawan(),
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
                Icon(Icons.people, size: 32, color: Colors.blue.shade700),
                SizedBox(width: 12),
                Text(
                  'Data Karyawan',
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
              'Kelola data karyawan toko bangunan',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey.shade600,
              ),
            ),
            SizedBox(height: 24),
            Expanded(
              child: _isLoading
                  ? Center(child: CircularProgressIndicator())
                  : _karyawanData.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.people_outline, size: 64, color: Colors.grey.shade400),
                              SizedBox(height: 16),
                              Text(
                                'Belum ada data karyawan',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                'Klik tombol + untuk menambah karyawan',
                                style: TextStyle(
                                  color: Colors.grey.shade500,
                                ),
                              ),
                            ],
                          ),
                        )
                      : _buildKaryawanTable(),
            ),
          ],
        ),
      ),
    );
  }
}