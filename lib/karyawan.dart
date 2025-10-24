import 'package:flutter/material.dart';

class KaryawanScreen extends StatefulWidget {
  @override
  _KaryawanScreenState createState() => _KaryawanScreenState();
}

class _KaryawanScreenState extends State<KaryawanScreen> {
  List<Map<String, dynamic>> _karyawanData = [
    {
      'id': 1,
      'nama': 'Ahmad Santoso',
      'gender': 'Laki-laki',
      'email': 'ahmad@tokobangunan.com',
      'telepon': '081234567890',
      'jabatan': 'Manager',
      'gaji': 'Rp 8.000.000'
    },
    {
      'id': 2,
      'nama': 'Siti Rahayu',
      'gender': 'Perempuan',
      'email': 'siti@tokobangunan.com',
      'telepon': '081234567891',
      'jabatan': 'Kasir',
      'gaji': 'Rp 5.000.000'
    },
    {
      'id': 3,
      'nama': 'Budi Prasetyo',
      'gender': 'Laki-laki',
      'email': 'budi@tokobangunan.com',
      'telepon': '081234567892',
      'jabatan': 'Staff Gudang',
      'gaji': 'Rp 4.500.000'
    },
    {
      'id': 4,
      'nama': 'Maya Sari',
      'gender': 'Perempuan',
      'email': 'maya@tokobangunan.com',
      'telepon': '081234567893',
      'jabatan': 'Admin',
      'gaji': 'Rp 5.500.000'
    },
    {
      'id': 5,
      'nama': 'Rizki Ramadhan',
      'gender': 'Laki-laki',
      'email': 'rizki@tokobangunan.com',
      'telepon': '081234567894',
      'jabatan': 'Sales',
      'gaji': 'Rp 6.000.000'
    },
  ];

  void _showDetailKaryawan(Map<String, dynamic> karyawan) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Detail Karyawan'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDetailItem('Nama', karyawan['nama']),
              _buildDetailItem('Gender', karyawan['gender']),
              _buildDetailItem('Email', karyawan['email']),
              _buildDetailItem('Telepon', karyawan['telepon']),
              _buildDetailItem('Jabatan', karyawan['jabatan']),
              _buildDetailItem('Gaji', karyawan['gaji']),
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

  void _showEditKaryawan(Map<String, dynamic> karyawan) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Edit Karyawan'),
        content: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                decoration: InputDecoration(labelText: 'Nama'),
                controller: TextEditingController(text: karyawan['nama']),
              ),
              TextField(
                decoration: InputDecoration(labelText: 'Email'),
                controller: TextEditingController(text: karyawan['email']),
              ),
              TextField(
                decoration: InputDecoration(labelText: 'Telepon'),
                controller: TextEditingController(text: karyawan['telepon']),
              ),
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
              // Logic untuk update data
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Data karyawan berhasil diupdate')),
              );
            },
            child: Text('Simpan'),
          ),
        ],
      ),
    );
  }

  void _showTambahKaryawan() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Tambah Karyawan Baru'),
        content: SingleChildScrollView(
          child: Column(
            children: [
              TextField(decoration: InputDecoration(labelText: 'Nama')),
              TextField(decoration: InputDecoration(labelText: 'Gender')),
              TextField(decoration: InputDecoration(labelText: 'Email')),
              TextField(decoration: InputDecoration(labelText: 'Telepon')),
              TextField(decoration: InputDecoration(labelText: 'Jabatan')),
              TextField(decoration: InputDecoration(labelText: 'Gaji')),
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
                SnackBar(content: Text('Karyawan baru berhasil ditambahkan')),
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
        onPressed: _showTambahKaryawan,
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
            // Tabel Karyawan
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
                            Expanded(flex: 2, child: Text('Nama', style: TextStyle(fontWeight: FontWeight.bold))),
                            Expanded(child: Text('Gender', style: TextStyle(fontWeight: FontWeight.bold))),
                            Expanded(flex: 2, child: Text('Jabatan', style: TextStyle(fontWeight: FontWeight.bold))),
                            Expanded(flex: 2, child: Text('Email', style: TextStyle(fontWeight: FontWeight.bold))),
                            Expanded(child: Text('Aksi', style: TextStyle(fontWeight: FontWeight.bold))),
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
                                  Expanded(flex: 2, child: Text(karyawan['nama'])),
                                  Expanded(child: Text(karyawan['gender'])),
                                  Expanded(flex: 2, child: Text(karyawan['jabatan'])),
                                  Expanded(flex: 2, child: Text(karyawan['email'])),
                                  Expanded(
                                    child: Row(
                                      children: [
                                        IconButton(
                                          icon: Icon(Icons.visibility, size: 18, color: Colors.blue),
                                          onPressed: () => _showDetailKaryawan(karyawan),
                                        ),
                                        IconButton(
                                          icon: Icon(Icons.edit, size: 18, color: Colors.orange),
                                          onPressed: () => _showEditKaryawan(karyawan),
                                        ),
                                        IconButton(
                                          icon: Icon(Icons.delete, size: 18, color: Colors.red),
                                          onPressed: () {
                                            setState(() {
                                              _karyawanData.removeAt(index);
                                            });
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              SnackBar(content: Text('Karyawan berhasil dihapus')),
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