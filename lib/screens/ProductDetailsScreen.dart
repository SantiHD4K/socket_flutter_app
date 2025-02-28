import 'package:flutter/material.dart';

class ProductDetailsScreen extends StatelessWidget {
  final Map<String, dynamic> productData;

  const ProductDetailsScreen({Key? key, required this.productData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F5F9),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF0F5F9),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: Color(0xFF636F81), size: 40),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Producto',
          style: TextStyle(
            fontFamily: 'Outfit',
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Color(0xFF161C24),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Material(
          color: Colors.transparent,
          elevation: 2.0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16.0),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  const Text(
                    'Detalles del Producto',
                    style: TextStyle(
                      fontFamily: 'Outfit',
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF161C24),
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  _buildDetailRow('Código de Barras', productData['CodigoBarra']),
                  _buildDetailRow('Nombre', productData['Nombre']),
                  _buildDetailRow('Precio', '\$${productData['Precio']}'),
                  _buildDetailRow('Costo', '\$${productData['Costo']}'),
                  _buildDetailRow('Precio Promoción', '\$${productData['PrecioPromo']}'),
                  _buildDetailRow('IVA', '${productData['IVA']}%'),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, dynamic value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontFamily: 'Manrope',
              fontSize: 12.0,
              fontWeight: FontWeight.w500,
              color: Color(0xFF636F81),
            ),
          ),
          Text(
            value.toString(),
            style: const TextStyle(
              fontFamily: 'Manrope',
              fontSize: 16.0,
              fontWeight: FontWeight.w500,
              color: Color(0xFF161C24),
            ),
          ),
        ],
      ),
    );
  }

}
