import 'package:flutter/material.dart';
import '../services/socket_service.dart';

class CreateProductScreen extends StatefulWidget {
  final String token;
  final String userName;

  const CreateProductScreen({
    Key? key,
    required this.token,
    required this.userName,
  }) : super(key: key);

  @override
  _CreateProductScreenState createState() => _CreateProductScreenState();
}

class _CreateProductScreenState extends State<CreateProductScreen> {
  final SocketService _socketService = SocketService();

  final TextEditingController _pluController = TextEditingController();
  final TextEditingController _barcodeController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _costController = TextEditingController();


  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    String hintText = '',
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'Manrope',
            color: Color(0xFF636F81),
            fontSize: 12.0,
            fontWeight: FontWeight.w500,
          ),
        ),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: const TextStyle(
              fontFamily: 'Manrope',
              color: Color(0xFF161C24),
              fontSize: 16.0,
              fontWeight: FontWeight.w500,
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(
                color: Color(0xFFE0E3E7),
                width: 1.0,
              ),
              borderRadius: BorderRadius.circular(8.0),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(
                color: Color(0x00000000),
                width: 1.0,
              ),
              borderRadius: BorderRadius.circular(8.0),
            ),
            filled: true,
            fillColor: const Color(0xFFF0F5F9),
          ),
          style: const TextStyle(
            fontFamily: 'Manrope',
            color: Color(0xFF161C24),
            fontSize: 14.0,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

void _createProduct() {
String now = DateTime.now().toString().split('.')[0];
String data = "${_barcodeController.text.trim()}|"
              "${_pluController.text.trim()}|"
              "${_nameController.text.trim()}|"
              "${_priceController.text.trim().replaceAll(',', '.')}|"
              "${_costController.text.trim().replaceAll(',', '.')}|"
              "0.00|0|1|0|0|0|0.00|0.00|0.00|"
              "$now|$now";


  String message = "CREAR|${widget.token}|${widget.userName}|$data";

  try {
    _socketService.sendMessage(message);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Producto creado con éxito')),
    );
    Navigator.pop(context);
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error al crear producto: $e')),
    );
  }
}



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registrar Producto'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Material(
              color: Colors.transparent,
              elevation: 2.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.0),
              ),
              child: Container(
                width: MediaQuery.of(context).size.width * 0.9,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'Registrar Nuevo Producto',
                        style: TextStyle(
                          fontFamily: 'Outfit',
                          color: Color(0xFF161C24),
                          fontSize: 24.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16.0),
                      _buildTextField(
                        label: 'Código de Barras',
                        controller: _barcodeController,
                      ),
                      const SizedBox(height: 16.0),
                      _buildTextField(
                        label: 'PLU',
                        controller: _pluController,
                      ),
                      const SizedBox(height: 16.0),
                      _buildTextField(
                        label: 'Nombre',
                        controller: _nameController,
                      ),
                      const SizedBox(height: 16.0),
                      Row(
                        children: [
                          Expanded(
                            child: _buildTextField(
                              label: 'Precio',
                              controller: _priceController,
                              hintText: '0.00',
                              keyboardType: TextInputType.number,
                            ),
                          ),
                          const SizedBox(width: 16.0),
                          Expanded(
                            child: _buildTextField(
                              label: 'Costo',
                              controller: _costController,
                              hintText: '0.00',
                              keyboardType: TextInputType.number,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24.0),
                      ElevatedButton(
                        onPressed: _createProduct,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 50.0, vertical: 15.0),
                          backgroundColor: const Color(0xFF043275),
                          elevation: 0.0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25.0),
                          ),
                        ),
                        child: const Text(
                          'Guardar Producto',
                          style: TextStyle(color: Colors.white, fontSize: 16.0),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
