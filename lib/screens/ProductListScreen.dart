import 'package:flutter/material.dart';
import 'package:socket_flutter_app/screens/ProductDetailsScreen.dart';
import 'package:socket_flutter_app/services/socket_service.dart';

class ProductListScreen extends StatefulWidget {
  final String token;
  final String userName;

  const ProductListScreen(
      {Key? key, required this.token, required this.userName})
      : super(key: key);
  @override
  _ProductListScreenState createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  List<Map<String, dynamic>> _products = [];
  final SocketService _socketService = SocketService();

  @override
  void initState() {
    super.initState();
    _connectAndFetchProducts();
  }

  void _connectAndFetchProducts() async {
    if (!_socketService.isConnected) {
      bool connected =
          await _socketService.connect(widget.userName, (response) {
        setState(() {
          _products.clear();
          _products.addAll(_parseProductList(response));
        });
      });

      if (connected) {
        _sendMessage("LISTAR", "", queryType: "PRODUCTOS");
      }
    } else {
      _sendMessage("LISTAR", "", queryType: "PRODUCTOS");
    }
  }

  void deleteProduct(String codigoBarra) {
    _sendMessage("ELIMINAR", codigoBarra, queryType: "PRODUCTO");

    setState(() {
      _products.removeWhere((product) => product['CodigoBarra'] == codigoBarra);
    });

    Future.delayed(const Duration(milliseconds: 500), () {
      _sendMessage("LISTAR", "", queryType: "PRODUCTOS");
    });
  }

  void _sendMessage(String action, String data, {required String queryType}) {
    String message =
        "$action|${widget.token}|${widget.userName}|$data|$queryType";
    try {
      _socketService.sendMessage(message);
    } catch (e) {
      print("Error: $e");
    }
  }

  @override
  void dispose() {
    _socketService.disconnect();
    super.dispose();
  }

  List<Map<String, dynamic>> _parseProductList(String response) {
    List<Map<String, dynamic>> products = [];
    List<String> lines = response.split('\n');

    for (String line in lines) {
      if (line.trim().isNotEmpty) {
        Map<String, dynamic> product = _parseServerResponse(line);
        if (product.isNotEmpty) {
          products.add(product);
        }
      }
    }
    return products;
  }

  Map<String, dynamic> _parseServerResponse(String response) {
    List<String> parts = response.split('|');
    if (parts.length < 16) return {};

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
      appBar: AppBar(
        title: const Text('Listado de Productos'),
        backgroundColor: const Color(0xFF126CD8),
      ),
      body: _products.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: _products.length,
              itemBuilder: (context, index) {
                final product = _products[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: ProductContainer(
                    codigoBarra: product['CodigoBarra'],
                    plu: product['PLU'],
                    nombre: product['Nombre'],
                    isActive:
                        product['Activo'].toString().toLowerCase() == 'true',
                    productData: product,
                    onDelete: deleteProduct,
                    token: widget.token,
                    userName: widget.userName
                  ),
                );
              },
            ),
    );
  }
}

class ProductContainer extends StatelessWidget {
  final String codigoBarra;
  final String plu;
  final String nombre;
  final bool isActive;
  final Map<String, dynamic> productData;
  final Function(String) onDelete;
  final String token;
  final String userName;

  const ProductContainer({
    Key? key,
    required this.codigoBarra,
    required this.plu,
    required this.nombre,
    required this.isActive,
    required this.productData,
    required this.onDelete,
    required this.token,
    required this.userName,
  }) : super(key: key);

  void _confirmDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Eliminar Producto"),
          content:
              const Text("¿Estás seguro de que deseas eliminar este producto?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("Cancelar"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _deleteProduct(context);
              },
              child:
                  const Text("Eliminar", style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  void _deleteProduct(BuildContext context) {
    final productListScreenState =
        context.findAncestorStateOfType<_ProductListScreenState>();
    if (productListScreenState != null) {
      productListScreenState.deleteProduct(codigoBarra);
    }
    onDelete(codigoBarra);
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color.fromARGB(255, 255, 255, 255),
      elevation: 2.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Container(
        width: MediaQuery.sizeOf(context).width * 1.0,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(20.0, 20.0, 20.0, 20.0),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    nombre,
                    style: const TextStyle(
                      fontFamily: 'Outfit',
                      color: Color(0xFF161C24),
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  PopupMenuButton<String>(
                    icon: const Icon(Icons.more_vert, color: Colors.grey),
                    onSelected: (value) {
                      if (value == 'ver') {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProductDetailsScreen(
                              productData: productData,
                              token: token,
                              userName: userName,
                            ),
                          ),
                        );
                      } else if (value == 'eliminar') {
                        _confirmDelete(context);
                      }
                    },
                    itemBuilder: (BuildContext context) {
                      return [
                        const PopupMenuItem<String>(
                          value: 'ver',
                          child: Text('Ver'),
                        ),
                        const PopupMenuItem<String>(
                          value: 'eliminar',
                          child: Text('Eliminar'),
                        ),
                      ];
                    },
                  ),
                ],
              ),
              const SizedBox(height: 16.0),
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'PLU',
                        style: TextStyle(
                          fontFamily: 'Manrope',
                          color: Color(0xFF636F81),
                          fontSize: 12.0,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        plu,
                        style: const TextStyle(
                          fontFamily: 'Manrope',
                          color: Color(0xFF161C24),
                          fontSize: 16.0,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: isActive
                          ? const Color(0xFFE8F5E9)
                          : const Color(0xFFFFEBEE),
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        isActive ? 'Activo' : 'Inactivo',
                        style: TextStyle(
                          fontFamily: 'Manrope',
                          color: isActive
                              ? const Color(0xFF2E7D32)
                              : const Color(0xFFC62828),
                          fontSize: 12.0,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
