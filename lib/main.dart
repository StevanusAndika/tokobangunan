import 'package:flutter/material.dart';
import 'package:tokobangunan/beranda.dart';

void main() => runApp(TokoBangunanApp());

class TokoBangunanApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Toko Bangunan',
      theme: ThemeData(
        primaryColor: Colors.blue.shade700,
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.grey.shade50,
        fontFamily: 'Roboto',
      ),
      home: Beranda(),
      
    );
  }
}