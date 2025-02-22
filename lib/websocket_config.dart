import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/status.dart' as status;

class WebSocketConfig {
  late WebSocketChannel channel;
  final String serverUrl;

  WebSocketConfig({required this.serverUrl});

  void connect(Function(String) onMessageReceived, Function(String) onError) {
    channel = WebSocketChannel.connect(Uri.parse(serverUrl));

    channel.stream.listen(
          (message) {
        onMessageReceived(message);
      },
      onDone: () {
        onMessageReceived("Disconnected from WebSocket");
      },
      onError: (error) {
        onError(" Error: $error");
      },
    );
  }

  void sendMessage(String message) {
    if (message.isNotEmpty) {
      channel.sink.add(message);
    }
  }

  void closeConnection() {
    channel.sink.close(status.goingAway);
  }
}
