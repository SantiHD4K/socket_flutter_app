import 'package:flutter/material.dart';
import 'package:socket_flutter_app/screens/product_form_screen.dart';
import 'package:socket_flutter_app/services/socket_service.dart';
import 'package:socket_flutter_app/utils/device_info.dart';

class HomeScreen extends StatefulWidget {
  final String userName;
  final String token;

  const HomeScreen({Key? key, required this.userName, required this.token})
      : super(key: key);

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Gestión de Productos')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              "Usuario: ${widget.userName}",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              "Dispositivo: $_deviceName",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
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
              onPressed: () => _sendMessage("CONSULTAR", _barcodeController.text),
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
      floatingActionButton: FloatingActionButton(
        onPressed: _isConnected ? _disconnectSocket : _connectSocket,
        tooltip: _isConnected ? 'Desconectar' : 'Conectar',
        child: Icon(_isConnected ? Icons.wifi_off : Icons.wifi),
      ),
    );
  }
}