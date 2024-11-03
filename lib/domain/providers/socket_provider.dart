import 'package:picsa/main.dart';
import 'package:picsa/utilities/packages.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:socket_io_client/socket_io_client.dart';


class SocketProvider with ChangeNotifier {
  late IO.Socket _socket;

  SocketProvider() {
    _socket = IO.io('http://84.247.174.84:4007', OptionBuilder().setTransports(['websocket']).setExtraHeaders({
      'user': supabase.auth.currentUser?.id ?? '',
    }).build());
  }

  IO.Socket get socket => _socket;

  void disconnect() {
    _socket.disconnect();
  }

  @override
  void dispose() {
    _socket.disconnect();
    super.dispose();
  }

  void connect() {
    _socket.connect();

     _socket.onConnect((data) {
        logger.d("User connected successfully");
      });

      _socket.onConnectError((data) {
        logger.e('Connection error: $data');
      });
      _socket.onDisconnect((data) {
        logger.e('Disconnected: $data');
      });
      _socket.onError((data) {
        logger.e('Error: $data');
      });
  }

  void emit(String event, dynamic data) {
    _socket.emit(event, data);
  }

  // get images from on event image
  void on(String event, Function(dynamic) callback) {
    _socket.on(event, (data) {
      callback(data);
    });
  }

  void off(String event) {
    _socket.off(event);
  }


}