import 'dart:io';
import 'dart:convert';

class SocketService {
  Socket? socket;

  Future<bool> connect(String deviceName, Function(String) onDataReceived) async {
    const socketAddress = '192.168.23.224';
    const socketPort = 5000;

    try {
      socket = await Socket.connect(socketAddress, socketPort);
      socket!.listen(
        (data) => onDataReceived(utf8.decode(data).trim()),
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
    socket?.write(message + '\n');
  }

  void disconnect() {
    socket?.destroy();
  }
}
