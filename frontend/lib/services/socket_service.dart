import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/status.dart' as status;

class SocketService {
  late WebSocketChannel _channel;
  final String uri;

  SocketService({required this.uri}) {
    _channel = WebSocketChannel.connect(Uri.parse(uri));
  }

  Stream<dynamic> get stream => _channel.stream;

  void send(String message) {
    _channel.sink.add(message);
  }

  void close() {
    _channel.sink.close(status.goingAway);
  }
}
