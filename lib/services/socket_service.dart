import 'dart:io';
import 'dart:convert';

class SocketService {
  Socket? socket;
  Function(String)? _onDataReceived;

  Future<bool> connect(String deviceName, Function(String) onDataReceived) async {
    const socketAddress = '192.168.214.93';
    const socketPort = 5000;

    try {
      socket = await Socket.connect(socketAddress, socketPort);
      _onDataReceived = onDataReceived;

      socket!.listen(
        (data) {
          String response = utf8.decode(data).trim();
          if (_onDataReceived != null) {
            _onDataReceived!(response);
          }
        },
        onError: (error) => disconnect(),
        onDone: () => disconnect(),
      );

      socket!.write("$deviceName\n");
      return true;
    } catch (e) {
      return false;
    }
  }

  void sendMessage(String message) {
    socket?.write('$message\n');
  }

  void sendMessageWithToken(String action, String token, String data) {
    String message = "$action|$token|$data";
    socket?.write('$message\n');
  }

  void disconnect() {
    socket?.destroy();
  }

  void listen(Function(String) onDataReceived) {
    _onDataReceived = onDataReceived;
  }
}
