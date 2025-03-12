import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:socket_flutter_app/services/socket_service.dart';
import 'package:socket_flutter_app/screens/ProductDetailsScreen.dart';
import 'package:socket_flutter_app/screens/ProductListScreen.dart';
import 'package:socket_flutter_app/screens/CreateProductScreen.dart';

class ScannerPage extends StatefulWidget {
  final String token;
  final String userName;
  static final GlobalKey<_ScannerPageState> scannerKey =
      GlobalKey<_ScannerPageState>();

  const ScannerPage({Key? key, required this.token, required this.userName})
      : super(key: key);

  @override
  State<ScannerPage> createState() => _ScannerPageState();
}

class _ScannerPageState extends State<ScannerPage> {
  String? barcode;
  final SocketService _socketService = SocketService();
  String _serverResponse = "Esperando respuesta del servidor...";
  bool _isExpanded = false;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _connectToServer();
  }

  void clearLastProduct() {
    setState(() {
      _lastProduct = null;
      _serverResponse = "Esperando respuesta del servidor...";
    });
  }

  Map<String, dynamic>? _lastProduct;

  void _connectToServer() async {
    bool connected = await _socketService.connect(widget.userName, (response) {
      setState(() {
        Map<String, dynamic> productData = _parseServerResponse(response);

        if (productData.isNotEmpty &&
            productData.containsKey('Nombre') &&
            productData['Nombre'].isNotEmpty) {
          _lastProduct = productData;
          _serverResponse = response;
        } else {
          _lastProduct = null;
          _serverResponse = "Código erróneo o no registrado.";
        }
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
      body: Stack(
        children: [
          SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 8.0),
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
                                  if (this.barcode != code) {
                                    setState(() {
                                      this.barcode = code;
                                      _sendMessage(
                                        "CONSULTAR",
                                        code,
                                      );
                                    });
                                  }
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
                        ),
                        child: _serverResponse ==
                                "Esperando respuesta del servidor..."
                            ? Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const SizedBox(width: 10),
                                  const Text(
                                    'Enfoca la cámara hacia el código de barras',
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.blue),
                                  ),
                                ],
                              )
                            : Text(
                                _lastProduct != null
                                    ? 'Producto detectado: ${_lastProduct!['Nombre']}'
                                    : _serverResponse,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: _lastProduct != null
                                      ? Colors.black
                                      : Colors.red,
                                ),
                                textAlign: TextAlign.center,
                              ),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: _lastProduct != null
                            ? () {
                                if (_serverResponse.isNotEmpty) {
                                  final productData =
                                      _parseServerResponse(_serverResponse);
                                  if (productData.isNotEmpty &&
                                      productData.containsKey('Nombre')) {
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            ProductDetailsScreen(
                                          productData: productData,
                                          token: widget.token,
                                          userName: widget.userName,
                                        ),
                                      ),
                                    );
                                  }
                                }
                              }
                            : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _lastProduct != null
                              ? const Color(0xFF043275)
                              : Colors.grey,
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
          if (_isExpanded)
            Positioned.fill(
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _isExpanded = false;
                  });
                },
                child: Container(
                  color: Color.fromRGBO(255, 255, 255, 0.905),
                ),
              ),
            ),
        ],
      ),
      floatingActionButton: Stack(
        children: [
          AnimatedPositioned(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            bottom: _isExpanded ? 140 : 0,
            right: 0,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (_isExpanded)
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: const Text(
                      'Registrar Productos',
                      style: TextStyle(color: Colors.black, fontSize: 16),
                    ),
                  ),
                FloatingActionButton(
                  onPressed: () async {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CreateProductScreen(
                          token: widget.token,
                          userName: widget.userName,
                        ),
                      ),
                    );
                  },
                  elevation: _isExpanded ? 6 : 0,
                  backgroundColor: Color(0xFF126CD8),
                  child: const Icon(Icons.add, color: Colors.white),
                ),
              ],
            ),
          ),
          AnimatedPositioned(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            bottom: _isExpanded ? 70 : 0,
            right: 0,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (_isExpanded)
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: const Text(
                      'Listado de Productos',
                      style: TextStyle(color: Colors.black, fontSize: 16),
                    ),
                  ),
                FloatingActionButton(
                  onPressed: () async {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProductListScreen(
                          token: widget.token,
                          userName: widget.userName,
                        ),
                      ),
                    );
                  },
                  elevation: _isExpanded ? 6 : 0,
                  backgroundColor: Color(0xFF126CD8),
                  child: const Icon(Icons.list, color: Colors.white),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: FloatingActionButton(
              onPressed: () {
                setState(() {
                  _isExpanded = !_isExpanded;
                });
              },
              elevation: 6,
              backgroundColor: Color(0xFF043275),
              child: Icon(_isExpanded ? Icons.close : Icons.menu,
                  color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
