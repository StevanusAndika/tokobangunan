import 'package:flutter/material.dart';
import 'package:tokobangunan/karyawan.dart';
import 'package:tokobangunan/produk.dart';
import 'package:tokobangunan/penjualan.dart';
import 'package:tokobangunan/laporan_penjualan.dart';

class Beranda extends StatefulWidget {
  @override
  _BerandaState createState() => _BerandaState();
}

class _BerandaState extends State<Beranda> {
  Widget isiKonten = Container();
  bool sembunyi = false;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    isiKonten = _buildDashboard();
  }

  Widget _buildDashboard() {
    return Container(
      padding: EdgeInsets.all(40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Dashboard',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.blue.shade700,
            ),
          ),
          SizedBox(height: 20),
          Text(
            'Sistem Manajemen Toko Bangunan Terintegrasi',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey.shade600,
            ),
          ),
          SizedBox(height: 40),
          Wrap(
            spacing: 20,
            runSpacing: 20,
            children: [
              _buildDashboardCard('Karyawan', Icons.people, Colors.blue.shade600, '5', 'Total Karyawan'),
              _buildDashboardCard('Produk', Icons.inventory_2, Colors.green.shade600, '24', 'Jenis Produk'),
              _buildDashboardCard('Penjualan', Icons.shopping_cart, Colors.orange.shade600, '156', 'Transaksi'),
              _buildDashboardCard('Laporan', Icons.analytics, Colors.purple.shade600, '12', 'Laporan Bulan Ini'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDashboardCard(String title, IconData icon, Color color, String value, String subtitle) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: TweenAnimationBuilder(
        duration: Duration(milliseconds: 200),
        builder: (context, value, child) {
          return Transform.scale(
            scale: value as double,
            child: child,
          );
        },
        tween: Tween(begin: 1.0, end: 1.0),
        child: Card(
          elevation: 4,
          child: Container(
            width: 220,
            height: 160,
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: color.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(icon, size: 32, color: color),
                    ),
                    Text(
                      value,
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: color,
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey.shade700,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      onEnter: (_) {
        setState(() {
          // Trigger hover animation
        });
      },
    );
  }

  Widget _buildMenuItem(String label, VoidCallback onTap, IconData icon, int index) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Material(
        color: _selectedIndex == index ? Colors.blue.shade50 : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(8),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                Icon(
                  icon,
                  color: _selectedIndex == index ? Colors.blue.shade700 : Colors.grey.shade600,
                  size: 20,
                ),
                SizedBox(width: 12),
                Text(
                  label,
                  style: TextStyle(
                    fontWeight: _selectedIndex == index ? FontWeight.w600 : FontWeight.normal,
                    color: _selectedIndex == index ? Colors.blue.shade700 : Colors.grey.shade700,
                    fontSize: 14,
                  ),
                ),
                Spacer(),
                if (_selectedIndex == index)
                  Icon(
                    Icons.arrow_right,
                    color: Colors.blue.shade700,
                    size: 18,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSideMenu() {
    return Container(
      width: 250,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          right: BorderSide(
            color: Colors.grey.shade200,
            width: 1,
          ),
        ),
      ),
      child: Column(
        children: [
          // Header Menu yang lebih sederhana
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: Colors.grey.shade200,
                  width: 1,
                ),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Menu',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey.shade800,
                  ),
                ),
              ],
            ),
          ),
          
          // Menu Items
          Expanded(
            child: ListView(
              padding: EdgeInsets.all(8),
              children: [
                SizedBox(height: 8),
                _buildMenuItem('Dashboard', () {
                  setState(() {
                    _selectedIndex = 0;
                    isiKonten = _buildDashboard();
                  });
                }, Icons.dashboard, 0),
                _buildMenuItem('Karyawan', () {
                  setState(() {
                    _selectedIndex = 1;
                    isiKonten = KaryawanScreen();
                  });
                }, Icons.people, 1),
                _buildMenuItem('Produk', () {
                  setState(() {
                    _selectedIndex = 2;
                    isiKonten = ProdukScreen();
                  });
                }, Icons.inventory_2, 2),
                _buildMenuItem('Penjualan', () {
                  setState(() {
                    _selectedIndex = 3;
                    isiKonten = PenjualanScreen();
                  });
                }, Icons.shopping_cart, 3),
                _buildMenuItem('Laporan Penjualan', () {
                  setState(() {
                    _selectedIndex = 4;
                    isiKonten = LaporanPenjualanScreen();
                  });
                }, Icons.analytics, 4),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey.shade50,
        ),
        child: isiKonten,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.menu, color: Colors.white),
          onPressed: () {
            setState(() {
              sembunyi = !sembunyi;
            });
          },
        ),
        elevation: 0,
        backgroundColor: Colors.blue.shade700,
        title: Text(
          'Sistem Manajemen Toko Bangunan',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.notifications, color: Colors.white),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.person, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          if (!sembunyi) _buildSideMenu(),
          _buildContent(),
        ],
      ),
    );
  }
}