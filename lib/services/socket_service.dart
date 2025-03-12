import 'dart:io';
import 'dart:convert';
import '../utils/device_info.dart';

class SocketService {
  Socket? socket;
  Function(String)? _onDataReceived;
  bool _isConnected = false;

  Future<bool> connect(
      String deviceName, Function(String) onDataReceived) async {
    if (_isConnected) {
      return true;
    }

    const socketAddress = '192.168.155.93';
    const socketPort = 5000;

    try {
      socket = await Socket.connect(socketAddress, socketPort);
      _isConnected = true;
      _onDataReceived = onDataReceived;

      socket!.listen(
        (data) {
          String response = utf8.decode(data).trim();
          print("Respuesta del servidor: $response");

          if (_onDataReceived != null) {
            _onDataReceived!(response);
          }
        },
        onError: (error) {
          print("Error en la conexión: $error");
          disconnect();
        },
        onDone: () {
          print(
              "Conexión cerrada por el servidor.");
          disconnect();
        },
      );

      socket!.write("$deviceName\n");
      return true;
    } catch (e) {
      _isConnected = false;
      return false;
    }
  }

  void sendMessage(String message) async {
    if (!_isConnected || socket == null) {
      String deviceName = await DeviceInfoUtil.getDeviceName();
      bool reconnected = await connect(deviceName, (data) {});

      if (!reconnected) {
        return;
      }
    }

    socket!.write('$message\r\n');
  }

  void sendMessageWithToken(
      String action, String token, List<String> data) async {
    if (!_isConnected || socket == null) {
      String deviceName = await DeviceInfoUtil.getDeviceName();
      bool reconnected = await connect(deviceName, (data) {});

      if (!reconnected) {
        print("Error: No se pudo reconectar al servidor.");
        return;
      }
    }

    List<String> cleanedData =
        data.map((value) => value.replaceAll('%', '').trim()).toList();
    String message = "$action|${cleanedData.join('|')}|$token";

    print("Enviando mensaje: $message");
    socket!.write('$message\r\n');
  }

  void disconnect() {
    if (_isConnected) {
      _isConnected = false;
      socket?.destroy();
      socket = null;
    }
  }

  void listen(Function(String) onDataReceived) {
    _onDataReceived = (data) {
      onDataReceived(data);
    };
  }

  bool get isConnected => _isConnected;
}