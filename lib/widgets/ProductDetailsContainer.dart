import 'package:flutter/material.dart';

class ProductDetailsContainer extends StatelessWidget {
  final String plu;
  final bool isActive;
  final String price;
  final String cost;
  final String lastPurchase;
  final String lastSale;

  const ProductDetailsContainer({
    Key? key,
    required this.plu,
    required this.isActive,
    required this.price,
    required this.cost,
    required this.lastPurchase,
    required this.lastSale,
  }) : super(key: key);

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
                'Detalles del Producto',
                style: TextStyle(
                  fontFamily: 'Outfit',
                  color: Color(0xFF161C24),
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
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
                      color: isActive ? const Color(0xFFE8F5E9) : const Color(0xFFFFEBEE),
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        isActive ? 'Activo' : 'Inactivo',
                        style: TextStyle(
                          fontFamily: 'Manrope',
                          color: isActive ? const Color(0xFF2E7D32) : const Color(0xFFC62828),
                          fontSize: 12.0,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
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
                        'Última Compra',
                        style: TextStyle(
                          fontFamily: 'Manrope',
                          color: Color(0xFF636F81),
                          fontSize: 12.0,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        lastPurchase,
                        style: const TextStyle(
                          fontFamily: 'Manrope',
                          color: Color(0xFF161C24),
                          fontSize: 16.0,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      const Text(
                        'Última Venta',
                        style: TextStyle(
                          fontFamily: 'Manrope',
                          color: Color(0xFF636F81),
                          fontSize: 12.0,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        lastSale,
                        style: const TextStyle(
                          fontFamily: 'Manrope',
                          color: Color(0xFF161C24),
                          fontSize: 16.0,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
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