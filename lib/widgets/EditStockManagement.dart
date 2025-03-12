import 'package:flutter/material.dart';

class EditStockManagement extends StatefulWidget {
  final TextEditingController exitController;
  final TextEditingController rentMinController;
  final TextEditingController stockMinController;
  final TextEditingController proVentController;
  final TextEditingController stockMxnController;
  final TextEditingController proComprController;

  const EditStockManagement({
    Key? key,
    required this.exitController,
    required this.rentMinController,
    required this.stockMinController,
    required this.proVentController,
    required this.stockMxnController,
    required this.proComprController,
  }) : super(key: key);

  @override
  _EditStockManagementState createState() => _EditStockManagementState();
}

class _EditStockManagementState extends State<EditStockManagement> {
  String formatPercentage(String value) {
    if (value.isEmpty) return '';
    return value.contains('%') ? value : '$value%';
  }

  String cleanPercentage(String value) {
    return value.replaceAll('%', '').trim();
  }

  Widget _buildTextField(String label, TextEditingController controller, {bool isPercentage = false, bool isInteger = false}) {
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
          keyboardType: isInteger ? TextInputType.number : TextInputType.numberWithOptions(decimal: true),
          onTap: () {
            if (isPercentage) {
              setState(() {
                controller.text = cleanPercentage(controller.text);
              });
            }
          },
          onEditingComplete: () {
            if (isPercentage) {
              setState(() {
                controller.text = formatPercentage(controller.text);
              });
            }
          },
          onFieldSubmitted: (_) {
            if (isPercentage) {
              setState(() {
                controller.text = formatPercentage(controller.text);
              });
            }
          },
          decoration: InputDecoration(
            hintText: isPercentage ? '0.00%' : isInteger ? '0' : '0.00',
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
                color: Color(0xFF636F81),
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
    widget.proComprController.text = formatPercentage(widget.proComprController.text);
    widget.proVentController.text = formatPercentage(widget.proVentController.text);
    widget.rentMinController.text = formatPercentage(widget.rentMinController.text);

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
                'Existencias Actuales',
                style: TextStyle(
                  fontFamily: 'Outfit',
                  color: Color(0xFF161C24),
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: _buildTextField('Existencia', widget.exitController, isInteger: true),
                  ),
                  const SizedBox(width: 16.0),
                  Expanded(
                    child: _buildTextField('Stock Mínimo', widget.stockMinController, isInteger: true),
                  ),
                  const SizedBox(width: 16.0),
                  Expanded(
                    child: _buildTextField('Stock Máximo', widget.stockMxnController, isInteger: true),
                  ),
                ],
              ),
              const SizedBox(height: 16.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: _buildTextField('Prom. Compra', widget.proComprController, isPercentage: true),
                  ),
                  const SizedBox(width: 16.0),
                  Expanded(
                    child: _buildTextField('Prom. Venta', widget.proVentController, isPercentage: true),
                  ),
                  const SizedBox(width: 16.0),
                  Expanded(
                    child: _buildTextField('Rentabilidad Mínima', widget.rentMinController, isPercentage: true),
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
