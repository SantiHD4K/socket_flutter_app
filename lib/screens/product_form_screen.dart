import 'package:flutter/material.dart';

class ProductFormScreen extends StatefulWidget {
  final Function(String) onSubmit;

  ProductFormScreen({required this.onSubmit});

  @override
  _ProductFormScreenState createState() => _ProductFormScreenState();
}

class _ProductFormScreenState extends State<ProductFormScreen> {
  final TextEditingController _codigoController = TextEditingController();
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _precioController = TextEditingController();
  final TextEditingController _costoController = TextEditingController();
  final TextEditingController _precioPromoController = TextEditingController();
  final TextEditingController _ivaController = TextEditingController();

  void _sendData() {
    String message =
        "CREAR|${_codigoController.text}|${_nombreController.text}|${_precioController.text}|${_costoController.text}|${_precioPromoController.text}|${_ivaController.text}";
    widget.onSubmit(message);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Registrar Producto')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(controller: _codigoController, decoration: InputDecoration(labelText: 'Código de Barras')),
            TextField(controller: _nombreController, decoration: InputDecoration(labelText: 'Nombre')),
            TextField(controller: _precioController, decoration: InputDecoration(labelText: 'Precio')),
            TextField(controller: _costoController, decoration: InputDecoration(labelText: 'Costo')),
            TextField(controller: _precioPromoController, decoration: InputDecoration(labelText: 'Precio Promoción')),
            TextField(controller: _ivaController, decoration: InputDecoration(labelText: 'IVA')),
            SizedBox(height: 20),
            ElevatedButton(onPressed: _sendData, child: Text('Registrar')),
          ],
        ),
      ),
    );
  }
}
