import 'package:flutter/material.dart';
import '../widgets/dashboard_cards.dart';
import 'package:socket_flutter_app/screens/product_form_screen.dart';
import 'package:socket_flutter_app/screens/ScannerPage.dart';
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
  bool _isConnected = false;
  final SocketService _socketService = SocketService();

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

  void _connectSocket() async {
    bool connected = await _socketService.connect(
      _deviceNameController.text,
      (response) {
        setState(() => _serverResponse = response);
      },
    );
    setState(() => _isConnected = connected);
  }

  void _sendMessage(String action, String data) {
    String message = "$action|${widget.token}|${widget.userName}|$data";
    _socketService.sendMessage(message);
  }

  void _disconnectSocket() {
    _socketService.disconnect();
    setState(() => _isConnected = false);
  }

  void _navigateToForm() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProductFormScreen(
          onSubmit: (productData) {
            _socketService.sendMessage(
                "CREAR|${widget.token}|${widget.userName}|$productData");
          },
        ),
      ),
    );
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
            backgroundColor: const Color.fromARGB(255, 193, 195, 196),
            padding: EdgeInsets.zero,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          onPressed: () {
            if (label == "Escáner") {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ScannerPage()),
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
      drawer: Drawer(
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
                        widget.userName,
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
                          child: Container(
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
                                "Salientes",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: Container(
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
                                "Procesados",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Información",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF95A1AC),
                  ),
                ),
              ),
            ),
            Divider(),
            ListTile(
              title: Text(
                "Reportes",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              onTap: () {},
            ),
            Divider(),
            ListTile(
              title: Text(
                "Consultas",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              onTap: () {},
            ),
            Divider(),
            ListTile(
              title: Text(
                "Proveedores",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              onTap: () {},
            ),
            Divider(),
            ListTile(
              title: Text(
                "Escáner",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              onTap: () {},
            ),
            Divider(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Configuración",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF95A1AC),
                  ),
                ),
              ),
            ),
            Divider(),
            ListTile(
              title: Text(
                "Conexiones",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              onTap: () {},
            ),
            Divider(),
            ListTile(
              title: Text(
                "Cuenta",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              onTap: () {},
            ),
            Divider(),
            ListTile(
              title: Text(
                "Acerca de",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              onTap: () {},
            ),
            Divider(),
          ],
        ),
      ),
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
              DashboardCards(),
              const SizedBox(height: 20),
              Text(
                "Dispositivo: $_deviceName",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              TextField(
                controller: _barcodeController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Código de Barras',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: () =>
                    _sendMessage("CONSULTAR", _barcodeController.text),
                child: Text('Buscar Producto'),
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: _navigateToForm,
                child: Text('Registrar Producto'),
              ),
              SizedBox(height: 20),
              Text(
                _serverResponse,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _isConnected ? _disconnectSocket : _connectSocket,
        tooltip: _isConnected ? 'Desconectar' : 'Conectar',
        child: Icon(_isConnected ? Icons.wifi_off : Icons.wifi),
      ),
    );
  }
}
