import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:socket_flutter_app/services/socket_service.dart';
import 'package:socket_flutter_app/screens/ProductDetailsScreen.dart';

class ScannerPage extends StatefulWidget {
  final String token;
  final String userName;

  const ScannerPage({Key? key, required this.token, required this.userName})
      : super(key: key);

  @override
  State<ScannerPage> createState() => _ScannerPageState();
}

class _ScannerPageState extends State<ScannerPage> {
  String? barcode;
  final SocketService _socketService = SocketService();
  String _serverResponse = "Esperando respuesta del servidor...";

  @override
  void initState() {
    super.initState();
    _connectToServer();
  }

  void _connectToServer() async {
    bool connected = await _socketService.connect(widget.userName, (response) {
      setState(() {
        _serverResponse = response;
      });
    });

    if (!connected) {
      setState(() {
        _serverResponse = "Error al conectar con el servidor.";
      });
    }
  }

  void _sendMessage(String action, String data) {
    String message = "$action|${widget.token}|${widget.userName}|$data";
    _socketService.sendMessage(message);
  }

  Map<String, dynamic> _parseServerResponse(String response) {
    List<String> parts = response.split('|');
    if (parts.length < 16) {
      return {};
    }

    return {
      'CodigoBarra': parts[0],
      'PLU': parts[1],
      'Nombre': parts[2],
      'Precio': parts[3],
      'Costo': parts[4],
      'PrecioPromo': parts[5],
      'IVA': parts[6],
      'Activo': parts[7],
      'Existencia': parts[8],
      'Ext_Minima': parts[9],
      'Ext_Maxima': parts[10],
      'Rentabilidad_Minima': parts[11],
      'Avg_Venta': parts[12],
      'Avg_Compra': parts[13],
      'Ultima_Compra': parts[14],
      'Ultima_Venta': parts[15],
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(
                      Icons.arrow_back_rounded,
                      color: Colors.black54,
                      size: 40.0,
                    ),
                  ),
                  const Expanded(
                    child: Center(
                      child: Text(
                        'Escáner',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 40),
                ],
              ),
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    constraints:
                        const BoxConstraints(maxHeight: 600, maxWidth: 450),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12.0),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          MobileScanner(
                            onDetect: (barcode, args) {
                              final String code = barcode.rawValue ?? '---';
                              setState(() {
                                this.barcode = code;
                                _sendMessage("CONSULTAR", code);
                              });
                            },
                          ),
                          const FaIcon(
                            FontAwesomeIcons.expand,
                            color: Color.fromARGB(172, 255, 255, 255),
                            size: 250,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.all(12),
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [],
                    ),
                    child: Text(
                      _serverResponse.isNotEmpty &&
                              _parseServerResponse(_serverResponse)
                                  .containsKey('Nombre')
                          ? 'Producto detectado: ${_parseServerResponse(_serverResponse)['Nombre']}'
                          : 'Escaneando...',
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      if (_serverResponse.isNotEmpty) {
                        final productData =
                            _parseServerResponse(_serverResponse);
                        if (productData.isNotEmpty &&
                            productData.containsKey('Nombre')) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ProductDetailsScreen(
                                  productData: productData),
                            ),
                          );
                        }
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 38, vertical: 15),
                    ),
                    child: const Text(
                      'Ver Detalles',
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
