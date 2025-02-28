import 'package:flutter/material.dart';

class CustomDrawer extends StatelessWidget {
  final String userName;

  const CustomDrawer({Key? key, required this.userName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: 350,
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(vertical: 60, horizontal: 12),
            decoration: BoxDecoration(
              color: const Color(0xFF043275),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      userName,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Montserrat',
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      "Kodigo Fuente S.A.S",
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
                CircleAvatar(
                  radius: 30,
                  backgroundImage:
                      NetworkImage('https://picsum.photos/seed/903/600'),
                ),
              ],
            ),
          ),
          Stack(
            children: [
              Transform.translate(
                offset: Offset(0, -20),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      Expanded(
                        child: _buildMenuCard("Salientes"),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: _buildMenuCard("Procesados"),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          _buildSectionTitle("Información"),
          _buildMenuItem("Reportes"),
          _buildMenuItem("Consultas"),
          _buildMenuItem("Proveedores"),
          _buildMenuItem("Escáner"),
          _buildSectionTitle("Configuración"),
          _buildMenuItem("Conexiones"),
          _buildMenuItem("Cuenta"),
          _buildMenuItem("Acerca de"),
        ],
      ),
    );
  }

  Widget _buildMenuCard(String title) {
    return Container(
      height: 100,
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 8,
            spreadRadius: 2,
            offset: Offset(2, 4),
          ),
        ],
      ),
      child: Align(
        alignment: Alignment.topLeft,
        child: Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          title,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF95A1AC),
          ),
        ),
      ),
    );
  }

  Widget _buildMenuItem(String title) {
    return Column(
      children: [
        Divider(),
        ListTile(
          title: Text(
            title,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          onTap: () {},
        ),
      ],
    );
  }
}
