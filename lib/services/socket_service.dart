
import 'package:socket_io_client/socket_io_client.dart' as IO;

import '../../main.dart';
import '../constants/api_constants.dart';

class SocketService {
  void connect(String userId) {
    socket = IO.io(
      ApiConstants.baseUrl,
      IO.OptionBuilder()
          .setTransports(['websocket'])
          .setAuth({'userid': userId})
          .enableReconnection()
          .build(),
    );

    socket!.connect();

    socket!.onConnect((_) {
      print(' Connected to Socket Server');
    });

    socket!.onDisconnect((_) {
      print('❌ Disconnected from Socket Server');
    });

    socket!.onConnectError((err) {
      print('⚠️ Socket connection error: $err');
    });

    socket!.onError((err) {
      print('⚠️ Socket general error: $err');
    });
  }

  void disconnect() {
    socket?.disconnect();
    socket?.dispose();
    print("🔌 Socket Disconnected and Disposed");
  }
}
