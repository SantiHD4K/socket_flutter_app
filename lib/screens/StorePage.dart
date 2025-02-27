import 'package:flutter/material.dart';
import 'package:socket_flutter_app/screens/ProductsListScreen.dart';

class StorePage extends StatefulWidget {
  const StorePage({super.key});

  static String routeName = 'StorePage';
  static String routePath = '/storePage';

  @override
  State<StorePage> createState() => _StorePageState();
}

class _StorePageState extends State<StorePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F4F8),
      appBar: AppBar(
        backgroundColor: const Color(0xFF043275),
        leading: InkWell(
          onTap: () => Navigator.pop(context),
          child: const Padding(
            padding: EdgeInsets.all(8.0),
            child: Icon(
              Icons.arrow_back_rounded,
              color: Colors.white,
              size: 30.0,
            ),
          ),
        ),
        title: const Text(
          '11 sedes registradas',
          style: TextStyle(
            fontFamily: 'Poppins',
            color: Colors.white,
            fontSize: 22.0,
          ),
        ),
        elevation: 2.0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // Dos tarjetas por fila
            crossAxisSpacing: 16.0, // Espacio horizontal entre tarjetas
            mainAxisSpacing: 16.0, // Espacio vertical entre tarjetas
            childAspectRatio: 1, // Hace que sean cuadradas
          ),
          itemCount: 11,
          itemBuilder: (context, index) => _buildStoreCard(context),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF043275),
        onPressed: () {
          print('Agregar nueva sede');
        },
        child: const Icon(Icons.add_rounded, color: Colors.white, size: 30.0),
      ),
    );
  }

  Widget _buildStoreCard(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const ProductsListScreen()),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              blurRadius: 4.0,
              color: Colors.black12,
              offset: const Offset(0, 2),
            )
          ],
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Column(
          children: [
            ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(12.0)),
              child: Image.network(
                'https://images.unsplash.com/photo-1491637639811-60e2756cc1c7?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MjR8fHByb2R1Y3R8ZW58MHx8MHx8&auto=format&fit=crop&w=800&q=60',
                width: double.infinity,
                height: 150.0,
                fit: BoxFit.cover,
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'Sede X',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Lexend Deca',
                  fontSize: 14.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const Text(
              'Ubicación',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Lexend Deca',
                fontSize: 12.0,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
