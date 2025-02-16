import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'package:socket_flutter_app/services/socket_service.dart';
import 'package:socket_flutter_app/utils/device_info.dart';
import 'dart:convert';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final TextEditingController _nameController = TextEditingController();
  final SocketService _socketService = SocketService();
  bool _isConnecting = false;
  String _errorMessage = "";

  void _startApp() async {
    if (_nameController.text.trim().isEmpty) {
      setState(() {
        _errorMessage = "Por favor, ingresa tu nombre";
      });
      return;
    }

    setState(() {
      _isConnecting = true;
      _errorMessage = "";
    });

    String dispositivo = await DeviceInfoUtil.getDeviceName();

    String token = _generateToken(_nameController.text.trim(), dispositivo);

    bool connected = await _socketService.connect(
      dispositivo,
      (response) {
        if (response == "LOGIN_EXITOSO") {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  HomeScreen(userName: _nameController.text.trim()),
            ),
          );
        } else {
          setState(() {
            _errorMessage = "Error en el login: $response";
            _isConnecting = false;
          });
        }
      },
    );

    if (!connected) {
      setState(() {
        _errorMessage = "Error al conectar con el servidor";
        _isConnecting = false;
      });
      return;
    }

    _socketService.sendMessage(
        "LOGIN|${_nameController.text.trim()}|$dispositivo|$token");
  }

  String _generateToken(String usuario, String dispositivo) {
    Map<String, dynamic> tokenData = {
      "usuario": usuario,
      "dispositivo": dispositivo,
      "fecha": DateTime.now().toIso8601String(),
    };

    String jsonToken = jsonEncode(tokenData);
    String tokenBase64 = base64Encode(utf8.encode(jsonToken));

    return tokenBase64;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Bienvenido",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: "Ingresa tu nombre",
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              if (_errorMessage.isNotEmpty)
                Text(
                  _errorMessage,
                  style: TextStyle(color: Colors.red, fontSize: 16),
                ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _isConnecting ? null : _startApp,
                child: _isConnecting
                    ? CircularProgressIndicator()
                    : Text("Continuar"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}