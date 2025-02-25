import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class ScannerPage extends StatefulWidget {
  const ScannerPage({Key? key}) : super(key: key);

  @override
  State<ScannerPage> createState() => _ScannerPageState();
}

class _ScannerPageState extends State<ScannerPage> {
  String? barcode;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Escáner QR')),
      body: Column(
        children: [
          Expanded(
            flex: 4,
            child: MobileScanner(
              onDetect: (barcode, args) {
                final String code = barcode.rawValue ?? '---';
                setState(() {
                  this.barcode = code;
                });
                Navigator.pop(context, code);
              },
            ),
          ),
          Expanded(
            flex: 1,
            child: Center(
              child: Text(
                barcode != null ? 'Código detectado: $barcode' : 'Escaneando...',
                style: const TextStyle(fontSize: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
