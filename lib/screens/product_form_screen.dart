import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ProductFormScreen extends StatefulWidget {
  final Function(String) onSubmit;

  const ProductFormScreen({super.key, required this.onSubmit});

  @override
  _ProductFormScreenState createState() => _ProductFormScreenState();
}

class _ProductFormScreenState extends State<ProductFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _codigoController = TextEditingController();
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _precioController = TextEditingController();
  final TextEditingController _costoController = TextEditingController();
  final TextEditingController _precioPromoController = TextEditingController();
  final TextEditingController _ivaController = TextEditingController();

  void _sendData() {
    if (_formKey.currentState!.validate()) {
      // Formatear los valores decimales para usar punto (.) en lugar de coma (,)
      String precio = _precioController.text.replaceAll(',', '.');
      String costo = _costoController.text.replaceAll(',', '.');
      String precioPromo = _precioPromoController.text.replaceAll(',', '.');

      // Crear la cadena de datos del producto
      String productData =
          "${_codigoController.text}|${_nombreController.text}|$precio|$costo|$precioPromo|${_ivaController.text}";

      // Enviar los datos al servidor
      widget.onSubmit(productData);
      Navigator.pop(context);
    }
  }

  String? _validateTextField(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return 'Este campo es obligatorio';
    }
    return null;
  }

  String? _validateNumericField(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return 'Este campo es obligatorio';
    }
    if (double.tryParse(value.replaceAll(',', '.')) == null) {
      return 'Ingrese un valor numérico válido';
    }
    return null;
  }

  String? _validateLongField(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return 'Este campo es obligatorio';
    }
    if (int.tryParse(value) == null) {
      return 'Ingrese un número entero válido';
    }
    return null;
  }

  String? _validateIVA(String? value) {
    if (value == null || value.isEmpty) {
      return 'Este campo es obligatorio';
    }
    if (int.tryParse(value) == null) {
      return 'Ingrese un número entero válido';
    }
    int iva = int.parse(value);
    if (iva < 0 || iva > 100) {
      return 'El IVA debe estar entre 0 y 100';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Registrar Producto')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _codigoController,
                decoration: InputDecoration(labelText: 'Código de Barras'),
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
                validator: (value) => _validateLongField(value, 'Código de Barras'),
              ),
              TextFormField(
                controller: _nombreController,
                decoration: InputDecoration(labelText: 'Nombre'),
                validator: (value) => _validateTextField(value, 'Nombre'),
              ),
              TextFormField(
                controller: _precioController,
                decoration: InputDecoration(labelText: 'Precio'),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                validator: (value) => _validateNumericField(value, 'Precio'),
              ),
              TextFormField(
                controller: _costoController,
                decoration: InputDecoration(labelText: 'Costo'),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                validator: (value) => _validateNumericField(value, 'Costo'),
              ),
              TextFormField(
                controller: _precioPromoController,
                decoration: InputDecoration(labelText: 'Precio Promoción'),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                validator: (value) => _validateNumericField(value, 'Precio Promoción'),
              ),
              TextFormField(
                controller: _ivaController,
                decoration: InputDecoration(labelText: 'IVA'),
                keyboardType: TextInputType.number,
                validator: _validateIVA,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _sendData,
                child: Text('Registrar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}