import 'package:flutter/material.dart';

class EditProductContainer extends StatelessWidget {
  final TextEditingController barcodeController;
  final TextEditingController nameController;
  final TextEditingController priceController;
  final TextEditingController costController;

  const EditProductContainer({
    Key? key,
    required this.barcodeController,
    required this.nameController,
    required this.priceController,
    required this.costController,
  }) : super(key: key);

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

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
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
            children: [
              const Text(
                'Información del Producto',
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
                controller: barcodeController,
                hintText: 'Ingrese el código de barras',
              ),
              const SizedBox(height: 16.0),
              _buildTextField(
                label: 'Nombre',
                controller: nameController,
                hintText: 'Ingrese el nombre del producto',
              ),
              const SizedBox(height: 16.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: _buildTextField(
                      label: 'Precio',
                      controller: priceController,
                      hintText: '0.00',
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  const SizedBox(width: 16.0),
                  Expanded(
                    child: _buildTextField(
                      label: 'Costo',
                      controller: costController,
                      hintText: '0.00',
                      keyboardType: TextInputType.number,
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