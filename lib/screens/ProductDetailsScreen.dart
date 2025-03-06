import 'package:flutter/material.dart';
import '../widgets/ProductDetailsContainer.dart';
import '../widgets/EditProductContainer.dart';
import '../widgets/EditStockManagement.dart';
import '../services/socket_service.dart';
import 'package:intl/intl.dart';

class ProductDetailsScreen extends StatefulWidget {
  final Map<String, dynamic> productData;
  final String token;
  final String userName;

  const ProductDetailsScreen({
    Key? key,
    required this.productData,
    required this.token,
    required this.userName,
  }) : super(key: key);

  @override
  _ProductDetailsScreenState createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  final SocketService _socketService = SocketService();

  final TextEditingController _barcodeController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _costController = TextEditingController();
  final TextEditingController _exitController = TextEditingController();
  final TextEditingController _rentMinController = TextEditingController();
  final TextEditingController _stockMinController = TextEditingController();
  final TextEditingController _proVentController = TextEditingController();
  final TextEditingController _stockMxnController = TextEditingController();
  final TextEditingController _proComprController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _barcodeController.text = widget.productData['CodigoBarra'].toString();
    _nameController.text = widget.productData['Nombre'].toString();
    _priceController.text = widget.productData['Precio'].toString();
    _costController.text = widget.productData['Costo'].toString();
    _exitController.text = widget.productData['Existencia'].toString();
    _rentMinController.text = widget.productData['Rentabilidad_Minima'].toString();
    _stockMinController.text = widget.productData['Ext_Minima'].toString();
    _proVentController.text = widget.productData['Avg_Venta'].toString();
    _stockMxnController.text = widget.productData['Ext_Maxima'].toString();
    _proComprController.text = widget.productData['Avg_Compra'].toString();
  }

  String formatDate(DateTime date) {
    return DateFormat("yyyy-MM-dd HH:mm:ss").format(date);
  }
  
  DateTime parseDate(String? dateString) {
    if (dateString == null || dateString.isEmpty) return DateTime(2000, 1, 1);
    try {
      return DateFormat("dd/MM/yyyy hh:mm:ss a", "en_US").parse(dateString);
    } catch (e) {
      return DateTime(2000, 1, 1);
    }
  }

String cleanPercentage(String value) {
  return value.replaceAll('%', '').replaceAll(',', '.').trim();
}


  String extractNumbers(String value) {
    return value.replaceAll(RegExp(r'[^0-9]'), '');
  }
void _updateProduct() {
  List<String> updatedData = [
    extractNumbers(widget.productData['CodigoBarra'].toString()),
    widget.productData['PLU'] ?? '',
    _nameController.text,
    _priceController.text.replaceAll(',', '.'),
    _costController.text.replaceAll(',', '.'),
    _proVentController.text.replaceAll(',', '.'),
    _proComprController.text.replaceAll(',', '.'),
    (widget.productData['Activo']?.toString().toLowerCase() == 'true' ||
            widget.productData['Activo'] == '1')
        ? 'True'
        : 'False',
    _exitController.text,
    _stockMinController.text,
    _stockMxnController.text,
    cleanPercentage(_rentMinController.text).replaceAll(',', '.'),
    cleanPercentage(_proVentController.text).replaceAll(',', '.'),
    cleanPercentage(_proComprController.text).replaceAll(',', '.'),
    formatDate(parseDate(widget.productData['Ultima_Compra'])),
    formatDate(parseDate(widget.productData['Ultima_Venta']))
  ];

  String message =
      "ACTUALIZAR|${widget.token}|${widget.userName}|${updatedData.join('|')}";

  try {
    _socketService.sendMessage(message);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Producto actualizado con éxito')),
    );
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error al actualizar producto: $e')),
    );
  }
}



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Producto'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ProductDetailsContainer(
                plu: widget.productData['PLU'].toString(),
                isActive:
                    (widget.productData['Activo'].toString().toLowerCase() ==
                            'true' ||
                        widget.productData['Activo'] == '1'),
                price: '\$${widget.productData['Precio']}',
                cost: '\$${widget.productData['Costo']}',
                lastPurchase: widget.productData['Ultima_Compra'].toString(),
                lastSale: widget.productData['Ultima_Venta'].toString(),
              ),
              const SizedBox(height: 16.0),
              EditProductContainer(
                barcodeController: _barcodeController,
                nameController: _nameController,
                priceController: _priceController,
                costController: _costController,
              ),
              const SizedBox(height: 16.0),
              EditStockManagement(
                exitController: _exitController,
                rentMinController: _rentMinController,
                stockMinController: _stockMinController,
                proVentController: _proVentController,
                stockMxnController: _stockMxnController,
                proComprController: _proComprController,
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          onPressed: _updateProduct,
          style: ElevatedButton.styleFrom(
            minimumSize: Size(MediaQuery.of(context).size.width * 1.0, 50.0),
            padding: EdgeInsets.all(8.0),
            backgroundColor: Color(0xFF043275),
            elevation: 0.0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25.0),
            ),
          ),
          child: Text(
            'Guardar Cambios',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
