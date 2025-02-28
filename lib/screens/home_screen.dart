import 'package:flutter/material.dart';
import '../widgets/dashboard_cards.dart';
import '../widgets/custom_drawer.dart';
import 'package:socket_flutter_app/screens/ScannerPage.dart';
import 'package:socket_flutter_app/screens/ProviderPage.dart';
import 'package:socket_flutter_app/screens/StorePage.dart';
import 'package:socket_flutter_app/screens/AccountsPage.dart';
import 'package:socket_flutter_app/services/socket_service.dart';
import 'package:socket_flutter_app/utils/device_info.dart';

class HomeScreen extends StatefulWidget {
  final String userName;
  final String token;

  const HomeScreen({super.key, required this.userName, required this.token});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _barcodeController = TextEditingController();
  final TextEditingController _deviceNameController = TextEditingController();
  String _serverResponse = "";
  String _deviceName = "Desconocido";

  @override
  void initState() {
    super.initState();
    _getDeviceName();
  }

  Future<void> _getDeviceName() async {
    String deviceName = await DeviceInfoUtil.getDeviceName();
    setState(() {
      _deviceName = deviceName;
      _deviceNameController.text = deviceName;
    });
  }

  Widget _buildQuickAccessButton(
      BuildContext context, IconData icon, String label) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        width: 120,
        height: 120,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color.fromARGB(255, 235, 236, 236),
            padding: EdgeInsets.zero,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          onPressed: () {
            if (label == "Escáner") {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ScannerPage(
                    token: widget.token,
                    userName: widget.userName,
                  ),
                ),
              );
            }
            if (label == "Proveedores") {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProviderPage()),
              );
            }
            if (label == "Sedes") {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => StorePage()),
              );
            }
            if (label == "Cuentas") {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AccountsPage()),
              );
            }
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 60, color: Color(0xFF95A1AC)),
              const SizedBox(height: 5),
              Text(
                label,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 12, color: Colors.black),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF043275),
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(
          "Hola ${widget.userName}!",
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      drawer: CustomDrawer(userName: widget.userName),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              const Text(
                "Accesos rápidos",
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _buildQuickAccessButton(context, Icons.qr_code, "Escáner"),
                    _buildQuickAccessButton(context, Icons.people, "Proveedores"),
                    _buildQuickAccessButton(context, Icons.store, "Sedes"),
                    _buildQuickAccessButton(context, Icons.account_circle, "Cuentas"),
                    _buildQuickAccessButton(context, Icons.contact_page, "Directorio"),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                "Panel principal",
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              DashboardCards(),
            ],
          ),
        ),
      ),
    );
  }
}
