import 'dart:convert';
import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:typed_data';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gestión de Productos',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      home: const MyHomePage(title: 'Gestión de Productos'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Socket? socket;
  bool _isConnected = false;
  TextEditingController _controller = TextEditingController();
  String _serverResponse = "";

  void _connectSocket() async {
    const socketAddress = '192.168.23.93';
    const socketPort = 5000;

    try {
      socket = await Socket.connect(socketAddress, socketPort,
          timeout: Duration(seconds: 5));
      setState(() => _isConnected = true);

      socket!.listen(
        (Uint8List data) {
          String response = utf8.decode(data);
          setState(() => _serverResponse = response);
        },
        onError: (error) => _disconnectSocket(),
        onDone: () => _disconnectSocket(),
      );
    } catch (e) {
      setState(() => _isConnected = false);
    }
  }

  void _sendMessage(String message) {
    if (socket != null && _isConnected) {
      socket!.write(message + '\n');
    } else {
      setState(
          () => _serverResponse = "No hay conexión activa con el servidor.");
    }
  }

  void _navigateToForm() {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => ProductFormScreen(onSubmit: _sendMessage)),
    );
  }

  void _disconnectSocket() {
    socket?.destroy();
    setState(() => _isConnected = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                  labelText: 'Código de Barras', border: OutlineInputBorder()),
            ),
            SizedBox(height: 10),
            ElevatedButton(
                onPressed: () => _sendMessage("CONSULTAR|${_controller.text}"),
                child: Text('Buscar')),
            SizedBox(height: 20),
            ElevatedButton(
                onPressed: _navigateToForm, child: Text('Registrar Producto')),
            SizedBox(height: 20),
            Text(_serverResponse,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center),
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

class ProductFormScreen extends StatefulWidget {
  final Function(String) onSubmit;

  ProductFormScreen({required this.onSubmit});

  @override
  _ProductFormScreenState createState() => _ProductFormScreenState();
}

class _ProductFormScreenState extends State<ProductFormScreen> {
  final TextEditingController _codigoController = TextEditingController();
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _precioController = TextEditingController();
  final TextEditingController _costoController = TextEditingController();
  final TextEditingController _precioPromoController = TextEditingController();
  final TextEditingController _ivaController = TextEditingController();

  void _sendData() {
    String message =
        "CREAR|${_codigoController.text}|${_nombreController.text}|${_precioController.text}|${_costoController.text}|${_precioPromoController.text}|${_ivaController.text}";
    widget.onSubmit(message);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Registrar Producto')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
                controller: _codigoController,
                decoration: InputDecoration(labelText: 'Código de Barras')),
            TextField(
                controller: _nombreController,
                decoration: InputDecoration(labelText: 'Nombre')),
            TextField(
                controller: _precioController,
                decoration: InputDecoration(labelText: 'Precio')),
            TextField(
                controller: _costoController,
                decoration: InputDecoration(labelText: 'Costo')),
            TextField(
                controller: _precioPromoController,
                decoration: InputDecoration(labelText: 'Precio Promoción')),
            TextField(
                controller: _ivaController,
                decoration: InputDecoration(labelText: 'IVA')),
            SizedBox(height: 20),
            ElevatedButton(onPressed: _sendData, child: Text('Registrar')),
          ],
        ),
      ),
    );
  }
}
