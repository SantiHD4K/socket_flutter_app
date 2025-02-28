import 'package:flutter/material.dart';
import '../widgets/ProductDetailsContainer.dart';
import '../widgets/EditProductContainer.dart';
import '../widgets/EditStockManagement.dart';

class ProductDetailsScreen extends StatefulWidget {
  final Map<String, dynamic> productData;

  const ProductDetailsScreen({Key? key, required this.productData})
      : super(key: key);

  @override
  _ProductDetailsScreenState createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
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
                isActive:(widget.productData['Activo'].toString().toLowerCase() =='true' || widget.productData['Activo'] == '1'),
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
              const SizedBox(height: 40.0),
              ElevatedButton(
                onPressed: () {
                },
                style: ElevatedButton.styleFrom(
                  minimumSize:
                      Size(MediaQuery.of(context).size.width * 1.0, 50.0),
                  padding: EdgeInsets.all(8.0),
                  backgroundColor:
                      Color(0xFF2797FF),
                  elevation: 0.0,
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(25.0),
                  ),
                ),
                child: Text(
                  'Guardar Cambios',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
